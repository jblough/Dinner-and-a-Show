//
//  MD5.h
//  stories
//
//  Created by Brian Moseley on 11/19/10.
//  Copyright 2010 Outside.in. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>


@interface MD5 : NSObject {

}

+ (NSString *) md5hex:(NSString*)concat;

@end
