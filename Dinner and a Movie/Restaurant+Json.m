//
//  Restaurant+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kIdentifierTag @"id"
#define kNameTag @"name"
#define kPhoneTag @"display_phone"
#define kUrlTag @"url"
#define kImageUrlTag @"image_url"
#define kMobileUrlTag @"mobile_url"
#define kRatingImageUrlTag @"rating_img_url"
#define kRatingTag @"rating"
#define kLocationTag @"location"

#import "Restaurant+Json.h"
#import "RestaurantLocation+Json.h"

@implementation Restaurant (Json)

+ (Restaurant *)restaurantFromJson:(NSDictionary *)json
{
    Restaurant *restaurant = [[Restaurant alloc] init];
    
    restaurant.identifier = [json objectForKey:kIdentifierTag];
    restaurant.name = [json objectForKey:kNameTag];
    restaurant.phone = [json objectForKey:kPhoneTag];
    restaurant.url = [json objectForKey:kUrlTag];
    restaurant.imageUrl = [json objectForKey:kImageUrlTag];
    restaurant.mobileUrl = [json objectForKey:kMobileUrlTag];
    restaurant.ratingUrl = [json objectForKey:kRatingImageUrlTag];
    restaurant.rating = [json objectForKey:kRatingTag];
    restaurant.location = [RestaurantLocation restaurantLocationFromJson:[json objectForKey:kLocationTag]];
    
    return restaurant;
}

@end
