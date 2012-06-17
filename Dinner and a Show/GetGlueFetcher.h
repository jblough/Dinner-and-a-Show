//
//  GetGlueFetcher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetGlueFetcher : NSObject

+ (void)checkin:(NSString *)title text:(NSString *)text;
+ (void)review:(NSString *)title text:(NSString *)text;

@end
