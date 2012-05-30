//
//  AddRecipeToScheduleViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddRecipeToScheduleViewController.h"

@interface AddRecipeToScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *addReminder;
@property (weak, nonatomic) IBOutlet UISlider *reminderSlider;

- (void)populateTable:(ScheduledRecipeEvent *)event;

@end

@implementation AddRecipeToScheduleViewController

@synthesize datePicker = _datePicker;
@synthesize addReminder = _addReminder;
@synthesize reminderSlider = _reminderSlider;
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
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setAddReminder:nil];
    [self setReminderSlider:nil];
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
    [self.datePicker setDate:event.eventDate];
    self.addReminder.on = event.reminder;
    self.reminderSlider.value = event.minutesBefore;
}

- (IBAction)addRecipe:(id)sender
{
    AddRecipeToScheduleOptions *options = [[AddRecipeToScheduleOptions alloc] init];
    options.when = [self.datePicker date];
    options.reminder = self.addReminder.on;
    options.minutesBefore = self.reminderSlider.value;
    
    [self.delegate add:options sender:self];
}

@end
