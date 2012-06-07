//
//  RecipeIngredient+Json.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeIngredient.h"

@interface RecipeIngredient (Json)

+ (RecipeIngredient *)recipeIngredientFromJson:(NSDictionary *)json;

@end
