//
//  ScheduledLocalEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledLocalEvent.h"

@implementation ScheduledLocalEvent

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
    return (self.event) ? self.event.title : @"";
}

@end
