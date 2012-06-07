//
//  FactualFetcher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>
#import "Fetcher.h"
#import "RestaurantSearchCriteria.h"
#import "Cuisine+Restaurant.h"
#import "Restaurant.h"

#define kFactualRestaurantPageSize 50

@interface FactualFetcher : NSObject <FactualAPIDelegate>

- (void)cuisines:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)restaurantsForCuisine:(Cuisine *)cuisine page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)restaurantsForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)restaurantsForCuisine:(Cuisine *)cuisine search:(RestaurantSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
- (void)loadFullRestaurant:(Restaurant *)restaurant onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;

@end
