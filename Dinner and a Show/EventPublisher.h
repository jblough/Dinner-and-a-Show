//
//  EventPublisher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduledEventitem.h"

@interface EventPublisher : NSObject

+ (void)checkinWithFacebook:(id<ScheduledEventitem>)event;
+ (void)reviewOnFacebook:(id<ScheduledEventitem>)event;

+ (void)checkinWithTwitter:(id<ScheduledEventitem>)event;
+ (void)reviewOnTwitter:(id<ScheduledEventitem>)event;

+ (void)checkinWithFoursquare:(id<ScheduledEventitem>)event;
+ (void)reviewOnFoursquare:(id<ScheduledEventitem>)event;

@end
