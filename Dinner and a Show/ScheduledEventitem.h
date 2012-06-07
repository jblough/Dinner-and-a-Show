//
//  ScheduledEventitem.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScheduledEventitem <NSObject>

- (NSString *)eventId;
- (NSDate *)eventDate;
- (NSString *)eventDescription;
- (void)deleteEvent;

- (NSString *)getSegue;
- (void)prepSegueDestination:(id)destinationViewController;

@end
