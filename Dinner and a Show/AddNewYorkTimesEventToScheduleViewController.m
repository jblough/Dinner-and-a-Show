//
//  AddNewYorkTimesEventToScheduleViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewYorkTimesEventToScheduleViewController.h"
#import "DateInputTableViewCell.h"
#import "EventInformationParser.h"

@interface AddNewYorkTimesEventToScheduleViewController ()

@property (weak) IBOutlet DateInputTableViewCell *when;

@property (weak, nonatomic) IBOutlet UISwitch *addReminderSwitch;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UISwitch *addCheckinReminderSwitch;
@property (weak, nonatomic) IBOutlet UISlider *checkinMinutesSlider;
@property (weak, nonatomic) IBOutlet UILabel *checkinMinutesLabel;

@property (weak, nonatomic) IBOutlet UISwitch *followUpSwitch;
@property (weak) IBOutlet DateInputTableViewCell *followUpWhen;

- (void)populateTable:(ScheduledNewYorkTimesEvent *)event;

@end

@implementation AddNewYorkTimesEventToScheduleViewController
@synthesize addReminderSwitch = _addReminderSwitch;
@synthesize reminderSlider = _reminderSlider;
@synthesize reminderLabel = _reminderLabel;
@synthesize addCheckinReminderSwitch = _addCheckinReminderSwitch;
@synthesize checkinMinutesSlider = _checkinMinutesSlider;
@synthesize checkinMinutesLabel = _checkinMinutesLabel;
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
        
        self.addReminderSwitch.on = YES;
        self.reminderSlider.value = kDefaultMinutesBefore;
        self.reminderLabel.text = [NSString stringWithFormat:@"%d", kDefaultMinutesBefore];
        self.addCheckinReminderSwitch.on = YES;
        self.checkinMinutesSlider.value = kDefaultCheckinMinutes;
        self.checkinMinutesLabel.text = [NSString stringWithFormat:@"%d", kDefaultCheckinMinutes];
        self.followUpSwitch.on = YES;
    }
}

- (void)viewDidUnload
{
    [self setWhen:nil];
    [self setAddReminderSwitch:nil];
    [self setReminderSlider:nil];
    [self setReminderLabel:nil];
    [self setAddCheckinReminderSwitch:nil];
    [self setCheckinMinutesSlider:nil];
    [self setCheckinMinutesLabel:nil];
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
    self.addCheckinReminderSwitch.on = event.checkin;
    self.checkinMinutesSlider.value = event.checkinMinutes;
    self.checkinMinutesLabel.text = [NSString stringWithFormat:@"%d", event.checkinMinutes];
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
    options.minutesBefore = (int)self.reminderSlider.value;
    options.checkin = self.addCheckinReminderSwitch.on;
    options.checkinMinutes = (int)self.checkinMinutesSlider.value;
    options.followUp = self.followUpSwitch.on;
    options.followUpDate = [self.followUpWhen dateValue];
    
    [self.delegate add:options sender:self];
}

- (IBAction)minutesBeforeValueChanged:(UISlider *)sender
{
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (IBAction)checkinValueChanged:(UISlider *)sender
{
    self.checkinMinutesLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value
{
	//NSLog(@"%@ date changed to: %@", cell.textLabel.text, value);
    [self.followUpWhen setDateValue:[EventInformationParser noonNextDay:[self.when dateValue]]];
}

@end
