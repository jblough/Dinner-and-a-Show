//
//  RestaurantListTableViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantListTableViewController.h"
#import "RestaurantViewController.h"
#import "RestaurantSearchViewController.h"
#import "RestaurantListingTableCell.h"

#import "AppDelegate.h"

#import "SVProgressHUD.h"

//#import "YelpFetcher.h"
#import "FactualFetcher.h"

#import "Restaurant.h"

#define kYelpURL @"http://www.yelp.com"

@interface RestaurantListTableViewController ()

@property (nonatomic, strong) NSMutableArray *restaurants;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *favorites;
@property (nonatomic, strong) RestaurantSearchCriteria *criteria;

@end

@implementation RestaurantListTableViewController

@synthesize cuisine = _cuisine;
@synthesize restaurants = _restaurants;
//@synthesize tableView = _tableView;
@synthesize favorites = _favorites;
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

- (void)doRefresh
{
    self.loading = NO;
}

- (void)initCriteria
{
    self.criteria = [[RestaurantSearchCriteria alloc] init];
}

- (void)loadMore
{
    //[SVProgressHUD showWithStatus:@"Download restaurants"];
    
    //self.endReached = NO;
    
    FactualFetcher *fetcher = [[FactualFetcher alloc] init];
    
    int page = (int)([self.restaurants count] / kFactualRestaurantPageSize);
    //[YelpFetcher restaurantsForCuisine:self.cuisine page:page onCompletion:^(id data) {
    //[YelpFetcher restaurantsForCuisine:self.cuisine search:self.criteria page:page onCompletion:^(id data) {
    //[FactualFetcher restaurantsForCuisine:self.cuisine search:self.criteria page:page onCompletion:^(id data) {
    [fetcher restaurantsForCuisine:self.cuisine page:page onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.restaurants addObjectsFromArray:data];
            
            NSLog(@"comparing %d to %d", [self.restaurants count], [data count]);
            self.endReached = [data count] < kFactualRestaurantPageSize;

            [self.tableView reloadData];
            //[SVProgressHUD dismiss];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[SVProgressHUD dismissWithError:error.localizedDescription];
            NSLog(@"Error - %@", error.localizedDescription);
            self.endReached = YES;
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
    
    self.numberOfSections = 1;
    
    [self initCriteria];
    
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.favorites = [NSMutableSet setWithSet:[appDelete.eventLibrary getFavoriteRestaurants]];
    //[self loadMore];
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
    if (section == self.numberOfSections) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return [self.restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.numberOfSections) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"Restaurant List Cell";
    RestaurantListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];

    [cell displayRestaurant:restaurant isFavorite:[self.favorites containsObject:restaurant.identifier]];
    
    /*
    if ([self.favorites containsObject:restaurant.identifier]) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    }
    */
    
    return cell;
}

- (IBAction)toggleFavoriteStatus:(UIButton *)sender forEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:[touch locationInView:self.tableView]];
    Restaurant *restaurant = [self.restaurants objectAtIndex:path.row];
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.favorites containsObject:restaurant.identifier]) {
        [self.favorites removeObject:restaurant.identifier];
        [sender setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
        
        [appDelete.eventLibrary unfavoriteRestaurant:restaurant];
    }
    else {
        [self.favorites addObject:restaurant.identifier];
        [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        
        [appDelete.eventLibrary favoriteRestaurant:restaurant];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Restaurant Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        [(RestaurantViewController *)segue.destinationViewController setRestaurant:[self.restaurants objectAtIndex:indexPath.row]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"Restaurant Search Segue"]) {
        [(RestaurantSearchViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)visitYelpSite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kYelpURL]];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)search:(RestaurantSearchCriteria *)criteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.criteria = criteria;
    
    // Update the app delegate with user specified values
    /*BOOL userSpecifiedZipCodeChanged = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.criteria.zipCode && ![appDelegate.zipCode isEqualToString:self.criteria.zipCode]) {
        appDelegate.userSpecifiedCode = self.criteria.zipCode;
        userSpecifiedZipCodeChanged = YES;
    }*/
    
    // Kick off the search
    [self.restaurants removeAllObjects];
    [self.tableView reloadData];
    //self.endReached = YES;
    
    // If the search criteria was removed, reset
    if (criteria.useCurrentLocation &&
        (!criteria.searchTerm || [@"" isEqualToString:criteria.searchTerm])) {
        // Reset to the passed in cuisine 
        //[self loadMore];
        self.endReached = NO;
        [self.tableView reloadData];
    }
    else {
        FactualFetcher *fetcher = [[FactualFetcher alloc] init];
        [fetcher restaurantsForCuisine:self.cuisine search:criteria page:0 onCompletion:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.restaurants addObjectsFromArray:data];
                
                self.endReached = YES;
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
}

- (RestaurantSearchCriteria *)getCriteria
{
    return self.criteria;
}

@end
