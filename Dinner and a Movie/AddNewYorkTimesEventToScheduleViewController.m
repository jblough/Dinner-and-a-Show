//
//  AddNewYorkTimesEventToScheduleViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewYorkTimesEventToScheduleViewController.h"
#import "EventInformationParser.h"

@interface AddNewYorkTimesEventToScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *addReminder;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UISwitch *followup;

- (void)populateTable:(ScheduledNewYorkTimesEvent *)event;

@end

@implementation AddNewYorkTimesEventToScheduleViewController
@synthesize datePicker = _datePicker;
@synthesize addReminder = _addReminder;
@synthesize reminderSlider = _reminderSlider;
@synthesize followup = _followup;
@synthesize delegate = _delegate;
@synthesize originalEvent = _originalEvent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.originalEvent) {
        [self populateTable:self.originalEvent];
    }
    else {
        NSDate *date = [EventInformationParser convertDate:[self.delegate getEvent].startDate];
        if (!date) date = [[NSDate alloc] init];
        [self.datePicker setDate:date];
    }
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setAddReminder:nil];
    [self setReminderSlider:nil];
    [self setFollowup:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)populateTable:(ScheduledNewYorkTimesEvent *)event
{
    [self.datePicker setDate:event.eventDate];
    self.addReminder.on = event.reminder;
    self.reminderSlider.value = event.minutesBefore;
    self.followup.on = event.followUp;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (IBAction)addNewYorkTimesEvent:(id)sender
{
    AddNewYorkTimesEventToScheduleOptions *options = [[AddNewYorkTimesEventToScheduleOptions alloc] init];
    options.when = [self.datePicker date];
    options.reminder = self.addReminder.on;
    options.minutesBefore = self.reminderSlider.value;
    options.followUp = self.followup.on;
    
    [self.delegate add:options sender:self];
}

@end
