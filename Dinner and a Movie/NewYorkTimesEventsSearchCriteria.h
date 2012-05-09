//
//  NewYorkTimesEventsSearchCriteria.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewYorkTimesEventsSearchCriteria : NSObject

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSString *category;
@property BOOL isKidFriendly;
@property BOOL isFree;
@property BOOL onlyPreviewsAndOpenings;
@end
