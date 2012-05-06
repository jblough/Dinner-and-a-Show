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
#import "NSDictionary+Json.h"
#import "RecipeDirection.h"

#define kKindTag @"kind"
#define kUrlTag @"url"
#define kNameTag @"name"
#define kIdentifierTag @"id"
#define kImageUrlTag @"image"
#define kThumbnailUrlTag @"thumb"
#define kCuisineTag @"cuisine"
#define kCookingMethodTag @"cooking_method"
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
    
    //[recipe = [json objectForKeyFromJson:kKindTag] forKey:@"kind"];
    recipe.kind = [json objectForKeyFromJson:kKindTag];
    recipe.url = [json objectForKeyFromJson:kUrlTag];
    recipe.name = [json objectForKeyFromJson:kNameTag];
    recipe.identifier = [json objectForKeyFromJson:kIdentifierTag];
    recipe.imageUrl = [json objectForKeyFromJson:kImageUrlTag];
    recipe.thumbnailUrl = [json objectForKeyFromJson:kThumbnailUrlTag];
    recipe.cuisine = [json objectForKeyFromJson:kCuisineTag];
    recipe.cookingMethod = nil;//[json objectForKeyFromJson:kCookingMethodTag];
    recipe.serves = [[json objectForKeyFromJson:kServesTag] intValue];
    recipe.yields = [json valueForKey:kYieldsTag];
    recipe.cost = [[json objectForKeyFromJson:kCostTag] doubleValue];
    
    NSArray * jsonIngredients = [json objectForKeyFromJson:kIngredientsTag];
    [jsonIngredients enumerateObjectsUsingBlock:^(id jsonIngredient, NSUInteger idx, BOOL *stop) {
        if ([jsonIngredient isKindOfClass:[NSDictionary class]]) {
            RecipeIngredient *ingredient = [RecipeIngredient recipeIngredientFromJson:jsonIngredient];
            //NSLog(@"Adding ingredient %@", ingredient.identifier);
            [recipe addIngredientObject:ingredient];
        }
    }];
    
    NSArray *jsonDirections = [json objectForKeyFromJson:kDirectionsTag];
    [jsonDirections enumerateObjectsUsingBlock:^(NSString *instruction, NSUInteger idx, BOOL *stop) {
        RecipeDirection *direction = [[RecipeDirection alloc] init];
        direction.instruction = instruction;
        direction.stepNumber = [NSNumber numberWithInt:idx];
        [recipe addDirectionObject:direction];
    }];

    NSDictionary *nutritionalInfoJson = [json objectForKeyFromJson:kNutritionalInformationTag];
    if (nutritionalInfoJson) {
        NutritionalInfo *nutritionalInfo = [NutritionalInfo nutritionalInfoFromJson:nutritionalInfoJson];
        recipe.nutritionalInfo = nutritionalInfo;
    }
    
    return recipe;
}

@end
