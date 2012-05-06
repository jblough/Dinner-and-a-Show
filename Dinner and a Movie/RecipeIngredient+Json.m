//
//  RecipeIngredient+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeIngredient+Json.h"
#import "NSDictionary+Json.h"

#define kIdentifierTag @"id"
#define kNameTag @"name"
#define kUrlTag @"url"
#define kQuantityTag @"quantity"
#define kUnitTag @"unit"
#define kPreparationTag @"preparation"


@implementation RecipeIngredient (Json)

+ (RecipeIngredient *)recipeIngredientFromJson:(NSDictionary *)json
{
    RecipeIngredient *ingredient = [[RecipeIngredient alloc] init];
    
    ingredient.identifier = [json objectForKeyFromJson:kIdentifierTag];
    ingredient.name = [json objectForKeyFromJson:kNameTag];
    ingredient.url = [json objectForKeyFromJson:kUrlTag];
    ingredient.quantity = [json objectForKeyFromJson:kQuantityTag];
    ingredient.unit = [json objectForKeyFromJson:kUnitTag];
    ingredient.preparation = [json objectForKeyFromJson:kPreparationTag];
    
    return ingredient;
}

@end
