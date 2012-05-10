//
//  NewYorkTimesEventsSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventsSearchViewController.h"

@interface NewYorkTimesEventsSearchViewController ()

@end

@implementation NewYorkTimesEventsSearchViewController
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender
{
    NewYorkTimesEventsSearchCriteria *criteria = [[NewYorkTimesEventsSearchCriteria alloc] init];
    
    [self.delegate search:criteria sender:self];
}

@end
