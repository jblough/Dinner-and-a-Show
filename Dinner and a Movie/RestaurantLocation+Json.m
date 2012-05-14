//
//  RestaurantLocation+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kAddressTag @"address"
#define kCityTag @"city"
#define kStateTag @"state_code"
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
    location.state = [json objectForKey:kStateTag]; 
    location.postalCode = [json objectForKey:kZipCodeTag]; 
    location.country = [json objectForKey:kCountryTag]; 
    location.displayAddress = [json objectForKey:kDisplayAddressTag]; 
    
    NSDictionary *coordinates = [json objectForKey:kCoordinateTag];
    if (coordinates) {
        location.latitude = [[coordinates valueForKey:kLatitudeTag] doubleValue]; 
        location.longitude = [[coordinates valueForKey:kLongitudeTag] doubleValue]; 
    }
 
    return location;
}

@end
