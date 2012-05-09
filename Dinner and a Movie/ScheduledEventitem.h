//
//  ScheduledEventitem.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScheduledEventitem <NSObject>

- (NSDate *)eventDate;
- (NSString *)eventDescription;

@end
