//
//  YelpFetcher.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fetcher.h"
#import "Cuisine+Restaurant.h"

@interface YelpFetcher : NSObject

- (void) retrieve;

- (void)cuisines:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;
- (void)restaurantsForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;

@end
