//
//  NewYorkTimesEventViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventViewController.h"
#import "NewYorkTimesEventDetailViewController.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import <MapKit/MapKit.h>

#define kMinimumRowHeight 40

@interface NewYorkTimesEventViewController ()

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *miscLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *recurringDaysLabel;

@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLineTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)initLabels;

@end

@implementation NewYorkTimesEventViewController
@synthesize summaryLabel = _summaryLabel;
@synthesize miscLabel = _miscLabel;
@synthesize startDateLabel = _startDateLabel;
@synthesize recurringDaysLabel = _recurringDaysLabel;
@synthesize venueLabel = _venueLabel;
@synthesize addressLineOneLabel = _addressLineOneLabel;
@synthesize addressLineTwoLabel = _addressLineTwoLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize mapView = _mapView;
@synthesize event = _event;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initLabels];
}

- (void)viewDidUnload
{
    [self setEvent:nil];

    [self setSummaryLabel:nil];
    [self setMiscLabel:nil];
    [self setStartDateLabel:nil];
    [self setRecurringDaysLabel:nil];
    [self setVenueLabel:nil];
    [self setAddressLineOneLabel:nil];
    [self setAddressLineTwoLabel:nil];
    [self setPhoneLabel:nil];
    [self setMapView:nil];
    [self setOriginalEvent:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
 */

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return MAX(self.summaryLabel.frame.size.height + self.summaryLabel.frame.origin.y, kMinimumRowHeight);
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                return MAX(self.miscLabel.frame.size.height + self.miscLabel.frame.origin.y, kMinimumRowHeight);
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                return MAX(self.venueLabel.frame.size.height + self.venueLabel.frame.origin.y, kMinimumRowHeight);
                break;
            default:
                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
                break;
        }
    }
    else if (indexPath.section == 3) {
        return MAX(self.mapView.frame.size.height + self.mapView.frame.origin.y, kMinimumRowHeight);
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.event.name;
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)initLabel:(UILabel *)label withText:(NSString *)text
{
    label.text = text;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    
    CGSize s = [label.text sizeWithFont:[UIFont systemFontOfSize:17] 
                               constrainedToSize:CGSizeMake(label.frame.size.width, 750)];
    
    label.frame = CGRectMake(label.frame.origin.x, 
                                      label.frame.origin.y, 
                                      label.frame.size.width, MAX(s.height, kMinimumRowHeight));
}

- (NSString *)generateMiscString
{
    NSString *tags = (self.event.subcategory) ? [NSString stringWithFormat:@"Category: %@ - %@", self.event.category, self.event.subcategory] : 
        [NSString stringWithFormat:@"Category: %@", self.event.category];
    
    /*
     @synthesize isTimesPick = _isTimesPick;
     @synthesize isFree = _isFree;
     @synthesize isKidFriendly = _isKidFriendly;
     @synthesize isLastChance = _isLastChance;
     @synthesize isFestival = _isFestival;
     @synthesize isLongRunningShow = _isLongRunningShow;
     @synthesize isPreviewAndOpenings = _isPreviewAndOpenings;
     */
    
    if (self.event.isTimesPick)
        tags = [tags stringByAppendingString:@", Times pick"];
    if (self.event.isFree)
        tags = [tags stringByAppendingString:@", Free"];
    if (self.event.isKidFriendly)
        tags = [tags stringByAppendingString:@", Kid friendly"];
    if (self.event.isLastChance)
        tags = [tags stringByAppendingString:@", Last chance"];
    if (self.event.isFestival)
        tags = [tags stringByAppendingString:@", Festival"];
    if (self.event.isLongRunningShow)
        tags = [tags stringByAppendingString:@", Long running show"];
    if (self.event.isPreviewAndOpenings)
        tags = [tags stringByAppendingString:@", Preview and openings"];
    
    return tags;
}

- (NSString *)generateRecurringDaysString
{
    NSDictionary *daysDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Sunday", @"sun", 
                                    @"Monday", @"mon", 
                                    @"Tuesday", @"tue", 
                                    @"Wednesday", @"wed", 
                                    @"Thursday", @"thu", 
                                    @"Friday", @"fri", 
                                    @"Saturday", @"sat", nil];
    __block NSString *days = @"";
    [self.event.days enumerateObjectsUsingBlock:^(NSString *day, NSUInteger idx, BOOL *stop) {
        if (idx == 0)
            days = [days stringByAppendingFormat:@"%@", [daysDictionary objectForKey:day]];
        else
            days = [days stringByAppendingFormat:@",%@", [daysDictionary objectForKey:day]];
    }];
    return [days copy];
}

- (void)initLabels
{
    [self initLabel:self.summaryLabel withText:self.event.description];
    [self initLabel:self.miscLabel withText:[self generateMiscString]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateReader setLocale:enUSPOSIXLocale];
    [dateReader setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [dateReader setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    //NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    //[dateReader setDateFormat:@"yyyy-MM-ddTHH:mm:"]; // "2011-04-11T04:00:00.1Z"
    NSDate *date = [dateReader dateFromString:self.event.startDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

    self.startDateLabel.text = [dateFormatter stringFromDate:date]; // Date manipulation needed here
    self.recurringDaysLabel.text = [self generateRecurringDaysString];
    
    [self initLabel:self.venueLabel withText:self.event.venue];
    self.addressLineOneLabel.text = self.event.address;
    self.addressLineTwoLabel.text = [NSString stringWithFormat:@"%@, %@ %@", self.event.city,
                                self.event.state, self.event.zipCode];
    self.phoneLabel.text = self.event.phone;
    
    
    // Add location on Map
    CLLocationCoordinate2D annotationCoord;
    
    NSLog(@"Adding map marker for %.2f, %.2f", self.event.latitude, self.event.longitude);
    annotationCoord.latitude = self.event.latitude;
    annotationCoord.longitude = self.event.longitude;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = self.event.name;
    annotationPoint.subtitle = self.event.address;
    [self.mapView addAnnotation:annotationPoint];
    
    self.mapView.centerCoordinate = annotationCoord;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
    self.mapView.region = [self.mapView regionThatFits:region];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Visit NYT Website Segue"]) {
        [(NewYorkTimesEventDetailViewController *)segue.destinationViewController setEvent:self.event];
    }
    else if ([segue.identifier isEqualToString:@"Add NYT Event Segue"]) {
        UINavigationController *navController = segue.destinationViewController;
        [(AddNewYorkTimesEventToScheduleViewController *)navController.topViewController setDelegate:self];
        if (self.originalEvent)
            [(AddNewYorkTimesEventToScheduleViewController *)navController.topViewController setOriginalEvent:self.originalEvent];
    }
}

#pragma mark -
#pragma mark AddNewYorkTimesEventDelegate
- (void)add:(AddNewYorkTimesEventToScheduleOptions *)options sender:(id)sender
{
    // Remove the original event
    [self.originalEvent deleteEvent];
    
    // Add the updated event
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.event = self.event;
    [library addNewYorkTimesEventToSchedule:options];
    
    // Add to calendar
    if (options.reminder || options.checkin || options.followUp) {
        CalendarEvent *event = [[CalendarEvent alloc] init];
        event.eventId = [NSString stringWithFormat:@"%@ - %@", self.event.identifier, options.when];
        event.type = @"nytimes";
        event.identifier = options.event.identifier;
        event.title = options.event.name;
        event.url = options.event.eventUrl;
        event.notes = options.event.phone;
        event.startDate = options.when;
        event.reminder = options.reminder;
        event.minutesBefore = options.minutesBefore;
        event.checkin = options.checkin;
        event.checkinMinutes = options.checkinMinutes;
        event.followUp = options.followUp;
        event.followUpWhen = options.followUpDate;
        // This URL should point to a social networking site like Facebook or GetGlue for review
        event.followUpUrl = options.event.eventUrl;
        [appDelegate addNotification:event];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

- (NewYorkTimesEvent *)getEvent
{
    return self.event;
}

@end
