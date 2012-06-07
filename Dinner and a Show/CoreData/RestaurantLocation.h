//
//  RestaurantLocation.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant, RestaurantLocationAddress, RestaurantLocationDisplayAddress;

@interface RestaurantLocation : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *restaurant;
@property (nonatomic, retain) RestaurantLocationAddress *address;
@property (nonatomic, retain) NSSet *displayAddress;
@end

@interface RestaurantLocation (CoreDataGeneratedAccessors)

- (void)addRestaurantObject:(Restaurant *)value;
- (void)removeRestaurantObject:(Restaurant *)value;
- (void)addRestaurant:(NSSet *)values;
- (void)removeRestaurant:(NSSet *)values;

- (void)addDisplayAddressObject:(RestaurantLocationDisplayAddress *)value;
- (void)removeDisplayAddressObject:(RestaurantLocationDisplayAddress *)value;
- (void)addDisplayAddress:(NSSet *)values;
- (void)removeDisplayAddress:(NSSet *)values;

@end
