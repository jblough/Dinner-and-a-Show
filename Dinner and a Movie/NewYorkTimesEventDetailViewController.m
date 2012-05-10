//
//  NewYorkTimesEventDetailViewController.m
//  Dinner and a Movie
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
        [(AddNewYorkTimesEventToScheduleViewController *)segue.destinationViewController setDelegate:self];
    }
}

#pragma mark -
#pragma mark AddNewYorkTimesEventDelegate
- (void)add:(AddNewYorkTimesEventToScheduleOptions *)options sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.event = self.event;
    [library addNewYorkTimesEventToSchedule:options];
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
