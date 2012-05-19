//
//  AddLocalEventToScheduleViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddLocalEventToScheduleViewController.h"

#import "EventInformationParser.h"

@interface AddLocalEventToScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *addReminder;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UISwitch *followup;
@end

@implementation AddLocalEventToScheduleViewController
@synthesize datePicker = _datePicker;
@synthesize addReminder = _addReminder;
@synthesize reminderSlider = _reminderSlider;
@synthesize followup = _followup;
@synthesize delegate = _delegate;

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
    
    NSDate *date = [EventInformationParser findDate:[self.delegate getEvent].summary];
    if (!date) date = [[NSDate alloc] init];
    [self.datePicker setDate:date];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setAddReminder:nil];
    [self setReminderSlider:nil];
    [self setFollowup:nil];
    [self setDatePicker:nil];
    [self setAddReminder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (IBAction)addLocalEvent:(id)sender
{
    AddLocalEventToScheduleOptions *options = [[AddLocalEventToScheduleOptions alloc] init];
    options.when = [self.datePicker date];
    options.reminder = self.addReminder.on;
    options.minutesBefore = self.reminderSlider.value;
    options.followUp = self.followup.on;
    
    [self.delegate add:options sender:self];
}

@end
