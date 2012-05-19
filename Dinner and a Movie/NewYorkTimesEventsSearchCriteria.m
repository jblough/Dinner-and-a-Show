//
//  NewYorkTimesEventsSearchCriteria.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEventsSearchCriteria.h"

@implementation NewYorkTimesEventsSearchCriteria

@synthesize filterCategories = _filterCategories;

- (NSSet *)filterCategories
{
    if (!_filterCategories) _filterCategories = [NSMutableSet set];
    return _filterCategories;
}

- (void)addFilterCategory:(NSString *)category {
    [(NSMutableSet *)self.filterCategories addObject:category];
}

- (void)removeFilterCategory:(NSString *)category
{
    [(NSMutableSet *)self.filterCategories removeObject:category];
}

- (void)resetFilterCategories
{
    [(NSMutableSet *)self.filterCategories removeAllObjects];

}

@end
