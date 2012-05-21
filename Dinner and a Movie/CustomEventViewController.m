//
//  CustomEventViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomEventViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

#define kMapTypeMap 0
#define kMapTypeSatellite 1
#define kMapTypeHybrid 2

#define kDefaultMinutesBefore 30.0

@interface CustomEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSelector;
@property (weak, nonatomic) IBOutlet UIButton *locationSelectionButton;
@property (weak, nonatomic) IBOutlet UISwitch *addReminderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *minutesBeforeLabel;
@property (weak, nonatomic) IBOutlet UISlider *minutesBeforeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *followUpSwitch;

@property (strong, nonatomic) MKPointAnnotation *mapAnnotation;
           

@property (nonatomic, strong) UIBarButtonItem *addToScheduleButton;

@end

@implementation CustomEventViewController
@synthesize eventNameTextField = _eventNameTextField;
@synthesize datePicker = _datePicker;
@synthesize mapView = _mapView;
@synthesize mapTypeSelector = _mapTypeSelector;
@synthesize locationSelectionButton = _locationSelectionButton;
@synthesize addReminderSwitch = _addReminderSwitch;
@synthesize minutesBeforeLabel = _minutesBeforeLabel;
@synthesize minutesBeforeSlider = _minutesBeforeSlider;
@synthesize followUpSwitch = _followUpSwitch;
@synthesize addToScheduleButton = _addToScheduleButton;
@synthesize mapAnnotation = _mapAnnotation;
@synthesize event = _event;


- (UIBarButtonItem *)addToScheduleButton
{
    if (!self.event) {
        if (!_addToScheduleButton) _addToScheduleButton = [[UIBarButtonItem alloc] 
                                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomEventToSchedule)];
    }
    else {
        if (!_addToScheduleButton) _addToScheduleButton = [[UIBarButtonItem alloc] 
                                                           initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addCustomEventToSchedule)];
    }
    return _addToScheduleButton;
}


- (void)resetMap
{
    // Add location on Map
    if (self.mapAnnotation) {
        [self.mapView addAnnotation:self.mapAnnotation];

        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapAnnotation.coordinate, 1600, 1600);
        self.mapView.region = [self.mapView regionThatFits:region];
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.zipCode) {
            CLLocationCoordinate2D annotationCoord = appDelegate.coordinate;
            
            //MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            //annotationPoint.coordinate = annotationCoord;
            //[self.mapView addAnnotation:annotationPoint];
            NSLog(@"Setting coordinates to (%.2f, %2f)", annotationCoord.latitude, annotationCoord.longitude);
            
            self.mapView.centerCoordinate = annotationCoord;
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
            self.mapView.region = [self.mapView regionThatFits:region];
        }
    }
}

- (void)resetFields
{
    if (!self.event) {
        self.eventNameTextField.text = @"";
        [self.datePicker setDate:[NSDate date]];
        [self resetMap];
        self.mapTypeSelector.selectedSegmentIndex = kMapTypeMap;
        
        self.addReminderSwitch.on = YES;
        self.minutesBeforeLabel.enabled = YES;
        self.minutesBeforeSlider.enabled = YES;
        self.minutesBeforeSlider.value = kDefaultMinutesBefore;
        self.followUpSwitch.on = YES;
    }
    else {
        self.eventNameTextField.text = self.event.name;
        [self.datePicker setDate:self.event.when];
        self.addReminderSwitch.on = self.event.reminder;
        if (self.event.reminder) {
            self.minutesBeforeLabel.enabled = YES;
            self.minutesBeforeSlider.enabled = YES;
            self.minutesBeforeSlider.value = self.event.minutesBefore;
        }
        else {
            self.minutesBeforeLabel.enabled = NO;
            self.minutesBeforeSlider.enabled = NO;
            self.minutesBeforeSlider.value = kDefaultMinutesBefore;
        }
        self.followUpSwitch.on = self.event.followUp;
        
        // Map
        self.mapTypeSelector.selectedSegmentIndex = kMapTypeMap;
        if (self.mapAnnotation) {
            [self.mapView removeAnnotation:self.mapAnnotation];
        }
        CLLocationCoordinate2D annotationCoord = CLLocationCoordinate2DMake(self.event.latitude, self.event.longitude);
        
        NSLog(@"Setting coordinates to (%.2f, %2f)", annotationCoord.latitude, annotationCoord.longitude);
        self.mapAnnotation = [[MKPointAnnotation alloc] init];
        if (![@"" isEqualToString:self.event.name]) {
            self.mapAnnotation.title = self.event.name;
        }
        self.mapAnnotation.coordinate = annotationCoord;
        [self resetMap];
    }
}

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
    
    self.parentViewController.navigationItem.rightBarButtonItem = self.addToScheduleButton;

    if (self.event) {
        [self resetFields];
    }
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
    [self.mapView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.event) {
        [self resetMap];
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapTypeSelector:nil];
    [self setDatePicker:nil];
    [self setLocationSelectionButton:nil];
    [self setEventNameTextField:nil];
    [self setMinutesBeforeLabel:nil];
    [self setMinutesBeforeSlider:nil];
    [self setFollowUpSwitch:nil];
    [self setAddReminderSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)nameChangeEnded
{
    [self.eventNameTextField resignFirstResponder];

    if (![@"" isEqualToString:self.eventNameTextField.text]) {
        if (self.mapAnnotation) {
            // To update the annotatino title, it has to be removed and readded
            [self.mapView removeAnnotation:self.mapAnnotation];
            self.mapAnnotation.title = self.eventNameTextField.text;
            [self.mapView addAnnotation:self.mapAnnotation];
        }
    }
}

- (IBAction)mapTypeChanged
{
    switch (self.mapTypeSelector.selectedSegmentIndex) {
        case kMapTypeMap:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case kMapTypeSatellite:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case kMapTypeHybrid:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

- (IBAction)addReminderToggled:(UISlider *)sender
{
    if (self.addReminderSwitch.on) {
        self.minutesBeforeLabel.enabled = YES;
        self.minutesBeforeSlider.enabled = YES;
    }
    else {
        self.minutesBeforeLabel.enabled = NO;
        self.minutesBeforeSlider.enabled = NO;
    }
}

- (IBAction)changedName:(UITextField *)sender
{
//    [self.eventNameTextField resignFirstResponder];
}

- (IBAction)addCustomEventToSchedule
{
    if (![@"" isEqualToString:self.eventNameTextField.text]) {
        CustomEvent *event = [[CustomEvent alloc] init];
        event.name = self.eventNameTextField.text;
        event.when = [self.datePicker date];
        if (self.mapAnnotation) {
            event.latitude = self.mapAnnotation.coordinate.latitude;
            event.longitude = self.mapAnnotation.coordinate.longitude;
        }
        event.reminder = self.addReminderSwitch.on;
        event.minutesBefore = (int)self.minutesBeforeSlider.value;
        event.followUp = self.followUpSwitch.on;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.eventLibrary addCustomEventToSchedule:event];
        
        [self resetFields];
    }
    else {
        // Warn the user that a name is needed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name" message:@"Please provide a name for this event" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}

- (void)longTap:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
        return;
    
    if (self.mapAnnotation) {
        [self.mapView removeAnnotation:self.mapAnnotation];
    }

    NSLog(@"long tap on Map");
    CGPoint tap = [sender locationInView:self.mapView];
    CLLocationCoordinate2D annotationCoord = [self.mapView convertPoint:tap toCoordinateFromView:self.mapView];
    
    NSLog(@"Setting coordinates to (%.2f, %2f)", annotationCoord.latitude, annotationCoord.longitude);
    self.mapAnnotation = [[MKPointAnnotation alloc] init];
    if (![@"" isEqualToString:self.eventNameTextField.text]) {
        self.mapAnnotation.title = self.eventNameTextField.text;
    }
    self.mapAnnotation.coordinate = annotationCoord;
    [self.mapView addAnnotation:self.mapAnnotation];
    
    //self.mapView.centerCoordinate = annotationCoord;
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
    //self.mapView.region = [self.mapView regionThatFits:region];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0 && [self.eventNameTextField isFirstResponder])
        [self.eventNameTextField resignFirstResponder];
        
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex]) {
        self.eventNameTextField.text = [[alertView textFieldAtIndex:0] text];
        [self addCustomEventToSchedule];
    }
}

@end
