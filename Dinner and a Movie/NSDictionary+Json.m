//
//  NSDictionary+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (id)objectForKeyFromJson:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (!value || [value class] == [NSNull class]) {
        return nil;
    }
    return value;
}

@end
