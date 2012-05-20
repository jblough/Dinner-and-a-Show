//
//  CustomEvent.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduledEventitem.h"

@interface CustomEvent : NSObject <ScheduledEventitem>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *when;
@property double latitude;
@property double longitude;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;

@end
