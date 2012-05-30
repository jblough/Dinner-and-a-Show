//
//  ScheduledRestaurantEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledRestaurantEvent.h"
#import "Restaurant.h"
#import "RestaurantDetailsViewController.h"
#import "AppDelegate.h"


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

- (void)deleteEvent
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelete.eventLibrary removeRestaurantEvent:self.restaurant when:self.date];
    [appDelete removeFromCalendar:self];
}

- (NSString *)getSegue
{
    return @"Restaurant Selection Segue";
}

- (void)prepSegueDestination:(id)destinationViewController
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Restaurant *fullRestaurant = [appDelete.eventLibrary loadRestaurant:self.restaurant.identifier];
    [(RestaurantDetailsViewController *)destinationViewController setRestaurant:fullRestaurant];
    [(RestaurantDetailsViewController *)destinationViewController setOriginalEvent:self];
}

@end
