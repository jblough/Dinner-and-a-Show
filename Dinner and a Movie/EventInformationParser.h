//
//  EventInformationParser.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventInformationParser : NSObject

+ (NSDate *)findDate:(NSString *)fromText;
+ (NSDate *)convertDate:(NSString *)jsonDate;

@end
