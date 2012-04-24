//
//  NutritionalInfo+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NutritionalInfo.h"

@interface NutritionalInfo (Json)

+ (NutritionalInfo *)nutritionalInfoFromJson:(NSDictionary *)json;

@end
