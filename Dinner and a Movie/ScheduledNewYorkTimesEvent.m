//
//  ScheduledNewYorkTimesEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledNewYorkTimesEvent.h"
#import "NewYorkTimesEventDetailViewController.h"
#import "AppDelegate.h"

@implementation ScheduledNewYorkTimesEvent

@synthesize date = _date;
@synthesize event = _event;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;
@synthesize followUp = _followUp;

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.event) ? self.event.name : @"";
}

- (void)deleteEvent
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelete.eventLibrary removeNewYorkTimesEvent:self.event when:self.date];
}

- (NSString *)getSegue
{
    return @"NYT Event Selection Segue";
}

- (void)prepSegueDestination:(id)destinationViewController
{
    [(NewYorkTimesEventDetailViewController *)destinationViewController setEvent:self.event];
}

@end
