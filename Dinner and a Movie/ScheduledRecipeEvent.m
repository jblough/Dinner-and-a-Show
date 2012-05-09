//
//  ScheduledRecipeEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledRecipeEvent.h"
#import "Recipe.h"


@implementation ScheduledRecipeEvent

@synthesize date = _date;
@synthesize recipe = _recipe;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.recipe) ? self.recipe.name : @"";
}

@end
