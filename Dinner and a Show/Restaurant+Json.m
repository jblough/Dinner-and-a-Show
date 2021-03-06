//
//  Restaurant+Json.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Restaurant+Json.h"
#import "RestaurantLocation+Json.h"
#import "NSDictionary+Json.h"

#define kIdentifierTag @"id"
#define kNameTag @"name"
#define kPhoneTag @"display_phone"
#define kUrlTag @"url"
#define kImageUrlTag @"image_url"
#define kMobileUrlTag @"mobile_url"
#define kRatingImageUrlTag @"rating_img_url"
#define kRatingLargeImageUrlTag @"rating_img_url_large"
#define kReviewCountTag @"review_count"
#define kRatingTag @"rating"
#define kLocationTag @"location"

@implementation Restaurant (Json)

+ (Restaurant *)restaurantFromJson:(NSDictionary *)json
{
    Restaurant *restaurant = [[Restaurant alloc] init];
    
    restaurant.identifier = [json objectForKeyFromJson:kIdentifierTag];
    restaurant.name = [json objectForKeyFromJson:kNameTag];
    restaurant.phone = [json objectForKeyFromJson:kPhoneTag];
    restaurant.url = [json objectForKeyFromJson:kUrlTag];
    restaurant.imageUrl = [json objectForKeyFromJson:kImageUrlTag];
    restaurant.mobileUrl = [json objectForKeyFromJson:kMobileUrlTag];
    restaurant.ratingUrl = [json objectForKeyFromJson:kRatingImageUrlTag];
    restaurant.largeRatingUrl = [json objectForKey:kRatingLargeImageUrlTag];
    restaurant.reviewCount = [[json objectForKey:kReviewCountTag] intValue];
    restaurant.rating = [[json objectForKeyFromJson:kRatingTag] doubleValue];
    restaurant.location = [RestaurantLocation restaurantLocationFromJson:[json objectForKeyFromJson:kLocationTag]];
    
    return restaurant;
}

@end
