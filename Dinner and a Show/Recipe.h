//
//  Recipe.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NutritionalInfo.h"
#import "RecipeDirection.h"
#import "RecipeIngredient.h"

@interface Recipe : NSObject

@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *cuisine;
@property (nonatomic, strong) NSString *cookingMethod;
@property int serves;
@property (nonatomic, strong) NSString *yields;
@property double cost;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NutritionalInfo *nutritionalInfo;

- (void)addDirectionObject:(RecipeDirection *)direction;
- (void)addIngredientObject:(RecipeIngredient *)ingredient;

@end
