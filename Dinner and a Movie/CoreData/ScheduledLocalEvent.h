//
//  ScheduledLocalEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocalEvent;

@interface ScheduledLocalEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) LocalEvent *events;

@end
