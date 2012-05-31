//
//  ScheduledLocalEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledLocalEvent.h"
#import "LocalEventDetailViewController.h"
#import "AppDelegate.h"

@implementation ScheduledLocalEvent

@synthesize date = _date;
@synthesize event = _event;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;
@synthesize followUp = _followUp;
@synthesize followUpWhen = _followUpWhen;

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.event) ? self.event.title : @"";
}

- (void)deleteEvent
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelete.eventLibrary removeLocalEvent:self.event when:self.date];
    [appDelete removeFromCalendar:self];
}

- (NSString *)getSegue
{
    return @"Local Event Selection Segue";
}

- (void)prepSegueDestination:(id)destinationViewController
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PatchEvent *fullEvent = [appDelete.eventLibrary loadLocalEvent:self.event.identifier];
    [(LocalEventDetailViewController *)destinationViewController setEvent:fullEvent];
    [(LocalEventDetailViewController *)destinationViewController setOriginalEvent:self];
}

@end
