//
//  RestaurantSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantSearchViewController.h"
#import "AppDelegate.h"

#define MIN_RADIUS 1
#define MAX_RADIUS 25
#define DEFAULT_RADIUS 5

@interface RestaurantSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchZipCode;
@property (weak, nonatomic) IBOutlet UITextField *searchTerm;
@property (weak, nonatomic) IBOutlet UISwitch *onlyIncludeDealsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *searchRadiusLabel;
@property (weak, nonatomic) IBOutlet UISlider *searchRadiusSlider;

- (int)getRadiusValue;
- (void)updateRadiusLabel:(int)radius;

@end

@implementation RestaurantSearchViewController

@synthesize searchZipCode = _searchZipCode;
@synthesize searchTerm = _searchTerm;
@synthesize onlyIncludeDealsSwitch = _onlyIncludeDealsSwitch;
@synthesize searchRadiusLabel = _searchRadiusLabel;
@synthesize searchRadiusSlider = _searchRadiusSlider;
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
    
    if (!([self.delegate getCriteria].zipCode) || [@"" isEqualToString:[self.delegate getCriteria].zipCode]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.userSpecifiedCode)
            self.searchZipCode.text = appDelegate.userSpecifiedCode;
        else
            self.searchZipCode.text = appDelegate.zipCode;
    }
    else {
        self.searchZipCode.text = [self.delegate getCriteria].zipCode;
    }
    self.searchTerm.text = [self.delegate getCriteria].searchTerm;
    self.onlyIncludeDealsSwitch.on = [self.delegate getCriteria].onlyIncludeDeals;
    
    int radius = ([self.delegate getCriteria]) ? [self.delegate getCriteria].radius : DEFAULT_RADIUS;
    [self updateRadiusLabel:radius];
}

- (void)viewDidUnload
{
    [self setSearchZipCode:nil];
    [self setSearchTerm:nil];
    [self setOnlyIncludeDealsSwitch:nil];
    [self setSearchRadiusLabel:nil];
    [self setSearchRadiusSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched
{
    if ([self.searchZipCode isFirstResponder])
        [self.searchZipCode resignFirstResponder];
    
    if ([self.searchTerm isFirstResponder])
        [self.searchTerm resignFirstResponder];
}

- (IBAction)done:(id)sender
{
    RestaurantSearchCriteria *criteria = [[RestaurantSearchCriteria alloc] init];
    criteria.zipCode = self.searchZipCode.text;
    criteria.searchTerm = self.searchTerm.text;
    criteria.onlyIncludeDeals = self.onlyIncludeDealsSwitch.on;
    criteria.radius = [self getRadiusValue];
    
    [self.delegate search:criteria sender:self];
}

- (IBAction)radiusChanged:(UISlider *)sender
{
    [self updateRadiusLabel:[self getRadiusValue]];
}

- (int)getRadiusValue
{
    int radius = (int)self.searchRadiusSlider.value;
    // These could both be done on one line, but this is more readable
    radius = MIN(MAX_RADIUS, radius);
    radius = MAX(MIN_RADIUS, radius);
    
    return radius;
}

- (void)updateRadiusLabel:(int)radius
{
    self.searchRadiusLabel.text = [NSString stringWithFormat:@"Search Radius - %d %@", radius, (radius > 1) ? @"miles" : @"mile"];
}

@end
