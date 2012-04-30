//
//  PatchStory+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatchStory.h"

@interface PatchStory (Json)

+ (PatchStory *)storyFromJson:(NSDictionary *)json;

@end
