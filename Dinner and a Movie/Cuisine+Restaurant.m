//
//  Cuisine+Restaurant.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cuisine+Restaurant.h"

@implementation Cuisine (Restaurant)

- (id)initWithName:(NSString *)name identifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.name = name;
        self.identifier = identifier;
    }
    return self;
}

@end
