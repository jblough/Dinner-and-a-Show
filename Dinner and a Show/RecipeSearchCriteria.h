//
//  RecipeSearchCriteria.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeSearchCriteria : NSObject

@property (nonatomic, strong) NSString *nameFilter;
@property (nonatomic, strong) NSString *ingredientFilter;
@property BOOL filterCuisine;

@end
