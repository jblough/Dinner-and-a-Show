//
//  Restaurant+FactualRow.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Restaurant.h"
#import <FactualSDK/FactualAPI.h>

@interface Restaurant (FactualRow)

+ (Restaurant *)restaurantFromRow:(FactualRow *)row;

@end
