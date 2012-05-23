//
//  CalendarEvent.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarEvent : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startDate;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *followUpUrl;
@property (nonatomic, strong) NSString *followUpNotes;

@end
