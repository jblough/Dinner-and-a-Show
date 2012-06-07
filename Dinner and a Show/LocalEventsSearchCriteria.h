//
//  LocalEventsSearchCriteria.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalEventsSearchCriteria : NSObject

@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *searchTerm;

@end
