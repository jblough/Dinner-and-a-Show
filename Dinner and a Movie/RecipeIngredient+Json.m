//
//  RecipeIngredient+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeIngredient+Json.h"

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
    
    ingredient.identifier = [json objectForKey:kIdentifierTag];
    ingredient.name = [json objectForKey:kNameTag];
    ingredient.url = [json objectForKey:kUrlTag];
    ingredient.quantity = [json objectForKey:kQuantityTag];
    ingredient.unit = [json objectForKey:kUnitTag];
    ingredient.preparation = [json objectForKey:kPreparationTag];
    
    return ingredient;
}

@end
