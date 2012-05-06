//
//  ScheduledRestaurantEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant;

@interface ScheduledRestaurantEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Restaurant *reservations;

@end
