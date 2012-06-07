//
//  RestaurantSearchCriteria.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantSearchCriteria : NSObject

@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *searchTerm;
@property BOOL onlyIncludeDeals;
@property int radius;

@end
