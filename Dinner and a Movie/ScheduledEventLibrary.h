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
#import "PatchEvent.h"
#import "NewYorkTimesEvent.h"

#import "sqlite3.h"

@interface ScheduledEventLibrary : NSObject {

sqlite3 *database;

}

- (NSNumber *)addRecipeEvent:(AddRecipeToScheduleOptions *)options;
- (NSNumber *)addRestaurantEvent:(AddRestaurantToScheduleOptions *)options;
- (void)addLocalEvent:(PatchEvent *)event when:(NSDate *)when;
- (void)addNewYorkTimesEvent:(NewYorkTimesEvent *)event when:(NSDate *)when;

- (void)removeRecipeEvent:(Recipe *)recipe when:(NSDate *)when;
- (void)removeRestaurantEvent:(Restaurant *)restaurant when:(NSDate *)when;
- (void)removeLocalEvent:(PatchEvent *)event when:(NSDate *)when;
- (void)removeNewYorkTimesEvent:(NewYorkTimesEvent *)event when:(NSDate *)when;

- (NSArray *)scheduledItems;

@end
