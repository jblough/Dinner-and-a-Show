//
//  FacebookFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookFetcher.h"
#import "AppDelegate.h"
#import "FBRequestOperation.h"
#import "Facebook+Blocks.h"

@implementation FacebookFetcher

- (void)loadRecognizedFacebookLocations:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate initFacebook:^{

    NSString *centerLocation = [[NSString alloc] initWithFormat:@"%f,%f",
                                appDelegate.coordinate.coordinate.latitude,//42.31353325,
                                appDelegate.coordinate.coordinate.longitude];//-83.94389582];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",  @"type",
                                   centerLocation, @"center",
                                   @"1000",  @"distance",
                                   nil];
    //[[appDelegate facebook] requestWithGraphPath:@"search" andParams:params andDelegate:self];
        FBRequestOperation *request = [appDelegate.facebook requestWithGraphPath:@"search" andParams:params
                            andCompletionHandler:^(FBRequestOperation *request, id jsonResponse, NSError *error) {
                                NSLog(@"%@", request.description);
                                if (error) {
                                    onError(error);
                                }
                                else {
                                    onCompletion(jsonResponse);
                                }
                            }];
        
        [[NSOperationQueue mainQueue] addOperation:request];
    }];

    /*
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place", @"type", 
                                   [NSString stringWithFormat:@"%f,%f", 
                                    42.31353325//appDelegate.coordinate.coordinate.latitude,
                                    -83.94389582//appDelegate.coordinate.coordinate.longitude
                                    ], @"center",
                                   @"1000", @"distance",
                                   nil];
    */
    /*
    [appDelegate initFacebook:^{
        
        
        [appDelegate.facebook requestWithGraphPath:@"search" andParams:params
                            andCompletionHandler:^(FBRequestOperation *request, id jsonResponse, NSError *error) {
                                if (error) {
                                    onError(error);
                                }
                                else {
                                    onCompletion(jsonResponse);
                                }
                            }];
    }];
     
    */
    /*
    [appDelegate initFacebook:^{
        [appDelegate.facebook requestWithGraphPath:@"search" 
                                       andParams:params
                                     andDelegate:self];
    }];
    */
    
}

- (void)checkin:(NSDictionary *)location text:(NSString *)text onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [appDelegate initFacebook:^{

        NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [[location objectForKey:@"location"] objectForKey:@"latitude"],@"latitude",
                                     [[location objectForKey:@"location"] objectForKey:@"longitude"],@"longitude",
                                     nil];
        
        SBJSON *jsonWriter = [[SBJSON alloc] init];
        NSString *coordinatesStr = [jsonWriter stringWithObject:coordinates];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [location objectForKey:@"id"], @"place",
                                       coordinatesStr, @"coordinates",
                                       text, @"message",
                                       nil];
        
        
    /*NSMutableDictionary *coordinatesDictionary = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%f", appDelegate.coordinate.coordinate.latitude], @"latitude", 
     [NSString stringWithFormat:@"%f", appDelegate.coordinate.coordinate.longitude], @"longitude", 
     nil];
    SBJSON *json = [[SBJSON alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [json stringWithObject:coordinatesDictionary], @"coordinates",
                                   text, @"message",
                                   nil];*/
    /*[appDelegate.facebook requestWithGraphPath:@"me/checkins" 
                                   andParams:params 
                               andHttpMethod:@"POST" 
                                 andDelegate:self];*/
    
    FBRequestOperation *request = [appDelegate.facebook requestWithGraphPath:@"me/checkins" andParams:params
                                                               andHttpMethod:@"POST"
                                                        andCompletionHandler:^(FBRequestOperation *request, id jsonResponse, NSError *error) {
                                                            NSLog(@"%@", request.description);
                                                            if (error) {
                                                                onError(error);
                                                            }
                                                            else {
                                                                onCompletion(jsonResponse);
                                                            }
                                                        }];
    
    [[NSOperationQueue mainQueue] addOperation:request];
    }];

}

- (void)review:(NSString *)title text:(NSString *)text
{
    
}


/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request
{
    
}

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    // Assume that we're receiving the results of a location search for a check-in
    NSArray *places = [result objectForKey:@"data"];
    if ([places count] > 0) {
        NSDictionary *place = [places objectAtIndex:0];
        if (place) {
            NSDictionary *locationDictionary = [place objectForKey:@"location"];
            NSMutableDictionary *coordinatesDictionary = 
                [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 [locationDictionary objectForKey:@"latitude"], @"latitude", 
                 [locationDictionary objectForKey:@"longitude"], @"longitude", 
                 nil];
            
            SBJSON *json = [[SBJSON alloc] init];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.facebook requestWithGraphPath:@"me/checkins" 
                                           andParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      [place objectForKey:@"id"], @"place", 
                                                       [json stringWithObject:coordinatesDictionary], @"coordinates",
                                                        @"message!!!", @"message",
                                                        nil] 
                                       andHttpMethod:@"POST" 
                                         andDelegate:self];
        }
    }
}

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
    
}

@end
