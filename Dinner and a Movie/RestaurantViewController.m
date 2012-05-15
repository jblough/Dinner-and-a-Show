//
//  RestaurantViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantDetailsViewController.h"
#import <MapKit/MapKit.h>

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "YelpFetcher.h"

#define kHeadingSection 0
#define kAddressSection 1
#define kMapSection 2

@interface RestaurantViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;

- (void)populateTable;

@end

@implementation RestaurantViewController

@synthesize restaurantImage = _restaurantImage;
@synthesize ratingImage = _ratingImage;
@synthesize addressLineOneLabel = _addressLineOneLabel;
@synthesize addressLineTwoLabel = _addressLineTwoLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize map = _map;
@synthesize restaurant = _restaurant;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self clearTable];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [SVProgressHUD showWithStatus:@"Loading restaurant information"];
    [YelpFetcher loadFullRestaurant:self.restaurant onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.restaurant = data;
            //[self.recipeWebview loadHTMLString:[self recipeAsHtml] baseURL:nil];
            [SVProgressHUD dismiss];
            
            //[self.tableView reloadData];
            [self populateTable];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithError:error.localizedDescription];
        });
    }];
}

- (void)viewDidUnload
{
    [self setRestaurantImage:nil];
    [self setRatingImage:nil];
    [self setMap:nil];
    [self setAddressLineOneLabel:nil];
    [self setAddressLineTwoLabel:nil];
    [self setPhoneLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kHeadingSection:
            return self.restaurant.name;
            break;
            
        case kAddressSection:
            return @"Address";
            break;
            
        case kMapSection:
            return @"Map";
            break;
            
        default:
            break;
    }
    
    return @"";
}


- (void)clearTable
{
    self.addressLineOneLabel.text = @"";
    self.addressLineTwoLabel.text = @"";
    self.phoneLabel.text = @"";
}

- (void)populateTable
{
    [self.restaurantImage setImageWithURL:[NSURL URLWithString:self.restaurant.imageUrl]
                     placeholderImage:[UIImage imageNamed:@"blank.gif"]];
    
    [self.ratingImage setImageWithURL:[NSURL URLWithString:self.restaurant.largeRatingUrl]
                         placeholderImage:[UIImage imageNamed:@"blank.gif"]];
    
    //self.addressLineOneLabel.text =  [self.restaurant.location.address objectAtIndex:0];
    self.addressLineOneLabel.text = [self.restaurant.location.displayAddress objectAtIndex:0];
    self.addressLineTwoLabel.text =  [NSString stringWithFormat:@"%@, %@ %@", 
                                      self.restaurant.location.city, 
                                      self.restaurant.location.state, 
                                      self.restaurant.location.postalCode];
    //self.addressLineTwoLabel.text = [self.restaurant.location.displayAddress objectAtIndex:1];
    self.phoneLabel.text = self.restaurant.phone;
    
    // Add location on Map
    CLLocationCoordinate2D annotationCoord;
    
    NSLog(@"Adding map marker for %.2f, %.2f", self.restaurant.location.latitude, self.restaurant.location.longitude);
    annotationCoord.latitude = self.restaurant.location.latitude;
    annotationCoord.longitude = self.restaurant.location.longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = self.restaurant.name;
    annotationPoint.subtitle = [self.restaurant.location.displayAddress objectAtIndex:0];
    [self.map addAnnotation:annotationPoint];
    
    self.map.centerCoordinate = annotationCoord;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
    self.map.region = [self.map regionThatFits:region];
}

- (IBAction)callRestaurant:(id)sender
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Visit Yelp Segue"]) {
        [(RestaurantDetailsViewController *)segue.destinationViewController setRestaurant:self.restaurant];
    }
}

@end
