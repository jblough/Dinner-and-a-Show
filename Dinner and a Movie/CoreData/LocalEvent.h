//
//  LocalEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScheduledLocalEvent;

@interface LocalEvent : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) ScheduledLocalEvent *when;

@end
