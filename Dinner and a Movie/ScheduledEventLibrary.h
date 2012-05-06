//
//  ScheduledEventLibrary.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"
#import "Restaurant.h"
#import "PatchEvent.h"
#import "NewYorkTimesEvent.h"

@interface ScheduledEventLibrary : NSObject

+ (void)addRecipeEvent:(Recipe *)recipe when:(NSDate *)when;
+ (void)addRestaurantEvent:(Restaurant *)restaurant when:(NSDate *)when;
+ (void)addLocalEvent:(PatchEvent *)event when:(NSDate *)when;
+ (void)addNewYorkTimesEvent:(NewYorkTimesEvent *)event when:(NSDate *)when;

@end
