//
//  RestaurantSearchCriteria.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RestaurantSearchCriteria : NSObject

@property BOOL useCurrentLocation;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *searchTerm;

@end
