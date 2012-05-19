//
//  EventInformationParser.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventInformationParser.h"

@implementation EventInformationParser

+ (NSDate *)findDate:(NSString *)fromText
{
    NSError *error = NULL;
    
    NSDate *date = [[NSDate alloc] init];
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:&error];
    NSTextCheckingResult *result = [detector firstMatchInString:fromText options:0 range:NSMakeRange(0, [fromText length])];
    if (result) date = [result date];

    // Convert to time zone consistent with what date picker expects
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:date];
    date = [NSDate dateWithTimeInterval:seconds sinceDate:date];
    
    return date;
}

+ (NSDate *)convertDate:(NSString *)jsonDate
{
    // Convert the RFC 3339 date time string to an NSDate.
    NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateReader setLocale:enUSPOSIXLocale];
    [dateReader setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [dateReader setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    //NSDateFormatter *dateReader = [[NSDateFormatter alloc] init];
    //[dateReader setDateFormat:@"yyyy-MM-ddTHH:mm:"]; // "2011-04-11T04:00:00.1Z"
    return [dateReader dateFromString:jsonDate];
}

@end
