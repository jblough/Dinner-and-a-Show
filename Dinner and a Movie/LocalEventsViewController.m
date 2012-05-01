//
//  LocalEventsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventsViewController.h"
#import "LocalEventDetailViewController.h"
#import "LocalEventListingTableCell.h"

#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"

#import "PatchFetcher.h"
#import "PatchStory.h"

#import "AppDelegate.h"

@interface LocalEventsViewController ()

@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LocalEventsViewController
@synthesize events = _events;
@synthesize tableView = _tableView;

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
    [self loadEvents];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Event List Cell";
    LocalEventListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    PatchStory *event = [self.events objectAtIndex:indexPath.row];
    cell.titleLabel.text = event.title;
    cell.summaryLabel.text = event.summary;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [(LocalEventDetailViewController *)segue.destinationViewController setEvent:[self.events objectAtIndex:indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
