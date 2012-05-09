//
//  NewYorkTimesFetcher.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"
#import "NewYorkTimesEvent.h"
#import "NewYorkTimesEventsSearchCriteria.h"

#define kNewYorkTimesEventsPageSize 50

@interface NewYorkTimesFetcher : NSObject

+ (void)events:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
+ (void)events:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
+ (void)events:(NewYorkTimesEventsSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;

@end
