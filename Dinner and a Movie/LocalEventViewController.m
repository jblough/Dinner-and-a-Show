//
//  LocalEventViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventViewController.h"
#import "LocalEventDetailViewController.h"

@interface LocalEventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@end

@implementation LocalEventViewController
@synthesize titleLabel = _titleLabel;
@synthesize summaryLabel = _summaryLabel;
@synthesize event = _event;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.titleLabel.text = self.event.title;
    self.summaryLabel.text = self.event.summary;

    self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.numberOfLines = 0;

    CGSize s = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, 750)];
    
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, 
                                       self.titleLabel.frame.origin.y, 
                                       self.titleLabel.frame.size.width, s.height);
    
    self.summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.summaryLabel.numberOfLines = 0;
    
    s = [self.summaryLabel.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.summaryLabel.frame.size.width, 750)];
    self.summaryLabel.frame = CGRectMake(self.summaryLabel.frame.origin.x, 
                                         self.summaryLabel.frame.origin.y, 
                                         self.summaryLabel.frame.size.width, s.height);
}

- (void)viewDidUnload
{
    [self setEvent:nil];
    [self setTitleLabel:nil];
    [self setSummaryLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
    }
    else if (indexPath.section == 1) {
        /*
        CGSize s = [self.summaryLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.summaryLabel.frame.size.width, 500)];

        return s.height;
         */

        return self.summaryLabel.frame.size.height + self.titleLabel.frame.origin.y;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Visit Patch Segue"]) {
        [(LocalEventDetailViewController *)segue.destinationViewController setEvent:self.event];
    }
}

@end
