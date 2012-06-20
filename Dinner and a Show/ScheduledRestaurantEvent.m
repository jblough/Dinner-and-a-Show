//
//  ScheduledRestaurantEvent.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledRestaurantEvent.h"
#import "Restaurant.h"
#import "RestaurantViewController.h"
#import "AppDelegate.h"
#import "EventInformationParser.h"


@implementation ScheduledRestaurantEvent

@synthesize date = _date;
@synthesize restaurant = _restaurant;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;
@synthesize checkin = _checkin;
@synthesize checkinMinutes = _checkinMinutes;
@synthesize followUp = _followUp;
@synthesize followUpWhen = _followUpWhen;


- (void)setDate:(NSDate *)date
{
    _date = [EventInformationParser removeSeconds:date];
}

- (void)setFollowUpWhen:(NSDate *)followUpWhen
{
    _followUpWhen = [EventInformationParser removeSeconds:followUpWhen];
}

- (NSString *)eventId
{
    return [NSString stringWithFormat:@"%@ - %@", self.restaurant.identifier, self.date];
}

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.restaurant) ? self.restaurant.name : @"";
}

- (void)deleteEvent
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelete.eventLibrary removeRestaurantEvent:self.restaurant when:self.date];
    [appDelete removeNotification:self];
}

- (NSString *)getSegue
{
    return @"Restaurant Selection Segue";
}

- (void)prepSegueDestination:(id)destinationViewController
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Restaurant *fullRestaurant = [appDelete.eventLibrary loadRestaurant:self.restaurant.identifier];
    [(RestaurantViewController *)destinationViewController setRestaurant:fullRestaurant];
    [(RestaurantViewController *)destinationViewController setOriginalEvent:self];
}

@end
