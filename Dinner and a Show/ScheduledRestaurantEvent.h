//
//  ScheduledRestaurantEvent.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduledEventitem.h"

@class Restaurant;

@interface ScheduledRestaurantEvent : NSObject <ScheduledEventitem>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Restaurant *restaurant;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;
@property (nonatomic, strong) NSDate *followUpWhen;

@end
