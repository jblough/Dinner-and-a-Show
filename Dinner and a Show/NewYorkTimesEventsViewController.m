//
//  NewYorkTimesEventsViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventsViewController.h"
#import "NewYorkTimesEventViewController.h"

#import "NewYorkTimesFetcher.h"
#import "SVProgressHUD.h"

#define kTimesURL @"http://www.nytimes.com"

@interface NewYorkTimesEventsViewController ()

@property (nonatomic, strong) NSMutableArray *events;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NewYorkTimesEventsSearchCriteria *criteria;

@end

@implementation NewYorkTimesEventsViewController

@synthesize events = _events;
//@synthesize tableView = _tableView;
@synthesize criteria = _criteria;

- (NSMutableArray *)events
{
    if (!_events) _events = [NSMutableArray array];
    return _events;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)doRefresh
{
    self.loading = NO;
}

- (void)loadMore
{
    int page = (int)([self.events count] / kNewYorkTimesEventsPageSize);
    [NewYorkTimesFetcher events:page onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.events addObjectsFromArray:data];
            
            NSLog(@"comparing %d to %d", [data count], kNewYorkTimesEventsPageSize);
            self.endReached = [data count] < kNewYorkTimesEventsPageSize;
            if (self.view.window)
                [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}

- (void)loadEvents
{
    [SVProgressHUD showWithStatus:@"Downloading events"];
    [NewYorkTimesFetcher events:^(NSArray *events) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.events addObjectsFromArray:events];
            [SVProgressHUD dismiss];
            if (self.view.window)
                [self.tableView reloadData];
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
	// Do any additional setup after loading the view.
    self.numberOfSections = 1;
    //[self loadEvents];
}

- (void)viewDidUnload
{
    //[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    NSLog(@"returning %d rows", [self.events count]);
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.numberOfSections) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"NYT Event List Cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NewYorkTimesEvent *event = [self.events objectAtIndex:indexPath.row];
    //cell.titleLabel.text = event.title;
    //cell.summaryLabel.text = event.summary;
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NYT Event Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [(NewYorkTimesEventViewController *)segue.destinationViewController setEvent:[self.events objectAtIndex:indexPath.row]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"NYT Event Search Segue"]) {
        [(NewYorkTimesEventsSearchViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)visitWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTimesURL]];
}

#pragma mark - NewYorkTimesEventsSearchDelegate methods
- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)searchNewYorkTimesEvents:criteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.criteria = criteria;
    
    // Update the app delegate with user specified values
    /*
    BOOL userSpecifiedZipCodeChanged = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.criteria.zipCode && ![appDelegate.zipCode isEqualToString:self.criteria.zipCode]) {
        appDelegate.userSpecifiedCode = self.criteria.zipCode;
        userSpecifiedZipCodeChanged = YES;
    }
    
    // Kick off the search
    [self.events removeAllObjects];
    // If the search criteria was removed, reset
    if (!userSpecifiedZipCodeChanged &&
        (!criteria.searchTerm || [@"" isEqualToString:criteria.searchTerm])) {
        self.criteria = nil;
        [self loadMore];
        //[self.tableView reloadData];
    }
    else {
        int page = 0;
        [PatchFetcher events:criteria page:page onCompletion:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.events addObjectsFromArray:data];
                self.endReached = YES;
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
     */
}

- (NewYorkTimesEventsSearchCriteria *)getNewYorkTimesEventCriteria
{
    return self.criteria;
}

@end
