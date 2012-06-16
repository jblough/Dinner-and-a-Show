//
//  LocalEventsViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventsViewController.h"
#import "LocalEventViewController.h"
#import "LocalEventListingTableCell.h"

#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"

#import "PatchFetcher.h"
#import "PatchEvent.h"

#import "AppDelegate.h"

#define kPatchURL @"http://patch.com"

@interface LocalEventsViewController ()

@property (nonatomic, strong) NSMutableArray *events;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LocalEventsSearchCriteria *criteria;

@end

@implementation LocalEventsViewController
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
    int page = (int)([self.events count] / kLocalEventPageSize);
    [PatchFetcher events:page onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.events addObjectsFromArray:data];
            
            NSLog(@"comparing %d to %d", [data count], kLocalEventPageSize);
            self.endReached = [data count] < kLocalEventPageSize;
            if (self.view.window)
                [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}


- (void)loadEvents
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
                                   onCancel:^{
                                   }];
    }
    else {
        [SVProgressHUD showWithStatus:@"Downloading events"];
        [PatchFetcher events:^(NSArray *events) {
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
//    [self setTableView:nil];
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
    
    static NSString *CellIdentifier = @"Event List Cell2";
    LocalEventListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    PatchEvent *event = [self.events objectAtIndex:indexPath.row];
    cell.titleLabel.text = event.title;
    cell.summaryLabel.text = event.summary;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Local Event Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [(LocalEventViewController *)segue.destinationViewController setEvent:[self.events objectAtIndex:indexPath.row]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"Local Events Search Segue"]) {
        [(LocalEventsSearchViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (IBAction)visitWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPatchURL]];
}

#pragma mark - LocalEventsSearchDelegate methods
- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)searchLocalEvents:(LocalEventsSearchCriteria *)criteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.criteria = criteria;
    
    // Update the app delegate with user specified values
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!self.criteria.useCurrentLocation) {
        appDelegate.userSpecifiedCoordinate = self.criteria.location;
    }
    
    // Kick off the search
    [self.events removeAllObjects];
    // If the search criteria was removed, reset
    if (!criteria.searchTerm || [@"" isEqualToString:criteria.searchTerm]) {
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
                if (self.view.window)
                    [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
}

- (LocalEventsSearchCriteria *)getLocalEventCriteria
{
    return self.criteria;
}

@end
