//
//  RestaurantListTableViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantListTableViewController.h"
#import "YelpFetcher.h"
#import "Restaurant.h"
#import "RestaurantDetailsViewController.h"

#define kYelpURL @"http://www.yelp.com"

@interface RestaurantListTableViewController ()

@property (nonatomic, strong) NSMutableArray *restaurants;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RestaurantListTableViewController

@synthesize cuisine = _cuisine;
@synthesize restaurants = _restaurants;
@synthesize tableView = _tableView;

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
    YelpFetcher *fetcher = [[YelpFetcher alloc] init];
    [fetcher restaurantsForCuisine:self.cuisine onCompletion:^(id data) {
        NSArray *restaurants = data;
        [self.restaurants addObjectsFromArray:restaurants];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Restaurant List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
    cell.textLabel.text = restaurant.name;
    /*if ([restaurant.location.displayAddress count] > 0) {
        cell.detailTextLabel.text = [restaurant.location.displayAddress objectAtIndex:0];
    }
    else {
        cell.detailTextLabel.text = @"";
    }*/
    
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [(RestaurantDetailsViewController *)segue.destinationViewController setRestaurant:[self.restaurants objectAtIndex:indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)visitYelpSite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kYelpURL]];
}

@end
