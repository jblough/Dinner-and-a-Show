//
//  NYTimesEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NYTimesEventDay, ScheduledNYTimesEvent;

@interface NYTimesEvent : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSString * theaterUrl;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * isKidFriendly;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * subcategory;
@property (nonatomic, retain) NSNumber * isFree;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) ScheduledNYTimesEvent *when;
@property (nonatomic, retain) NSSet *days;
@end

@interface NYTimesEvent (CoreDataGeneratedAccessors)

- (void)addDaysObject:(NYTimesEventDay *)value;
- (void)removeDaysObject:(NYTimesEventDay *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
