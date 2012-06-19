//
//  OAProblem2007.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

enum {
	kOAProblemSignatureMethodRejected = 0,
	kOAProblemParameterAbsent,
	kOAProblemVersionRejected,
	kOAProblemConsumerKeyUnknown,
	kOAProblemTokenRejected,
	kOAProblemSignatureInvalid,
	kOAProblemNonceUsed,
	kOAProblemTimestampRefused,
	kOAProblemTokenExpired,
	kOAProblemTokenNotRenewable
};

@interface OAProblem2007 : NSObject {
	const NSString *problem;
}

@property (readonly) const NSString *problem;

- (id)initWithProblem:(const NSString *)aProblem;
- (id)initWithResponseBody:(const NSString *)response;

- (BOOL)isEqualToProblem:(OAProblem2007 *)aProblem;
- (BOOL)isEqualToString:(const NSString *)aProblem;
- (BOOL)isEqualTo:(id)aProblem;
- (int)code;

+ (OAProblem2007 *)problemWithResponseBody:(const NSString *)response;

+ (const NSArray *)validProblems;

+ (OAProblem2007 *)SignatureMethodRejected;
+ (OAProblem2007 *)ParameterAbsent;
+ (OAProblem2007 *)VersionRejected;
+ (OAProblem2007 *)ConsumerKeyUnknown;
+ (OAProblem2007 *)TokenRejected;
+ (OAProblem2007 *)SignatureInvalid;
+ (OAProblem2007 *)NonceUsed;
+ (OAProblem2007 *)TimestampRefused;
+ (OAProblem2007 *)TokenExpired;
+ (OAProblem2007 *)TokenNotRenewable;

@end
