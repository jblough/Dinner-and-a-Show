//
//  Restaurant+Json.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant (Json)

+ (Restaurant *)restaurantFromJson:(NSDictionary *)json;

@end
