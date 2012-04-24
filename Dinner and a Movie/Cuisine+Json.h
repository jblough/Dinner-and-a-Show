//
//  Cuisine+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cuisine.h"

@interface Cuisine (Json)

+ (Cuisine *)cuisineFromJson:(NSDictionary *)json;

@end
