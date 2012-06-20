//
//  FoursquareFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareFetcher.h"
#import "BZFoursquare.h"
#import "ApiKeys.h"
#import "AppDelegate.h"

static CompletionHandler _completionHandler;
static ErrorHandler _errorHandler;

@interface FoursquareFetcher ()

@property (nonatomic, strong) BZFoursquareRequest *request;
@property (nonatomic, strong) NSDictionary        *meta;
@property (nonatomic, strong) NSArray             *notifications;
@property (nonatomic, strong) NSDictionary        *response;

- (void)searchVenues;

@end

@implementation FoursquareFetcher
@synthesize request = _request;
@synthesize meta = _meta;
@synthesize notifications = _notifications;
@synthesize response = _response;

- (void)loadRecognizedFoursquareLocations:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    _completionHandler = [onCompletion copy];
    _errorHandler = [onError copy];
 
    [self searchVenues];
}

- (void)checkin:(NSDictionary *)location text:(NSString *)text onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    _completionHandler = [onCompletion copy];
    _errorHandler = [onError copy];
}

- (void)review:(NSString *)title text:(NSString *)text onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    _completionHandler = [onCompletion copy];
    _errorHandler = [onError copy];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    //[self updateView];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_completionHandler)
        _completionHandler(self.response);
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    //[self updateView];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)cancelRequest
{
    //_completionHandler = nil;
    //_errorHandler = nil;
    
    if (self.request) {
        self.request.delegate = nil;
        [self.request cancel];
        self.request = nil;
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest
{
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
    self.request.delegate = self;
}

- (void)searchVenues
{
    NSLog(@"searchVenues");
    [self prepareForRequest];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *coordinateString = [NSString stringWithFormat:@"%f,%f", appDelegate.coordinate.coordinate.latitude, appDelegate.coordinate.coordinate.longitude];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:coordinateString, @"ll", nil];
    //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"42.31657,-84.01989", @"ll", nil];
    self.request = [appDelegate.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [self.request start];
}

- (void)checkin
{
    NSLog(@"checkin");
    [self prepareForRequest];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"4d341a00306160fcf0fc6a88", @"venueId", @"public", @"broadcast", nil];
    self.request = [appDelegate.foursquare requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    self.request.delegate = nil;
    [self.request start];
    //[self updateView];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
