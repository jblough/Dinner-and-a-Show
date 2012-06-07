//
//  NYTimesEventDay.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NYTimesEvent;

@interface NYTimesEventDay : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NYTimesEvent *event;

@end
