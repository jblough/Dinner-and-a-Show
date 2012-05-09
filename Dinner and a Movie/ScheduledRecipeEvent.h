//
//  ScheduledRecipeEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduledEventitem.h"

@class Recipe;

@interface ScheduledRecipeEvent : NSObject <ScheduledEventitem>

@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) Recipe *recipe;
@property BOOL reminder;
@property int minutesBefore;

@end
