//
//  RestaurantLocation+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kAddressTag @"address"
#define kCityTag @"city"
#define kStateTag @"state"
#define kZipCodeTag @"postal_code"
#define kCountryTag @"country_code"
#define kDisplayAddressTag @"display_address"
#define kCoordinateTag @"coordinate"
#define kLatitudeTag @"latitude"
#define kLongitudeTag @"longitude"


#import "RestaurantLocation+Json.h"

@implementation RestaurantLocation (Json)

+ (RestaurantLocation *)restaurantLocationFromJson:(NSDictionary *)json
{
    RestaurantLocation *location = [[RestaurantLocation alloc] init];

    location.address = [json objectForKey:kAddressTag];
    location.city = [json objectForKey:kCityTag]; 
    location.state = [json objectForKey:kCityTag]; 
    location.postalCode = [json objectForKey:kCityTag]; 
    location.country = [json objectForKey:kCityTag]; 
    location.displayAddress = [json objectForKey:kCityTag]; 
    
    NSDictionary *coordinates = [json objectForKey:kCoordinateTag];
    if (coordinates) {
        location.latitude = [[json objectForKey:kLatitudeTag] doubleValue]; 
        location.longitude = [[json objectForKey:kLongitudeTag] doubleValue]; 
    }
 
    return location;
}

@end