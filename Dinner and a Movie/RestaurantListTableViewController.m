//
//  RestaurantListTableViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantListTableViewController.h"
#import "RestaurantDetailsViewController.h"
#import "RestaurantSearchViewController.h"
#import "RestaurantListingTableCell.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "YelpFetcher.h"

#import "Restaurant.h"

#define kYelpURL @"http://www.yelp.com"

@interface RestaurantListTableViewController ()

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RestaurantSearchCriteria *criteria;

@end

@implementation RestaurantListTableViewController

@synthesize cuisine = _cuisine;
@synthesize restaurants = _restaurants;
@synthesize tableView = _tableView;
@synthesize criteria = _criteria;

- (NSMutableArray *)restaurants
{
    if (!_restaurants) _restaurants = [[NSMutableArray alloc] init];
    return _restaurants;
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)loadMore
{
    [SVProgressHUD showWithStatus:@"Download restaurants"];
    
    YelpFetcher *fetcher = [[YelpFetcher alloc] init];
    [fetcher restaurantsForCuisine:self.cuisine onCompletion:^(id data) {
        NSArray *restaurants = data;
        [self.restaurants addObjectsFromArray:restaurants];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithError:error.localizedDescription];
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.cuisine.name;
    [self loadMore];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Restaurant List Cell";
    RestaurantListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
    cell.nameLabel.text = restaurant.name;
    
    [cell.restaurantImage setImageWithURL:[NSURL URLWithString:restaurant.imageUrl]
                   placeholderImage:[UIImage imageNamed:@"restaurant_placeholder.png"]];

    [cell.ratingImage setImageWithURL:[NSURL URLWithString:restaurant.ratingUrl]
                   placeholderImage:[UIImage imageNamed:@"blank.gif"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Recipe Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        [(RestaurantDetailsViewController *)segue.destinationViewController setRestaurant:[self.restaurants objectAtIndex:indexPath.row]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"Restaurant Search Segue"]) {
        [(RestaurantSearchViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)visitYelpSite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kYelpURL]];
}

- (void)search:(RestaurantSearchCriteria *)criteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.criteria = criteria;
}

- (RestaurantSearchCriteria *)getCriteria
{
    return self.criteria;
}

@end
