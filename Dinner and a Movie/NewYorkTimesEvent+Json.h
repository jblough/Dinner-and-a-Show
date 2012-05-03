//
//  NewYorkTimesEvent+Json.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEvent.h"

@interface NewYorkTimesEvent (Json)

+ (NewYorkTimesEvent *)eventFromJson:(NSDictionary *)json;

@end
