//
//  CalendarEvent.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarEvent.h"

@implementation CalendarEvent
@synthesize eventId = _eventId;
@synthesize type = _type;
@synthesize identifier = _identifier;
@synthesize title = _title;
@synthesize startDate = _startDate;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;
@synthesize checkin = _checkin;
@synthesize checkinMinutes = _checkinMinutes;
@synthesize followUp = _followUp;
@synthesize followUpWhen = _followUpWhen;
@synthesize url = _url;
@synthesize location = _location;
@synthesize notes = _notes;
@synthesize followUpUrl = _followUpUrl;
@synthesize followUpNotes = _followUpNotes;

- (NSDictionary *)generateUserInfo {
    // Format the date for consistent retrieval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSString *when = [dateFormatter stringFromDate:self.startDate];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.eventId, @"id",
            self.identifier, @"identifier",
            self.type, @"type",
            self.title, @"name",
            when, @"when",
            nil];
}

- (NSDictionary *)generateCheckinUserInfo {
    // Format the date for consistent retrieval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSString *when = [dateFormatter stringFromDate:[self.startDate dateByAddingTimeInterval:(60 * self.checkinMinutes)]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.eventId, @"id",
            self.identifier, @"identifier",
            [NSString stringWithFormat:@"%@ checkin", self.type], @"type",
            self.title, @"name",
            when, @"when",
            nil];
}

- (NSDictionary *)generateFollowUpUserInfo {
    // Format the date for consistent retrieval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSString *when = [dateFormatter stringFromDate:self.startDate];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.eventId, @"id",
            self.identifier, @"identifier",
            [NSString stringWithFormat:@"%@ followup", self.type], @"type",
            self.title, @"name",
            when, @"when",
            nil];
}

@end
