//
//  RecipeDirection.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeDirection : NSManagedObject

@property (nonatomic, retain) NSNumber * stepNumber;
@property (nonatomic, retain) NSString * instruction;
@property (nonatomic, retain) NSSet *recipe;
@end

@interface RecipeDirection (CoreDataGeneratedAccessors)

- (void)addRecipeObject:(Recipe *)value;
- (void)removeRecipeObject:(Recipe *)value;
- (void)addRecipe:(NSSet *)values;
- (void)removeRecipe:(NSSet *)values;

@end
