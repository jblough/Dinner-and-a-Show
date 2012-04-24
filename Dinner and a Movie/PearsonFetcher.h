//
//  PearsonFetcher.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cuisine.h"

@interface PearsonFetcher : NSObject

+ (NSArray *)cuisines;
+ (NSArray *)recipesForCuisine:(Cuisine *)cuisine;

@end
