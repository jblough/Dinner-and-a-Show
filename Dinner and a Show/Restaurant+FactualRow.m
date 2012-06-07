//
//  Restaurant+FactualRow.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Restaurant+FactualRow.h"

#define kIdentifierTag @"factual_id"
#define kNameTag @"name"
#define kPhoneTag @"tel"
#define kUrlTag @"website"
#define kRatingImageUrlTag @"rating_img_url"
#define kRatingLargeImageUrlTag @"rating_img_url_large"
#define kReviewCountTag @"review_count"
#define kPriceTag @"price"
#define kRatingTag @"rating"
#define kAddressTag @"address"
#define kCityTag @"locality"
#define kStateTag @"region"
#define kZipCodeTag @"postcode"
#define kLatitudeTag @"latitude"
#define kLongitudeTag @"longitude"

@implementation Restaurant (FactualRow)

+ (Restaurant *)restaurantFromRow:(FactualRow *)row
{
    Restaurant *restaurant = [[Restaurant alloc] init];
    
    restaurant.name = [row valueForName:kNameTag];
    restaurant.identifier = [row valueForName:kIdentifierTag];
    restaurant.url = [row valueForName:kUrlTag];
    restaurant.phone = [row valueForName:kPhoneTag];
    restaurant.rating = [[row valueForName:kRatingTag] doubleValue];

    if ([row valueForName:kPriceTag])
        restaurant.price = [NSNumber numberWithInt:[[row valueForName:kPriceTag] intValue]];
    
    RestaurantLocation *location = [[RestaurantLocation alloc] init];
    location.displayAddress = [NSArray arrayWithObject:[row valueForName:kAddressTag]];
    location.city = [row valueForName:kCityTag];
    location.state = [row valueForName:kStateTag];
    location.postalCode = [row valueForName:kZipCodeTag];

    location.latitude = [[row valueForName:kLatitudeTag] doubleValue];
    location.longitude = [[row valueForName:kLongitudeTag] doubleValue];
    
    restaurant.location = location;
    
    return restaurant;
}

@end
