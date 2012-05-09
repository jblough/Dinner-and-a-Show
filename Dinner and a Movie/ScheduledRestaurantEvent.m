//
//  ScheduledRestaurantEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledRestaurantEvent.h"
#import "Restaurant.h"


@implementation ScheduledRestaurantEvent

@synthesize date = _date;
@synthesize restaurant = _restaurant;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;
@synthesize followUp = _followUp;

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.restaurant) ? self.restaurant.name : @"";
}

@end
