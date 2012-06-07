//
//  NewYorkTimesEventDetailViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventDetailViewController.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "SVProgressHUD.h"

@interface NewYorkTimesEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewYorkTimesEventDetailViewController
@synthesize webView = _webView;
@synthesize event = _event;
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
    self.title = self.event.name;
    self.webView.delegate = self;
    [SVProgressHUD showWithStatus:@"Loading web page"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:self.event.eventUrl]]];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.webView.isLoading)
        [self.webView stopLoading];
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismissWithError:error.localizedDescription];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add NYT Event Segue"]) {
        UINavigationController *navController = segue.destinationViewController;
        [(AddNewYorkTimesEventToScheduleViewController *)navController.topViewController setDelegate:self];
        if (self.originalEvent)
            [(AddNewYorkTimesEventToScheduleViewController *)navController.topViewController setOriginalEvent:self.originalEvent];
    }
}

#pragma mark -
#pragma mark AddNewYorkTimesEventDelegate
- (void)add:(AddNewYorkTimesEventToScheduleOptions *)options sender:(id)sender
{
    // Remove the original event
    [self.originalEvent deleteEvent];
    
    // Add the updated event
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.event = self.event;
    [library addNewYorkTimesEventToSchedule:options];
    
    // Add to calendar
    if (options.reminder) {
        CalendarEvent *event = [[CalendarEvent alloc] init];
        event.eventId = [NSString stringWithFormat:@"%@ - %@", self.event.identifier, options.when];
        event.type = @"nytimes";
        event.identifier = options.event.identifier;
        event.title = options.event.name;
        event.url = options.event.eventUrl;
        event.notes = options.event.phone;
        event.startDate = options.when;
        event.reminder = options.reminder;
        event.minutesBefore = options.minutesBefore;
        event.followUp = options.followUp;
        event.followUpWhen = options.followUpDate;
        if (options.followUp) {
            // This URL should point to a social networking site like Facebook or GetGlue for review
            event.followUpUrl = options.event.eventUrl;
        }
        [appDelegate addNotification:event];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

- (NewYorkTimesEvent *)getEvent
{
    return self.event;
}

@end
