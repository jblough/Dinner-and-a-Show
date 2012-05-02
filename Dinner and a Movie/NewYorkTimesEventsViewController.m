//
//  NewYorkTimesEventsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventsViewController.h"
#import "NewYorkTimesEventDetailViewController.h"

#import "NewYorkTimesFetcher.h"
#import "SVProgressHUD.h"

@interface NewYorkTimesEventsViewController ()

@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewYorkTimesEventsViewController

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
    [SVProgressHUD showWithStatus:@"Downloading events"];
    [NewYorkTimesFetcher events:^(NSArray *events) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadEvents];
}

- (void)viewDidUnload
{
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NYT Event List Cell";
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [(NewYorkTimesEventDetailViewController *)segue.destinationViewController setEvent:[self.events objectAtIndex:indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
