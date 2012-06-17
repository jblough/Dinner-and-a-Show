//
//  TumblrFetcher.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TumblrFetcher : NSObject

+ (void)post:(NSString *)title text:(NSString *)text;

@end
