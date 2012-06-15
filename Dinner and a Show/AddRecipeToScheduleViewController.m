//
//  AddRecipeToScheduleViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddRecipeToScheduleViewController.h"
#import "DateInputTableViewCell.h"
#import "EventInformationParser.h"

@interface AddRecipeToScheduleViewController ()

@property (weak) IBOutlet DateInputTableViewCell *when;

@property (weak, nonatomic) IBOutlet UISwitch *addReminder;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

- (void)populateTable:(ScheduledRecipeEvent *)event;

@end

@implementation AddRecipeToScheduleViewController

@synthesize addReminder = _addReminder;
@synthesize reminderSlider = _reminderSlider;
@synthesize reminderLabel = _reminderLabel;
@synthesize when = _when;
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
    
    if (self.originalEvent)
        [self populateTable:self.originalEvent];
    else
        [self.when setDateValue:[EventInformationParser nextHour]];
}

- (void)viewDidUnload
{
    [self setWhen:nil];
    [self setAddReminder:nil];
    [self setReminderSlider:nil];
    [self setReminderLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (void)populateTable:(ScheduledRecipeEvent *)event
{
    [self.when setDateValue:event.eventDate];
    self.addReminder.on = event.reminder;
    self.reminderSlider.value = event.minutesBefore;
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", event.minutesBefore];
}

- (IBAction)addRecipe:(id)sender
{
    AddRecipeToScheduleOptions *options = [[AddRecipeToScheduleOptions alloc] init];
    options.when = [self.when dateValue];
    options.reminder = self.addReminder.on;
    options.minutesBefore = self.reminderSlider.value;
    
    [self.delegate add:options sender:self];
}

- (IBAction)reminderMinutesChanged:(UISlider *)sender
{
    self.reminderLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

@end
