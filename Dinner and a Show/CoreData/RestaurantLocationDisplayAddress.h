//
//  RestaurantLocationDisplayAddress.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RestaurantLocation;

@interface RestaurantLocationDisplayAddress : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) RestaurantLocation *locationDisplayAddress;

@end
