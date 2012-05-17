//
//  ScheduledNYTimesEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NYTimesEvent;

@interface ScheduledNYTimesEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *events;
@end

@interface ScheduledNYTimesEvent (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NYTimesEvent *)value;
- (void)removeEventsObject:(NYTimesEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
