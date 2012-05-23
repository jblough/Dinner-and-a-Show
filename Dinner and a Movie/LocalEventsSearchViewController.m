//
//  LocalEventsSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventsSearchViewController.h"
#import "AppDelegate.h"

@interface LocalEventsSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchZipCode;
@property (weak, nonatomic) IBOutlet UITextField *searchTerm;
@end

@implementation LocalEventsSearchViewController
@synthesize searchZipCode = _searchZipCode;
@synthesize searchTerm = _searchTerm;
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
    
    if (!([self.delegate getLocalEventCriteria].zipCode) || [@"" isEqualToString:[self.delegate getLocalEventCriteria].zipCode]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.userSpecifiedCode)
            self.searchZipCode.text = appDelegate.userSpecifiedCode;
        else
            self.searchZipCode.text = appDelegate.zipCode;
    }
    else {
        self.searchZipCode.text = [self.delegate getLocalEventCriteria].zipCode;
    }
    self.searchTerm.text = [self.delegate getLocalEventCriteria].searchTerm;
}

- (void)viewDidUnload
{
    [self setSearchZipCode:nil];
    [self setSearchTerm:nil];
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

- (IBAction)cancel
{
    [self.delegate cancel];
}

- (IBAction)done:(id)sender
{
    LocalEventsSearchCriteria *criteria = [[LocalEventsSearchCriteria alloc] init];
    criteria.zipCode = self.searchZipCode.text;
    criteria.searchTerm = self.searchTerm.text;
    
    [self.delegate searchLocalEvents:criteria sender:self];
}

@end
