//
//  SelectLocationViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectLocationViewController.h"

#import <MapKit/MapKit.h>

#define kMapTypeMap 0
#define kMapTypeSatellite 1
#define kMapTypeHybrid 2

#define kUseCurrentLocation 0
#define kUseCustomLocation 1

@interface SelectLocationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectionTypeSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSelector;

@property (strong, nonatomic) MKPointAnnotation *mapAnnotation;

@end

@implementation SelectLocationViewController
@synthesize mapView = _mapView;
@synthesize selectionTypeSelector = _selectionTypeSelector;
@synthesize mapTypeSelector = _mapTypeSelector;
@synthesize mapAnnotation = _mapAnnotation;
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
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapTypeSelector:nil];
    [self setSelectionTypeSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    //self.mapView.centerCoordinate = annotationCoord;
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 1600, 1600);
    //self.mapView.region = [self.mapView regionThatFits:region];
}
- (IBAction)selectionTypeChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == kUseCurrentLocation) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapAnnotation.coordinate, 1600, 1600);
        self.mapView.region = [self.mapView regionThatFits:region];
        if (self.mapAnnotation)
            [self.mapView removeAnnotation:self.mapAnnotation];
    }
    else {
        
    }
}

- (IBAction)mapTypeChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
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

- (IBAction)done:(id)sender
{
    CLLocationCoordinate2D location = (self.selectionTypeSelector.selectedSegmentIndex == kUseCurrentLocation || !self.mapAnnotation) ? 
        CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude) : 
        CLLocationCoordinate2DMake(self.mapAnnotation.coordinate.latitude, self.mapAnnotation.coordinate.longitude);
    
    [self.delegate selectLocation:location sender:self];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

@end
