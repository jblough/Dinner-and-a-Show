//
//  AddNewYorkTimesEventToScheduleViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewYorkTimesEventToScheduleViewController.h"
#import "DateInputTableViewCell.h"
#import "EventInformationParser.h"

@interface AddNewYorkTimesEventToScheduleViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *addReminderSwitch;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *followUpSwitch;

@property (weak) IBOutlet DateInputTableViewCell *when;
@property (weak) IBOutlet DateInputTableViewCell *followUpWhen;

- (void)populateTable:(ScheduledNewYorkTimesEvent *)event;

@end

@implementation AddNewYorkTimesEventToScheduleViewController
@synthesize addReminderSwitch = _addReminderSwitch;
@synthesize reminderSlider = _reminderSlider;
@synthesize reminderLabel = _reminderLabel;
@synthesize followUpSwitch = _followUpSwitch;
@synthesize when = _when;
@synthesize followUpWhen = _followUpWhen;
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
        NSDate *nextHour = [EventInformationParser nextHour];
        NSDate *eventDate = [nextHour laterDate:date];
        [self.when setDateValue:eventDate];
        [self.followUpWhen setDateValue:[EventInformationParser noonNextDay:eventDate]];
    }
}

- (void)viewDidUnload
{
    [self setWhen:nil];
    [self setAddReminderSwitch:nil];
    [self setReminderSlider:nil];
    [self setReminderLabel:nil];
    [self setFollowUpSwitch:nil];
    [self setFollowUpWhen:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)populateTable:(ScheduledNewYorkTimesEvent *)event
{
    [self.when setDateValue:event.eventDate];
    self.addReminderSwitch.on = event.reminder;
    self.reminderSlider.value = event.minutesBefore;
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", event.minutesBefore];
    self.followUpSwitch.on = event.followUp;
    [self.followUpWhen setDateValue:event.followUpWhen];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (IBAction)addNewYorkTimesEvent:(id)sender
{
    AddNewYorkTimesEventToScheduleOptions *options = [[AddNewYorkTimesEventToScheduleOptions alloc] init];
    options.when = [self.when dateValue];
    options.reminder = self.addReminderSwitch.on;
    options.minutesBefore = self.reminderSlider.value;
    options.followUp = self.followUpSwitch.on;
    options.followUpDate = [self.followUpWhen dateValue];
    
    [self.delegate add:options sender:self];
}

- (IBAction)minutesBeforeValueChanged:(UISlider *)sender
{
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

@end
