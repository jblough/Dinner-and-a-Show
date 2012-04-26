//
//  Recipe+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recipe+Json.h"
#import "RecipeIngredient+Json.h"
#import "NutritionalInfo+Json.h"

#define kKindTag @"kind"
#define kUrlTag @"url"
#define kNameTag @"name"
#define kIdentifierTag @"id"
#define kImageUrlTag @"image"
#define kThumbnailUrlTag @"thumb"
#define kCuisineTag @"cuisine"
#define kCookingMethogTag @"cooking_method"
#define kServesTag @"serves"
#define kYieldsTag @"yields"
#define kCostTag @"cost"
#define kIngredientsTag @"ingredients"
#define kDirectionsTag @"directions"
#define kNutritionalInformationTag @"nutritional_info"


@implementation Recipe (Json)

+ (Recipe *)recipeFromJson:(NSDictionary *)json
{
    Recipe *recipe = [[Recipe alloc] init];
    
    recipe.kind = [json objectForKey:kKindTag];
    recipe.url = [json objectForKey:kUrlTag];
    recipe.name = [json objectForKey:kNameTag];
    recipe.identifier = [json objectForKey:kIdentifierTag];
    recipe.imageUrl = [json objectForKey:kImageUrlTag];
    recipe.thumbnameUrl = [json objectForKey:kThumbnailUrlTag];
    recipe.cuisine = [json objectForKey:kCuisineTag];
    recipe.cookingMethod = [json objectForKey:kCookingMethogTag];
    recipe.serves = [[json valueForKey:kServesTag] intValue];
    recipe.yields = [json valueForKey:kYieldsTag];
    recipe.cost = [[json valueForKey:kCostTag] floatValue];
    
    NSArray * jsonIngredients = [json objectForKey:kIngredientsTag];
    recipe.ingredients = [NSMutableArray arrayWithCapacity:[jsonIngredients count]];
    /*for (NSDictionary *jsonIngredient in jsonIngredients) {
        if ([jsonIngredient isKindOfClass:[NSDictionary class]]) {
            [(NSMutableArray *)recipe.ingredients addObject:[RecipeIngredient recipeIngredientFromJson:jsonIngredient]];
        }
    }*/
    [jsonIngredients enumerateObjectsUsingBlock:^(id jsonIngredient, NSUInteger idx, BOOL *stop) {
        if ([jsonIngredient isKindOfClass:[NSDictionary class]]) {
            [(NSMutableArray *)recipe.ingredients addObject:[RecipeIngredient recipeIngredientFromJson:jsonIngredient]];
        }
    }];
    
    recipe.directions = [json objectForKey:kDirectionsTag];
    recipe.nutritionalInfo = [NutritionalInfo nutritionalInfoFromJson:[json objectForKey:kNutritionalInformationTag]];
    
    return recipe;
}

@end
