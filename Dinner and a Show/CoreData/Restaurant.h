//
//  Restaurant.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RestaurantLocation, ScheduledRestaurantEvent;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * mobileUrl;
@property (nonatomic, retain) NSString * ratingUrl;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) ScheduledRestaurantEvent *when;
@property (nonatomic, retain) RestaurantLocation *location;

@end
