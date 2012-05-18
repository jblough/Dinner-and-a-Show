//
//  FormOfEntertainmentViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FormOfEntertainmentViewController.h"

#import "LocalEventsViewController.h"
#import "NewYorkTimesEventsViewController.h"
#import "LocalEventListingTableCell.h"

#import "NewYorkTimesEventViewController.h"
#import "NewYorkTimesEventsSearchViewController.h"

#import "LocalEventViewController.h"
#import "LocalEventsSearchViewController.h"

#import "NewYorkTimesEvent.h"
#import "PatchEvent.h"

#import "PatchFetcher.h"
#import "NewYorkTimesFetcher.h"

#import "PatchEvent.h"
#import "NewYorkTimesEvent.h"
#import "LocalEventsSearchCriteria.h"
#import "NewYorkTimesEventsSearchCriteria.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "UIAlertView+Blocks.h"

#import "SVProgressHUD.h"

#define kLocalEventsIndex 0
#define kNYTimesEventsIndex 1

#define kTimesURL @"http://www.nytimes.com"
#define kPatchURL @"http://patch.com"

@interface FormOfEntertainmentViewController ()

@property (nonatomic, strong) NSMutableArray *localEvents;
@property (nonatomic, strong) NSMutableArray *newYorkTimesEvents;

@property (weak, nonatomic) IBOutlet UISegmentedControl *dataSourceSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *visitDataSourceButton;

@property (nonatomic, strong) LocalEventsSearchCriteria *localCriteria;
@property (nonatomic, strong) NewYorkTimesEventsSearchCriteria *nyTimesEventsCriteria;

@property (nonatomic, strong) LocalEventsViewController *localEventsController;
@property (nonatomic, strong) NewYorkTimesEventsViewController *newYorkTimesEventsController;

@property (nonatomic, strong) UIBarButtonItem *searchButton;
@end

@implementation FormOfEntertainmentViewController

@synthesize localEvents = _localEvents;
@synthesize newYorkTimesEvents = _newYorkTimesEvents;
@synthesize dataSourceSegmentedControl = _dataSourceSegmentedControl;
@synthesize tableView = _tableView;
@synthesize visitDataSourceButton = _visitDataSourceButton;
@synthesize localCriteria = _localCriteria;
@synthesize localEventsController = _localEventsController;
@synthesize newYorkTimesEventsController = _newYorkTimesEventsController;
@synthesize nyTimesEventsCriteria = _nyTimesEventsCriteria;
@synthesize searchButton = _searchButton;


- (NSMutableArray *)localEvents {
    if (!_localEvents) _localEvents = [NSMutableArray array];
    return _localEvents;
}

- (NSMutableArray *)newYorkTimesEvents {
    if (!_newYorkTimesEvents) _newYorkTimesEvents = [NSMutableArray array];
    return _newYorkTimesEvents;
}

- (LocalEventsViewController *)localEventsController
{
    if (!_localEventsController) _localEventsController = [[LocalEventsViewController alloc] init];
    return _localEventsController;
}

- (NewYorkTimesEventsViewController *)newYorkTimesEventsController
{
    if (!_newYorkTimesEventsController) _newYorkTimesEventsController = [[NewYorkTimesEventsViewController alloc] init];
    return _newYorkTimesEventsController;
}

- (void)doRefresh
{
    self.loading = NO;
}

- (void)loadMore
{
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        int page = (int)([self.localEvents count] / kLocalEventPageSize);
        [PatchFetcher events:page onCompletion:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.localEvents addObjectsFromArray:data];
                
                NSLog(@"comparing %d to %d", [data count], kLocalEventPageSize);
                self.endReached = [data count] < kLocalEventPageSize;
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
    else {
        int page = (int)([self.newYorkTimesEvents count] / kNewYorkTimesEventsPageSize);
        [NewYorkTimesFetcher events:page onCompletion:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newYorkTimesEvents addObjectsFromArray:data];
                
                NSLog(@"comparing %d to %d", [data count], kNewYorkTimesEventsPageSize);
                self.endReached = [data count] < kNewYorkTimesEventsPageSize;
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.searchButton) self.searchButton = [[UIBarButtonItem alloc] 
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    self.parentViewController.navigationItem.rightBarButtonItem = self.searchButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.numberOfSections = 1;

    //self.localEventsController.numberOfSections = 1;
    //self.newYorkTimesEventsController.numberOfSections = 1;
    
    //[self.tableView setDataSource:self.localEventsController];
    //[self.tableView setDelegate:self.localEventsController];
}

- (void)viewDidUnload
{
    [self setDataSourceSegmentedControl:nil];
    [self setTableView:nil];
    [self setVisitDataSourceButton:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.numberOfSections) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) ? 
    [self.localEvents count] : [self.nyTimesEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView localEventCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Event List Cell";
    LocalEventListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    PatchEvent *event = [self.localEvents objectAtIndex:indexPath.row];
    cell.titleLabel.text = event.title;
    cell.summaryLabel.text = event.summary;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView nyTimesEventCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NYT Event List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NewYorkTimesEvent *event = [self.nyTimesEvents objectAtIndex:indexPath.row];
    //cell.titleLabel.text = event.title;
    //cell.summaryLabel.text = event.summary;
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.description;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.numberOfSections) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        return [self tableView:tableView localEventCellForRowAtIndexPath:indexPath];
    }
    else if (self.dataSourceSegmentedControl.selectedSegmentIndex == kNYTimesEventsIndex) {
        return [self tableView:tableView nyTimesEventCellForRowAtIndexPath:indexPath];
    }
    else {
        return nil;
    }
}
*/
#pragma mark - Local Events methods
/*
- (void)doRefresh
{
    self.loading = NO;
}

- (void)loadLocalMore
{
    int page = (int)([self.localEvents count] / kLocalEventPageSize);
    [PatchFetcher events:page onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.localEvents addObjectsFromArray:data];
            
            NSLog(@"comparing %d to %d", [data count], kLocalEventPageSize);
            self.endReached = [data count] < kLocalEventPageSize;
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}


- (void)loadLocalEvents
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appDelegate.zipCode || [@"" isEqualToString:appDelegate.zipCode]) {
        
        [UIAlertView showAlertViewWithTitle:@"Zip Code" 
                                    message:@"Please enter zip code" 
                          cancelButtonTitle:@"Cancel" 
                          otherButtonTitles:[NSArray arrayWithObject:@"OK"] 
                                  onDismiss:^(NSString *text) {
                                      appDelegate.userSpecifiedCode = text;
                                      
                                      [SVProgressHUD showWithStatus:@"Downloading events"];
                                      [PatchFetcher events:^(NSArray *events) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.localEvents addObjectsFromArray:events];
                                              [SVProgressHUD dismiss];
                                              [self.tableView reloadData];
                                          });
                                      } onError:^(NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [SVProgressHUD dismissWithError:error.localizedDescription];
                                          });
                                      }];
                                  } 
                                   onCancel:^{
                                   }];
    }
    else {
        [SVProgressHUD showWithStatus:@"Downloading events"];
        [PatchFetcher events:^(NSArray *events) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.localEvents addObjectsFromArray:events];
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:error.localizedDescription];
            });
        }];
    }
}
*/
- (IBAction)changedType:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == kLocalEventsIndex) {
        [self.visitDataSourceButton setImage:[UIImage imageNamed:@"patch40.png"] forState:UIControlStateNormal];
        //[self.tableView setDataSource:self.localEventsController];
        //[self.tableView setDelegate:self.localEventsController];
        if ([self.localEvents count] < 1) self.endReached = NO;
        [self.tableView reloadData];
    }
    else if (sender.selectedSegmentIndex == kNYTimesEventsIndex) {
        [self.visitDataSourceButton setImage:[UIImage imageNamed:@"poweredby_nytimes_200a.png"] forState:UIControlStateNormal];
        //[self.tableView setDataSource:self.newYorkTimesEventsController];
        //[self.tableView setDelegate:self.newYorkTimesEventsController];
        if ([self.newYorkTimesEvents count] < 1) self.endReached = NO;
        [self.tableView reloadData];
    }
}

- (IBAction)visitDataSource
{
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPatchURL]];
    }
    else if (self.dataSourceSegmentedControl.selectedSegmentIndex == kNYTimesEventsIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTimesURL]];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.numberOfSections) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }

    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        NSLog(@"Returning %d rows", [self.localEvents count]);
        return [self.localEvents count];
    }
    else {
        NSLog(@"Returning %d rows", [self.newYorkTimesEvents count]);
        return [self.newYorkTimesEvents count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.numberOfSections) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        //return [self.localEventsController tableView:tableView cellForRowAtIndexPath:indexPath];
        static NSString *CellIdentifier = @"Event List Cell2";
        LocalEventListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        PatchEvent *event = [self.localEvents objectAtIndex:indexPath.row];
        cell.titleLabel.text = event.title;
        cell.summaryLabel.text = event.summary;
        
        cell.summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.summaryLabel.numberOfLines = 0;
        
        /*CGSize s = [cell.summaryLabel.text sizeWithFont:[UIFont systemFontOfSize:17] 
                                      constrainedToSize:CGSizeMake(cell.summaryLabel.frame.size.width, 750)];
        cell.summaryLabel.frame = CGRectMake(cell.summaryLabel.frame.origin.x, 
                                             cell.summaryLabel.frame.origin.y, 
                                             cell.summaryLabel.frame.size.width, s.height);*/
        
        return cell;
    }
    else {
        //return [self.newYorkTimesEventsController tableView:tableView cellForRowAtIndexPath:indexPath];
        static NSString *CellIdentifier = @"NYT Event List Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        NewYorkTimesEvent *event = [self.newYorkTimesEvents objectAtIndex:indexPath.row];
        //cell.titleLabel.text = event.title;
        //cell.summaryLabel.text = event.summary;
        cell.textLabel.text = event.name;
        cell.detailTextLabel.text = event.description;
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        return 75;
    }
    else {
        return 50;//[super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


#pragma mark - NewYorkTimesEventsSearchDelegate methods
- (void)searchNewYorkTimesEvents:nyTimesEventsCriteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.nyTimesEventsCriteria = nyTimesEventsCriteria;
    
    
    // Kick off the search
    [self.newYorkTimesEvents removeAllObjects];
    [self.tableView reloadData];
    
    //[SVProgressHUD showWithStatus:@"Downloading events"];

    int page = 0;
    [NewYorkTimesFetcher events:self.nyTimesEventsCriteria page:page onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newYorkTimesEvents addObjectsFromArray:data];
            self.endReached = YES;
            [self.tableView reloadData];
            //[SVProgressHUD dismiss];
        });
    } onError:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
        //[SVProgressHUD dismissWithError:error.localizedDescription];
    }];
}

- (NewYorkTimesEventsSearchCriteria *)getNewYorkTimesEventCriteria
{
    return self.nyTimesEventsCriteria;
}

#pragma mark - LocalEventsSearchDelegate methods
- (void)searchLocalEvents:(LocalEventsSearchCriteria *)localCriteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.localCriteria = localCriteria;
    
    // Update the app delegate with user specified values
    BOOL userSpecifiedZipCodeChanged = NO;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.localCriteria.zipCode && ![appDelegate.zipCode isEqualToString:self.localCriteria.zipCode]) {
        appDelegate.userSpecifiedCode = self.localCriteria.zipCode;
        userSpecifiedZipCodeChanged = YES;
    }
    
    // Kick off the search
    [self.localEvents removeAllObjects];
    [self.tableView reloadData];

    [SVProgressHUD showWithStatus:@"Downloading events"];
    
    // If the search criteria was removed, reset
    if (!userSpecifiedZipCodeChanged &&
        (!localCriteria.searchTerm || [@"" isEqualToString:localCriteria.searchTerm])) {
        self.localCriteria = nil;
        [self loadMore];
        //[self.tableView reloadData];
        [SVProgressHUD dismiss];
    }
    else {
        int page = 0;
        [PatchFetcher events:localCriteria page:page onCompletion:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.localEvents addObjectsFromArray:data];
                self.endReached = YES;
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
            [SVProgressHUD dismissWithError:error.localizedDescription];
        }];
    }
}

- (LocalEventsSearchCriteria *)getLocalEventCriteria
{
    return self.localCriteria;
}

- (IBAction)search:(id)sender
{
    if (self.dataSourceSegmentedControl.selectedSegmentIndex == kLocalEventsIndex) {
        [self performSegueWithIdentifier:@"Local Events Search Segue" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"NYT Event Search Segue" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NYT Event Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [(NewYorkTimesEventViewController *)segue.destinationViewController setEvent:[self.newYorkTimesEvents objectAtIndex:indexPath.row]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"NYT Event Search Segue"]) {
        [(NewYorkTimesEventsSearchViewController *)segue.destinationViewController setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"Local Event Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [(LocalEventViewController *)segue.destinationViewController setEvent:[self.localEvents objectAtIndex:indexPath.row]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"Local Events Search Segue"]) {
        [(LocalEventsSearchViewController *)segue.destinationViewController setDelegate:self];
    }
}

@end
