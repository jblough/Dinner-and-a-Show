//
//  NewYorkTimesEventsSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventsSearchViewController.h"
#import "NewYorkTimesEventFilterCategoryCell.h"

#define kMoviesFilterTag @"Movies"
#define kTheaterFilterTag @"Theater"
#define kSpareTimesFilterTag @"spareTimes"
#define kArtFilterTag @"Art"
#define kForChildrenFilterTag @"forChildren"
#define kClassicalFilterTag @"Classical"
#define kJazzFilterTag @"Jazz"
#define kPopFilterTag @"Pop"
#define kDanceFilterTag @"Dance"

@interface NewYorkTimesEventsSearchViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *moviesFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *theaterFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *spareTimesFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *artFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *forChildrenFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *classicalFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jazzFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *popFilterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *danceFilterSwitch;

@end

@implementation NewYorkTimesEventsSearchViewController
@synthesize delegate = _delegate;
@synthesize moviesFilterSwitch = _moviesFilterSwitch;
@synthesize theaterFilterSwitch = _theaterFilterSwitch;
@synthesize spareTimesFilterSwitch = _spareTimesFilterSwitch;
@synthesize artFilterSwitch = _artFilterSwitch;
@synthesize forChildrenFilterSwitch = _forChildrenFilterSwitch;
@synthesize classicalFilterSwitch = _classicalFilterSwitch;
@synthesize jazzFilterSwitch = _jazzFilterSwitch;
@synthesize popFilterSwitch = _popFilterSwitch;
@synthesize danceFilterSwitch = _danceFilterSwitch;


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
    
    NewYorkTimesEventsSearchCriteria *criteria = [self.delegate getNewYorkTimesEventCriteria];
    self.moviesFilterSwitch.on = [criteria.filterCategories containsObject:kMoviesFilterTag];
    self.theaterFilterSwitch.on = [criteria.filterCategories containsObject:kTheaterFilterTag];
    self.spareTimesFilterSwitch.on = [criteria.filterCategories containsObject:kSpareTimesFilterTag];
    self.artFilterSwitch.on = [criteria.filterCategories containsObject:kArtFilterTag];
    self.forChildrenFilterSwitch.on = [criteria.filterCategories containsObject:kForChildrenFilterTag];
    self.classicalFilterSwitch.on = [criteria.filterCategories containsObject:kClassicalFilterTag];
    self.jazzFilterSwitch.on = [criteria.filterCategories containsObject:kJazzFilterTag];
    self.popFilterSwitch.on = [criteria.filterCategories containsObject:kPopFilterTag];
    self.danceFilterSwitch.on = [criteria.filterCategories containsObject:kDanceFilterTag];
}

- (void)viewDidUnload
{
    [self setMoviesFilterSwitch:nil];
    [self setTheaterFilterSwitch:nil];
    [self setSpareTimesFilterSwitch:nil];
    [self setArtFilterSwitch:nil];
    [self setForChildrenFilterSwitch:nil];
    [self setClassicalFilterSwitch:nil];
    [self setJazzFilterSwitch:nil];
    [self setPopFilterSwitch:nil];
    [self setDanceFilterSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender
{
    NewYorkTimesEventsSearchCriteria *criteria = [self.delegate getNewYorkTimesEventCriteria];
    
    [criteria resetFilterCategories];
    if (self.moviesFilterSwitch.on) [criteria addFilterCategory:kMoviesFilterTag];
    if (self.theaterFilterSwitch.on) [criteria addFilterCategory:kTheaterFilterTag];
    if (self.spareTimesFilterSwitch.on) [criteria addFilterCategory:kSpareTimesFilterTag];
    if (self.artFilterSwitch.on) [criteria addFilterCategory:kArtFilterTag];
    if (self.forChildrenFilterSwitch.on) [criteria addFilterCategory:kForChildrenFilterTag];
    if (self.classicalFilterSwitch.on) [criteria addFilterCategory:kClassicalFilterTag];
    if (self.jazzFilterSwitch.on) [criteria addFilterCategory:kJazzFilterTag];
    if (self.popFilterSwitch.on) [criteria addFilterCategory:kPopFilterTag];
    if (self.danceFilterSwitch.on) [criteria addFilterCategory:kDanceFilterTag];
    
    [self.delegate searchNewYorkTimesEvents:criteria sender:self];
}


@end
