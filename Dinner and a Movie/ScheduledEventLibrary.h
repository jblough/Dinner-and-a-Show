//
//  ScheduledEventLibrary.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddRecipeToScheduleOptions.h"
#import "AddRestaurantToScheduleOptions.h"
#import "AddLocalEventToScheduleOptions.h"
#import "AddNewYorkTimesEventToScheduleOptions.h"
#import "ScheduledEventitem.h"
#import "CustomEvent.h"

#import "sqlite3.h"

@interface ScheduledEventLibrary : NSObject {

sqlite3 *database;

}

- (Recipe *)loadRecipe:(NSString *)identifier;
- (NSNumber *)addRecipeEventToSchedule:(AddRecipeToScheduleOptions *)options;
- (Restaurant *)loadRestaurant:(NSString *)identifier;
- (NSNumber *)addRestaurantEventToSchedule:(AddRestaurantToScheduleOptions *)options;
- (PatchEvent *)loadLocalEvent:(NSString *)identifier;
- (NSNumber *)addLocalEventToSchedule:(AddLocalEventToScheduleOptions *)options;
- (NewYorkTimesEvent *)loadNewYorkTimesEvent:(NSString *)identifier;
- (NSNumber *)addNewYorkTimesEventToSchedule:(AddNewYorkTimesEventToScheduleOptions *)options;
- (NSNumber *)addCustomEventToSchedule:(CustomEvent *)event;

- (void)removeRecipeEvent:(Recipe *)recipe when:(NSDate *)when;
- (void)removeRestaurantEvent:(Restaurant *)restaurant when:(NSDate *)when;
- (void)removeLocalEvent:(PatchEvent *)event when:(NSDate *)when;
- (void)removeNewYorkTimesEvent:(NewYorkTimesEvent *)event when:(NSDate *)when;
- (void)removeCustomEvent:(CustomEvent *)event when:(NSDate *)when;

- (void)favoriteRecipe:(Recipe *)recipe;
- (void)unfavoriteRecipe:(Recipe *)recipe;
- (BOOL)isFavoriteRecipe:(Recipe *)recipe;
- (void)favoriteRestaurant:(Restaurant *)restaurant;
- (void)unfavoriteRestaurant:(Restaurant *)restaurant;
- (BOOL)isFavoriteRestaurant:(Restaurant *)restaurant;

- (NSArray *)scheduledItems;
- (NSSet *)getFavoriteRecipes;
- (NSSet *)getFavoriteRestaurants;

- (NSArray *)getFavoriteFullRecipes;
- (NSArray *)getFavoriteFullRestaurants;

@end
