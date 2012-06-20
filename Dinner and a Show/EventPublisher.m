//
//  EventPublisher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventPublisher.h"

#import "FacebookFetcher.h"
#import "FoursquareFetcher.h"

#import "AppDelegate.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"

#import <Twitter/Twitter.h>

@implementation EventPublisher

+ (NSDictionary *)determineCorrectLocation:(NSArray *)locations name:(NSString *)name
{
    // If only one location found, use it
    if ([locations count] == 1) {
        return [locations objectAtIndex:0];
    }
    
    // Loop through the locations and return the first to match on the "name" field
    __block int matchingIdx = -1;
    [locations enumerateObjectsUsingBlock:^(NSDictionary *location, NSUInteger idx, BOOL *stop) {
        if ([[location objectForKey:@"name"] isEqualToString:name]) {
            matchingIdx = idx;
            *stop = YES;
        }
    }];
    
    return (matchingIdx > -1) ? [locations objectAtIndex:matchingIdx] : nil;
}

+ (void)checkinWithFacebook:(id<ScheduledEventitem>)event
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FacebookFetcher *fetcher = [[FacebookFetcher alloc] init];
    [fetcher loadRecognizedFacebookLocations:^(id data) {
        //NSLog(@"%@", data);
        // Try to figure out which location to pick
        NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
        NSArray *resultData = [data objectForKey:@"data"];
        for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
            [places addObject:[resultData objectAtIndex:i]];
        }
        
        if ([places count] > 0) {
            NSString *eventName = [event eventDescription];
            NSDictionary *location = [self determineCorrectLocation:places name:eventName];
            if (!location) {
                NSMutableArray *locationDescriptions = [NSMutableArray arrayWithCapacity:[places count]];
                [places enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    [locationDescriptions addObject:[obj objectForKey:@"name"]];
                }];
                
                [UIActionSheet showActionSheetWithTitle:[NSString stringWithFormat:@"Checkin for %@?", eventName]
                                      cancelButtonTitle:@"Cancel" 
                                 destructiveButtonTitle:nil 
                                      otherButtonTitles:locationDescriptions
                                                   view:appDelete.window
                                              onDismiss:^(int selected) {
                                                  NSDictionary *selectedPlace = [places objectAtIndex:selected];
                                                  NSString *name = [selectedPlace objectForKey:@"name"];
                                                  NSLog(@"Selected %@", name);
                                                  [UIAlertView showAlertViewWithTitle:[NSString stringWithFormat:@"Checkin to %@", name] message:@"Add optional message" cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObject:@"Checkin"] onDismiss:^(NSString *text) {
                                                      // Finally do the actual check-in
                                                      [fetcher checkin:selectedPlace text:text onCompletion:^(id data) {
                                                          NSLog(@"%@", data);
                                                      } onError:^(NSError *error) {
                                                          NSLog(@"%@", error.description);
                                                      }];
                                                  } onCancel:^{
                                                      ;
                                                  }];
                                              } onCancel:^{
                                                  NSLog(@"Cancelled");
                                              }];
            }
            else {
                [fetcher checkin:location text:@"" onCompletion:^(id data) {
                    NSLog(@"%@", data);
                } onError:^(NSError *error) {
                    NSLog(@"%@", error.description);
                }];
            }
        }
        
    } onError:^(NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
}

+ (void)reviewOnFacebook:(id<ScheduledEventitem>)event
{
    
}

+ (void)checkinWithTwitter:(id<ScheduledEventitem>)event
{
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"at %@", [event eventDescription]]];
        AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelete.window.rootViewController presentModalViewController:tweetSheet animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem" 
                                                        message:@"Unable to send Tweet at this time.  Have you set up a Twitter account in settings?" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}

+ (void)reviewOnTwitter:(id<ScheduledEventitem>)event
{
    
}

+ (void)checkinWithFoursquare:(id<ScheduledEventitem>)event
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //NSArray *events = [appDelete.eventLibrary scheduledItems];
    //[EventPublisher checkinWithFacebook:[events objectAtIndex:0]];
    __block FoursquareFetcher *fetcher = [[FoursquareFetcher alloc] init];
    [appDelete initFoursquare:^{
        //NSLog(@"Done");
        [fetcher loadRecognizedFoursquareLocations:^(id data) {
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [data objectForKey:@"venues"];
            for (NSUInteger i=0; i<[resultData count]; i++) {
                [places addObject:[resultData objectAtIndex:i]];
            }
            
            
            if ([places count] > 0) {
                NSString *eventName = [event eventDescription];
                NSDictionary *location = [self determineCorrectLocation:places name:eventName];
                if (!location) {
                    NSMutableArray *locationDescriptions = [NSMutableArray arrayWithCapacity:[places count]];
                    [places enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                        [locationDescriptions addObject:[obj objectForKey:@"name"]];
                    }];
                    
                    [UIActionSheet showActionSheetWithTitle:[NSString stringWithFormat:@"Checkin for %@?", eventName]
                                          cancelButtonTitle:@"Cancel" 
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles:locationDescriptions
                                                       view:appDelete.window
                                                  onDismiss:^(int selected) {
                                                      NSDictionary *selectedPlace = [places objectAtIndex:selected];
                                                      NSString *name = [selectedPlace objectForKey:@"name"];
                                                      NSLog(@"Selected %@", name);
                                                      [UIAlertView showAlertViewWithTitle:[NSString stringWithFormat:@"Checkin to %@", name] message:@"Add optional message" cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObject:@"Checkin"] onDismiss:^(NSString *text) {
                                                          // Finally do the actual check-in
                                                          [fetcher checkin:selectedPlace text:text onCompletion:^(id data) {
                                                              NSLog(@"%@", data);
                                                          } onError:^(NSError *error) {
                                                              NSLog(@"%@", error.description);
                                                          }];
                                                      } onCancel:^{
                                                          ;
                                                      }];
                                                  } onCancel:^{
                                                      NSLog(@"Cancelled");
                                                  }];
                }
                else {
                    [fetcher checkin:location text:@"" onCompletion:^(id data) {
                        NSLog(@"%@", data);
                    } onError:^(NSError *error) {
                        NSLog(@"%@", error.description);
                    }];
                }
            }
        } onError:^(NSError *error) {
            NSLog(@"Error: %@", error.description);
        }];
    }];
}

@end
