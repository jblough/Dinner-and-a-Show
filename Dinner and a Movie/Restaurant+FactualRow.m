//
//  Restaurant+FactualRow.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Restaurant+FactualRow.h"

@implementation Restaurant (FactualRow)

+ (Restaurant *)restaurantFromRow:(FactualRow *)row
{
    Restaurant *restaurant = [[Restaurant alloc] init];
    
    restaurant.name = [row valueForName:@"name"];
    restaurant.identifier = [row valueForName:@"factual_id"];
    restaurant.url = [row valueForName:@"website"];
    restaurant.phone = [row valueForName:@"tel"];
    restaurant.rating = [[row valueForName:@"rating"] doubleValue];
    
    RestaurantLocation *location = [[RestaurantLocation alloc] init];
    location.displayAddress = [NSArray arrayWithObject:[row valueForName:@"address"]];
    location.city = [row valueForName:@"locality"];
    location.state = [row valueForName:@"region"];
    location.postalCode = [row valueForName:@"postcode"];

    location.latitude = [[row valueForName:@"latitude"] doubleValue];
    location.longitude = [[row valueForName:@"longitude"] doubleValue];
    
    restaurant.location = location;
    
    return restaurant;
}

@end
