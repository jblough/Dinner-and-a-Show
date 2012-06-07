//
//  Recipe.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@synthesize kind = _kind;
@synthesize url = _url;
@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize imageUrl = _imageUrl;
@synthesize thumbnailUrl = _thumbnailUrl;
@synthesize cuisine = _cuisine;
@synthesize cookingMethod = _cookingMethod;
@synthesize serves = _serves;
@synthesize yields = _yields;
@synthesize cost = _cost;
@synthesize ingredients = _ingredients;
@synthesize directions = _directions;
@synthesize nutritionalInfo = _nutritionalInfo;

- (NSArray *)ingredients
{
    if (!_ingredients) _ingredients = [NSMutableArray array];
    return _ingredients;
}

- (NSArray *)directions
{
    if (!_directions) _directions = [NSMutableArray array];
    return _directions;
}

- (void)addDirectionObject:(RecipeDirection *)direction
{
    [(NSMutableArray *)self.directions addObject:direction];
}

- (void)addIngredientObject:(RecipeIngredient *)ingredient
{
    [(NSMutableArray *)self.ingredients addObject:ingredient];
}

@end
