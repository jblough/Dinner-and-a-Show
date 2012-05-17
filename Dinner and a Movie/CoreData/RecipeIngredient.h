//
//  RecipeIngredient.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeIngredient : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * preparation;
@property (nonatomic, retain) Recipe *recipe;

@end
