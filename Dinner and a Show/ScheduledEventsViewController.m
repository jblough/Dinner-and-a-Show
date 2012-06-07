//
//  ScheduledEventsViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledEventsViewController.h"
#import "AppDelegate.h"
#import "ScheduledEventitem.h"

@interface ScheduledEventsViewController ()

@property (nonatomic, strong) NSMutableArray *headings;
@property (nonatomic, strong) NSMutableDictionary *sectionedEvents;
@property (nonatomic, strong) NSDateFormatter *dateCellFormatter;

@end

@implementation ScheduledEventsViewController

@synthesize headings = _headings;
@synthesize sectionedEvents = _sectionedEvents;
@synthesize dateCellFormatter = _dateCellFormatter;

- (NSMutableArray *)headings
{
    if (!_headings) _headings = [NSMutableArray array];
    return _headings;
}

- (NSMutableDictionary *)sectionedEvents
{
    if (!_sectionedEvents) _sectionedEvents = [NSMutableDictionary dictionary];
    return _sectionedEvents;
}

- (void)breakEventsIntoSections:(NSArray *)allEvents
{
    [self.headings removeAllObjects];
    [self.sectionedEvents removeAllObjects];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [allEvents enumerateObjectsUsingBlock:^(id<ScheduledEventitem> item, NSUInteger idx, BOOL *stop) {
        // Format the date for comparison and to use as a section heading
        NSString *formattedDate = [dateFormatter stringFromDate:[item eventDate]];
        
        // Get any existing events on that date
        NSMutableArray *events = [self.sectionedEvents objectForKey:formattedDate];
        if (!events) {
            [self.headings addObject:formattedDate];
            events = [NSMutableArray array];
            //NSLog(@"Adding section for '%@'", formattedDate);
        }
        
        // Add this event to the list of events on that date
        [events addObject:item];
        
        // Update the dictionary for that date
        [self.sectionedEvents setValue:events forKey:formattedDate];
    }];
}

- (void)loadData
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *events = [appDelete.eventLibrary scheduledItems];
    [self breakEventsIntoSections:events];
}

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
    self.dateCellFormatter = [[NSDateFormatter alloc] init];
    [self.dateCellFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.dateCellFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelete.eventLibrary hasScheduledItems]) {
        [self performSegueWithIdentifier:@"Add Event Segue" sender:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.dateCellFormatter = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadData];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headings count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.headings objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionedEvents objectForKey:[self.headings objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Scheduled Event Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    NSArray *events = [self.sectionedEvents objectForKey:[self.headings objectAtIndex:indexPath.section]];
    id<ScheduledEventitem> item = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.dateCellFormatter stringFromDate:[item eventDate]];
    cell.detailTextLabel.text = [item eventDescription];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Get the initial number of sections before the delete
        int sectionCount = [self.headings count];
        
        // Delete the row from the data source
        NSArray *events = [self.sectionedEvents objectForKey:[self.headings objectAtIndex:indexPath.section]];
        id<ScheduledEventitem> item = [events objectAtIndex:indexPath.row];
        [item deleteEvent];
        
        // Reload the data as needed by the table view update
        [self loadData];
        
        if (sectionCount == [self.headings count])
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        else {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    // Should we have methods on ScheduledEventitem for get segue identifier that returns a NSString and prep for segue that
    //  takes the destination controller (from prepare for segue) and sets 
    NSArray *events = [self.sectionedEvents objectForKey:[self.headings objectAtIndex:indexPath.section]];
    id<ScheduledEventitem> item = [events objectAtIndex:indexPath.row];
    NSString *segue = [item getSegue];
    //[self performSegueWithIdentifier:segue sender:[tableView cellForRowAtIndexPath:indexPath]];
    [self performSegueWithIdentifier:segue sender:item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.identifier isEqualToString:@"Add Event Segue"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //NSArray *events = [self.sectionedEvents objectForKey:[self.headings objectAtIndex:indexPath.section]];
        //id<ScheduledEventitem> item = [events objectAtIndex:indexPath.row];
        id<ScheduledEventitem> item = sender;
        [item prepSegueDestination:segue.destinationViewController];
    }
}

- (void)handleFollowUp:(NSString *)type identifier:(NSString *)identifier when:(NSDate *)when
{
    id<ScheduledEventitem> event = nil;
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if ([@"custom followup" isEqualToString:type]) {
        event = [appDelete.eventLibrary loadCustomEvent:identifier on:when];
    }
    else if ([@"recipe followup" isEqualToString:type]) {
        event = [appDelete.eventLibrary loadRecipeEvent:identifier when:when];
    }
    else if ([@"restaurant followup" isEqualToString:type]) {
        event = [appDelete.eventLibrary loadRestaurantEvent:identifier when:when];
    }
    else if ([@"local followup" isEqualToString:type]) {
        event = [appDelete.eventLibrary loadLocalEvent:identifier when:when];
    }
    else if ([@"nytimes followup" isEqualToString:type]) {
        event = [appDelete.eventLibrary loadNewYorkTimesEvent:identifier when:when];
    }
    
    // We have to figure out the best way to do a followup
    // Yelp, G+, Facebook, Foursquare, Twitter, GetGlue, Rotten Tomatoes???
    // Shelf-type menu with logo and name of each option?
}

- (void)handleLocalNotification:(UILocalNotification *)notification
{
    id<ScheduledEventitem> event = nil;
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSString *type = [notification.userInfo objectForKey:@"type"];
    NSString *identifier = [notification.userInfo objectForKey:@"identifier"];
    NSString *when = [notification.userInfo objectForKey:@"when"];

    // Format the date for consistent retrieval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSDate *date = [dateFormatter dateFromString:when];
    
    if ([type hasSuffix:@" followup"]) {
        [self handleFollowUp:type identifier:identifier when:date];
    }
    else {
        if ([@"custom" isEqualToString:type]) {
            event = [appDelete.eventLibrary loadCustomEvent:identifier on:date];
        }
        else if ([@"recipe" isEqualToString:type]) {
            event = [appDelete.eventLibrary loadRecipeEvent:identifier when:date];
        }
        else if ([@"restaurant" isEqualToString:type]) {
            event = [appDelete.eventLibrary loadRestaurantEvent:identifier when:date];
        }
        else if ([@"local" isEqualToString:type]) {
            event = [appDelete.eventLibrary loadLocalEvent:identifier when:date];
        }
        else if ([@"nytimes" isEqualToString:type]) {
            event = [appDelete.eventLibrary loadNewYorkTimesEvent:identifier when:date];
        }
        
        if (event) {
            NSString *segue = [event getSegue];
            [self performSegueWithIdentifier:segue sender:event];
        }
    }
}

@end
