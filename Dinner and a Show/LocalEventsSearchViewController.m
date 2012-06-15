//
//  LocalEventsSearchViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventsSearchViewController.h"
#import "AppDelegate.h"
#import "YRDropdownView.h"

#import <MapKit/MapKit.h>

#define kUseCurrentLocation 0
#define kUseSelectedLocation 1

#define kMapTypeMap 0
#define kMapTypeSatellite 1
#define kMapTypeHybrid 2

@interface LocalEventsSearchViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchTerm;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectionTypeSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSelector;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) MKPointAnnotation *mapAnnotation;

@end

@implementation LocalEventsSearchViewController
@synthesize mapView = _mapView;
@synthesize searchTerm = _searchTerm;
@synthesize selectionTypeSelector = _selectionTypeSelector;
@synthesize mapTypeSelector = _mapTypeSelector;
@synthesize footerView = _footerView;
@synthesize delegate = _delegate;
@synthesize mapAnnotation = _mapAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addMarkerForLocation:(CLLocation *)location
{
    self.mapAnnotation = [[MKPointAnnotation alloc] init];
    self.mapAnnotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:self.mapAnnotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
    [self.mapView addGestureRecognizer:recognizer];
    
    CLLocation *coordinate = [self.delegate getLocalEventCriteria].location;
    if (!coordinate) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.userSpecifiedCoordinate) {
            coordinate = appDelegate.userSpecifiedCoordinate;
            [self addMarkerForLocation:coordinate];
            self.selectionTypeSelector.selectedSegmentIndex = kUseSelectedLocation;
        }
        else
            coordinate = appDelegate.coordinate;
    }
    else {
        [self addMarkerForLocation:coordinate];
        self.selectionTypeSelector.selectedSegmentIndex = kUseSelectedLocation;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate.coordinate, 1600, 1600);
    self.mapView.region = [self.mapView regionThatFits:region];
    
    self.searchTerm.text = [self.delegate getLocalEventCriteria].searchTerm;

    [YRDropdownView showDropdownInView:self.footerView
                                 title:nil 
                                detail:@"Hold down on the map for a few seconds to select a location for the center of the search" 
                                 image:[UIImage imageNamed:@"07-map-marker.png"]
                              animated:YES
                             hideAfter:5];
}

- (void)viewDidUnload
{
    [self setSearchTerm:nil];
    [self setSelectionTypeSelector:nil];
    [self setMapTypeSelector:nil];
    [self setMapView:nil];
    [self setFooterView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)longTap:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
        return;
    
    // Remove the old annotation
    if (self.mapAnnotation) {
        [self.mapView removeAnnotation:self.mapAnnotation];
    }
    
    // Add the new annotation
    NSLog(@"long tap on Map");
    CGPoint tap = [sender locationInView:self.mapView];
    CLLocationCoordinate2D annotationCoord = [self.mapView convertPoint:tap toCoordinateFromView:self.mapView];
    
    NSLog(@"Setting coordinates to (%.2f, %2f)", annotationCoord.latitude, annotationCoord.longitude);
    self.mapAnnotation = [[MKPointAnnotation alloc] init];
    self.mapAnnotation.coordinate = annotationCoord;
    [self.mapView addAnnotation:self.mapAnnotation];
    
    self.selectionTypeSelector.selectedSegmentIndex = kUseSelectedLocation;
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched
{
    if ([self.searchTerm isFirstResponder])
        [self.searchTerm resignFirstResponder];
}

- (IBAction)locationSelectionChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == kUseCurrentLocation) {
        MKCoordinateRegion region = self.mapView.region;
        region.center = self.mapView.userLocation.coordinate;

        [self.mapView setRegion:region animated:YES];
    }
    else {
        if (self.mapAnnotation) {
            MKCoordinateRegion region = self.mapView.region;
            region.center = self.mapAnnotation.coordinate;
            
            [self.mapView setRegion:region animated:YES];
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

- (IBAction)cancel
{
    [self.delegate cancel];
}

- (IBAction)done:(id)sender
{
    LocalEventsSearchCriteria *criteria = [[LocalEventsSearchCriteria alloc] init];
    criteria.useCurrentLocation = self.selectionTypeSelector.selectedSegmentIndex == kUseCurrentLocation;
    criteria.location = [[CLLocation alloc] 
                         initWithLatitude:self.mapAnnotation.coordinate.latitude longitude:self.mapAnnotation.coordinate.longitude];
    criteria.searchTerm = self.searchTerm.text;
    
    [self.delegate searchLocalEvents:criteria sender:self];
}

@end
