//
//  RestaurantDetailsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantDetailsViewController.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "SVProgressHUD.h"

@interface RestaurantDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation RestaurantDetailsViewController
@synthesize webView = _webView;
@synthesize restaurant = _restaurant;

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
    
    self.title = self.restaurant.name;
    self.webView.delegate = self;
    [SVProgressHUD showWithStatus:@"Loading web page"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:self.restaurant.mobileUrl]]];

    //[self.webView loadHTMLString:[self restaurantAsHtml] baseURL:nil];
    //[SVProgressHUD dismiss];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setRestaurant:nil];
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

- (NSString *)restaurantAsHtml
{
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<html>"];
    if (self.restaurant) {
        [html appendFormat:@"<head><title>%@</title><style>#address, #snippet, #yelp-links { padding-top: 10px; } #snippet { padding-top: 10px; font-style: italic; }</style></head>", self.restaurant.name];
        [html appendFormat:@"<body><img src=\"%@\" style=\"float: right;\" /><br/><div id=\"heading\"><h3>%@</h3></div>", self.restaurant.imageUrl, self.restaurant.name];
        [html appendFormat:@"<div id=\"images\"><img src=\"%@\" /><br/></div>", self.restaurant.ratingUrl];
        [html appendFormat:@"<div id=\"address\">%@<br/>%@, %@ %@<br/></div>", [self.restaurant.location.address objectAtIndex:0], self.restaurant.location.city,
         self.restaurant.location.state, self.restaurant.location.postalCode];
        [html appendFormat:@"<div id=\"phone\">%@</div><div id=\"yelp-links\"><a href=\"%@\">%@ Yelp Site</a><br/><a href=\"%@\">%@ Mobile Yelp Site</a><br/></div>",
         self.restaurant.phone, self.restaurant.url, self.restaurant.name, self.restaurant.mobileUrl, self.restaurant.name];
        [html appendFormat:@"<div id=\"snippet\">%@</div></body></html>", self.restaurant];
    }
    return [html copy];
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
    if ([segue.identifier isEqualToString:@"Add Restaurant Segue"]) {
        [(AddRestaurantToScheduleViewController *)segue.destinationViewController setDelegate:self];
    }
}

#pragma mark -
#pragma mark AddRestaurantDelegate
- (void)add:(AddRestaurantToScheduleOptions *)options sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.restaurant = self.restaurant;
    [library addRestaurantEventToSchedule:options];
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
