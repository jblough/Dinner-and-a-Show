//
//  AddRestaurantToScheduleViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddRestaurantToScheduleViewController.h"
#import "DateInputTableViewCell.h"
#import "EventInformationParser.h"

@interface AddRestaurantToScheduleViewController ()

@property (weak) IBOutlet DateInputTableViewCell *when;

@property (weak, nonatomic) IBOutlet UISwitch *addReminder;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UISwitch *addCheckinReminderSwitch;
@property (weak, nonatomic) IBOutlet UISlider *checkinMinutesSlider;
@property (weak, nonatomic) IBOutlet UILabel *checkinMinutesLabel;

@property (weak, nonatomic) IBOutlet UISwitch *followupSlider;
@property (weak) IBOutlet DateInputTableViewCell *followUpWhen;


- (void)populateTable:(ScheduledRestaurantEvent *)options;

@end

@implementation AddRestaurantToScheduleViewController
@synthesize when = _when;
@synthesize addReminder = _addReminder;
@synthesize reminderSlider = _reminderSlider;
@synthesize reminderLabel = _reminderLabel;
@synthesize addCheckinReminderSwitch = _addCheckinReminderSwitch;
@synthesize checkinMinutesSlider = _checkinMinutesSlider;
@synthesize checkinMinutesLabel = _checkinMinutesLabel;
@synthesize followupSlider = _followupSlider;
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
        NSDate *date = [EventInformationParser nextHour];
        [self.when setDateValue:date];
        [self.followUpWhen setDateValue:[EventInformationParser noonNextDay:date]];

        self.addReminder.on = YES;
        self.reminderSlider.value = kDefaultMinutesBefore;
        self.reminderLabel.text = [NSString stringWithFormat:@"%d", kDefaultMinutesBefore];
        self.addCheckinReminderSwitch.on = YES;
        self.checkinMinutesSlider.value = kDefaultCheckinMinutes;
        self.checkinMinutesLabel.text = [NSString stringWithFormat:@"%d", kDefaultCheckinMinutes];
        self.followupSlider.on = YES;
    }
}

- (void)viewDidUnload
{
    [self setWhen:nil];
    [self setAddReminder:nil];
    [self setReminderSlider:nil];
    [self setReminderLabel:nil];
    [self setAddCheckinReminderSwitch:nil];
    [self setCheckinMinutesSlider:nil];
    [self setCheckinMinutesLabel:nil];
    [self setFollowupSlider:nil];
    [self setFollowUpWhen:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)populateTable:(ScheduledRestaurantEvent *)event
{
    [self.when setDateValue:event.eventDate];
    self.addReminder.on = event.reminder;
    self.reminderSlider.value = event.minutesBefore;
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", event.minutesBefore];
    self.addCheckinReminderSwitch.on = event.checkin;
    self.checkinMinutesSlider.value = event.checkinMinutes;
    self.checkinMinutesLabel.text = [NSString stringWithFormat:@"%d", event.checkinMinutes];
    self.followupSlider.on = event.followUp;
    [self.followUpWhen setDateValue:event.followUpWhen];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (IBAction)addRestaurant:(id)sender
{
    AddRestaurantToScheduleOptions *options = [[AddRestaurantToScheduleOptions alloc] init];
    options.when = [self.when dateValue];
    options.reminder = self.addReminder.on;
    options.minutesBefore = (int)self.reminderSlider.value;
    options.checkin = self.addCheckinReminderSwitch.on;
    options.checkinMinutes = (int)self.checkinMinutesSlider.value;
    options.followUp = self.followupSlider.on;
    options.followUpDate = [self.followUpWhen dateValue];
    
    [self.delegate add:options sender:self];
}

- (IBAction)reminderSliderChanged:(UISlider *)sender
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
