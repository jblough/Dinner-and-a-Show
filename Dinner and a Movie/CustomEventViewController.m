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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Add location on Map
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.zipCode) {
        CLLocationCoordinate2D annotationCoord = appDelegate.coordinate;
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        [self.mapView addAnnotation:annotationPoint];
        
        self.mapView.centerCoordinate = annotationCoord;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
        self.mapView.region = [self.mapView regionThatFits:region];
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
}

- (IBAction)changedName:(UITextField *)sender
{
    [self.eventNameTextField resignFirstResponder];
}

- (IBAction)addCustomEventToSchedule
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0 && [self.eventNameTextField isFirstResponder])
        [self.eventNameTextField resignFirstResponder];
        
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
