//
//  FoursquareFetcher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"
#import "BZFoursquare.h"


@interface FoursquareFetcher : NSObject <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>

- (void)searchVenues;
- (void)loadRecognizedFoursquareLocations:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)checkin:(NSDictionary *)location text:(NSString *)text onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)review:(NSString *)title text:(NSString *)text onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;

@end
