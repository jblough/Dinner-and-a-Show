//
//  PatchFetcher.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"
#import "PatchEvent.h"
#import "LocalEventsSearchCriteria.h"

#define kLocalEventPageSize 20

@interface PatchFetcher : NSObject

+ (void)events:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;
+ (void)loadEvent:(PatchEvent *)recipe onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;

+ (void)events:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler)onError;
+ (void)events:(LocalEventsSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;

@end
