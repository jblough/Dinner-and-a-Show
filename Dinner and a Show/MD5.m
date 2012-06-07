//
//  MD5.m
//  stories
//
//  Created by Brian Moseley on 11/19/10.
//  Copyright 2010 Outside.in. All rights reserved.
//

#import "MD5.h"


@implementation MD5
+ md5hex:(NSString *)concat {
	const char *concat_str = [concat UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i=0; i<16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
}

@end
