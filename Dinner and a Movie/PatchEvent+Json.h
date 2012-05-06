//
//  PatchEvent+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatchEvent.h"

@interface PatchEvent (Json)

+ (PatchEvent *)eventFromJson:(NSDictionary *)json;

@end
