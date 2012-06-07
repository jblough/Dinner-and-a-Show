//
//  LocalEventDetailViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEventDetailViewController.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "SVProgressHUD.h"

@interface LocalEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LocalEventDetailViewController
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
    self.title = self.event.title;
    self.webView.delegate = self;
    [SVProgressHUD showWithStatus:@"Loading web page"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:self.event.url]]];
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
    if ([segue.identifier isEqualToString:@"Add Local Event Segue"]) {
        UINavigationController *navController = segue.destinationViewController;
        [(AddLocalEventToScheduleViewController *)navController.topViewController setDelegate:self];
        if (self.originalEvent)
            [(AddLocalEventToScheduleViewController *)navController.topViewController setOriginalEvent:self.originalEvent];
    }
}

#pragma mark -
#pragma mark AddLocalEventDelegate
- (void)add:(AddLocalEventToScheduleOptions *)options sender:(id)sender
{
    // Remove the original event
    [self.originalEvent deleteEvent];
    
    // Add the updated event
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.event = self.event;
    [library addLocalEventToSchedule:options];
    
    // Add to calendar
    if (options.reminder) {
        CalendarEvent *event = [[CalendarEvent alloc] init];
        event.eventId = [NSString stringWithFormat:@"%@ - %@", self.event.identifier, options.when];
        event.type = @"local";
        event.identifier = options.event.identifier;
        event.title = options.event.title;
        event.url = options.event.url;
        event.startDate = options.when;
        event.reminder = options.reminder;
        event.minutesBefore = options.minutesBefore;
        event.followUp = options.followUp;
        if (options.followUp) {
            // This URL should point to a social networking site like Facebook or GetGlue for review
            event.followUpUrl = options.event.url;
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

- (PatchEvent *)getEvent
{
    return self.event;
}

@end
