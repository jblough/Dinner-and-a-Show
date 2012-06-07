//
//  RestaurantViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantDetailsViewController.h"
#import "CalendarEvent.h"

#import <MapKit/MapKit.h>

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

//#import "YelpFetcher.h"
#import "FactualFetcher.h"

#define kHeadingSection 0
#define kAddressSection 1
#define kMapSection 2

@interface RestaurantViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addressLineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *callRestaurantButton;
@property (weak, nonatomic) IBOutlet UIButton *visitWebPageButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage5;

- (void)populateTable;

@end

@implementation RestaurantViewController

@synthesize addressLineOneLabel = _addressLineOneLabel;
@synthesize addressLineTwoLabel = _addressLineTwoLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize map = _map;
@synthesize callRestaurantButton = _callRestaurantButton;
@synthesize visitWebPageButton = _visitWebPageButton;
@synthesize ratingLabel = _ratingLabel;
@synthesize ratingImage1 = _ratingImage1;
@synthesize ratingImage2 = _ratingImage2;
@synthesize ratingImage3 = _ratingImage3;
@synthesize ratingImage4 = _ratingImage4;
@synthesize ratingImage5 = _ratingImage5;
@synthesize restaurant = _restaurant;
@synthesize originalEvent = _originalEvent;

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
    /*[SVProgressHUD showWithStatus:@"Loading restaurant information"];
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
    }];*/

    FactualFetcher *fetcher = [[FactualFetcher alloc] init];
    [SVProgressHUD showWithStatus:@"Loading restaurant information"];
    [fetcher loadFullRestaurant:self.restaurant onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data && [data count] == 1)
                self.restaurant = [data objectAtIndex:0];
            else
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
    
    if (self.originalEvent)
        self.restaurant = self.originalEvent.restaurant;
    [self populateTable];
}

- (void)viewDidUnload
{
    [self setMap:nil];
    [self setAddressLineOneLabel:nil];
    [self setAddressLineTwoLabel:nil];
    [self setPhoneLabel:nil];
    [self setCallRestaurantButton:nil];
    [self setVisitWebPageButton:nil];
    [self setRatingLabel:nil];
    [self setRatingImage1:nil];
    [self setRatingImage2:nil];
    [self setRatingImage3:nil];
    [self setRatingImage4:nil];
    [self setRatingImage5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
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

- (void)setRatingImages:(float)rating
{
    // Handle whole stars
    if (rating >= 1) {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 2) {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 3) {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 4) {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 5) {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    // Handle 1/2 stars
    if (rating == 4.5) {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 3.5) {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 2.5) {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 1.5) {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 0.5) {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
}

- (void)populateTable
{
    self.callRestaurantButton.hidden = (self.restaurant.phone) ? NO : YES;
    self.visitWebPageButton.hidden = (self.restaurant.url) ? NO : YES;

    /*[self.ratingImage setImageWithURL:[NSURL URLWithString:self.restaurant.largeRatingUrl]
                         placeholderImage:[UIImage imageNamed:@"blank.gif"]];*/
    [self setRatingImages:self.restaurant.rating];
    self.ratingLabel.text = [NSString stringWithFormat:@"rating %.1f", self.restaurant.rating];

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
    else if ([segue.identifier isEqualToString:@"Add Restaurant Segue"]) {
        UINavigationController *navController = segue.destinationViewController;
        [(AddRestaurantToScheduleViewController *)navController.topViewController setDelegate:self];
        if (self.originalEvent)
            [(AddRestaurantToScheduleViewController *)navController.topViewController setOriginalEvent:self.originalEvent];
    }
}

#pragma mark -
#pragma mark AddRestaurantDelegate
- (void)add:(AddRestaurantToScheduleOptions *)options sender:(id)sender
{
    // Delete the original event
    [self.originalEvent deleteEvent];
    
    // Add to database
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.restaurant = self.restaurant;
    [library addRestaurantEventToSchedule:options];
    
    // Add to calendar
    if (options.reminder) {
        CalendarEvent *event = [[CalendarEvent alloc] init];
        event.eventId = [NSString stringWithFormat:@"%@ - %@", self.restaurant.identifier, options.when];
        event.type = @"restaurant";
        event.identifier = self.restaurant.identifier;
        event.title = options.restaurant.name;
        event.url = options.restaurant.url;
        event.location = [NSString stringWithFormat:@"%@ %@, %@ %@", [options.restaurant.location.displayAddress objectAtIndex:0], options.restaurant.location.city, options.restaurant.location.state, options.restaurant.location.postalCode];
        event.notes = options.restaurant.phone;
        event.startDate = options.when;
        event.reminder = options.reminder;
        event.minutesBefore = options.minutesBefore;
        event.followUp = options.followUp;
        if (options.followUp) {
            event.followUpUrl = options.restaurant.url;
            event.followUpWhen = options.followUpDate;
        }
        [appDelegate addToCalendar:event];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
