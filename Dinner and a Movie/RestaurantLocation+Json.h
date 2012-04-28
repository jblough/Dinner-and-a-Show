//
//  RestaurantLocation+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantLocation.h"

@interface RestaurantLocation (Json)

+ (RestaurantLocation *)restaurantLocationFromJson:(NSDictionary *)json;

@end
