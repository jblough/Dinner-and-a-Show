//
//  Cuisine+Json.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cuisine+Json.h"

#define kIdentifierTag @"id"
#define kNameTag @"name"
#define kUrlTag @"url"
#define kRecipeCountTag @"recipe_count"

@implementation Cuisine (Json)

+ (Cuisine *)cuisineFromJson:(NSDictionary *)json
{
    Cuisine *cuisine = [[Cuisine alloc] init];
    cuisine.identifier = [json objectForKey:kIdentifierTag];
    cuisine.name = [json objectForKey:kNameTag];
    cuisine.url = [json objectForKey:kUrlTag];
    cuisine.recipeCount = [[json valueForKey:kRecipeCountTag] intValue];
    return cuisine;
}

@end
