//
//  PearsonFetcher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fetcher.h"
#import "Cuisine.h"
#import "Recipe.h"
#import "RecipeSearchCriteria.h"

#define kRecipePageSize 50

@interface PearsonFetcher : NSObject

+ (void)cuisines:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
+ (void)recipesForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;
+ (void)recipesForCuisine:(Cuisine *)cuisine page:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler)onError;
+ (void)recipesForCuisine:(Cuisine *)cuisine search:(RecipeSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError;
+ (void)loadFullRecipe:(Recipe *)recipe onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError;

@end
