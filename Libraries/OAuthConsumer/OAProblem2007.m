//
//  OAProblem2007.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OAProblem2007.h"

const NSString *signature_method_rejected = @"signature_method_rejected";
const NSString *parameter_absent = @"parameter_absent";
const NSString *version_rejected = @"version_rejected";
const NSString *consumer_key_unknown = @"consumer_key_unknown";
const NSString *token_rejected = @"token_rejected";
const NSString *signature_invalid = @"signature_invalid";
const NSString *nonce_used = @"nonce_used";
const NSString *timestamp_refused = @"timestamp_refused";
const NSString *token_expired = @"token_expired";
const NSString *token_not_renewable = @"token_not_renewable";

@implementation OAProblem2007

@synthesize problem;

- (id)initWithPointer:(const NSString *) aPointer
{
	[super init];
	problem = aPointer;
	return self;
}

- (id)initWithProblem:(const NSString *) aProblem
{
	NSUInteger idx = [[OAProblem2007 validProblems] indexOfObject:aProblem];
	if (idx == NSNotFound) {
		return nil;
	}
	
	return [self initWithPointer: [[OAProblem2007 validProblems] objectAtIndex:idx]];
}
	
- (id)initWithResponseBody:(const NSString *) response
{
	NSArray *fields = [response componentsSeparatedByString:@"&"];
	for (NSString *field in fields) {
		if ([field hasPrefix:@"oauth_problem="]) {
			NSString *value = [[field componentsSeparatedByString:@"="] objectAtIndex:1];
			return [self initWithProblem:value];
		}
	}
	
	return nil;
}

+ (OAProblem2007 *)problemWithResponseBody:(const NSString *) response
{
	return [[[OAProblem2007 alloc] initWithResponseBody:response] autorelease];
}

+ (const NSArray *)validProblems
{
	static NSArray *array;
	if (!array) {
		array = [[NSArray alloc] initWithObjects:signature_method_rejected,
										parameter_absent,
										version_rejected,
										consumer_key_unknown,
										token_rejected,
										signature_invalid,
										nonce_used,
										timestamp_refused,
										token_expired,
										token_not_renewable,
										nil];
	}
	
	return array;
}

- (BOOL)isEqualToProblem:(OAProblem2007 *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem->problem];
}

- (BOOL)isEqualToString:(const NSString *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem];
}

- (BOOL)isEqualTo:(id) aProblem
{
	if ([aProblem isKindOfClass:[NSString class]]) {
		return [self isEqualToString:aProblem];
	}
		
	if ([aProblem isKindOfClass:[OAProblem2007 class]]) {
		return [self isEqualToProblem:aProblem];
	}
	
	return NO;
}

- (int)code {
	return [[[self class] validProblems] indexOfObject:problem];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"OAuth Problem: %@", (NSString *)problem];
}

#pragma mark class_methods

+ (OAProblem2007 *)SignatureMethodRejected
{
	return [[[OAProblem2007 alloc] initWithPointer:signature_method_rejected] autorelease];
}

+ (OAProblem2007 *)ParameterAbsent
{
	return [[[OAProblem2007 alloc] initWithPointer:parameter_absent] autorelease];
}

+ (OAProblem2007 *)VersionRejected
{
	return [[[OAProblem2007 alloc] initWithPointer:version_rejected] autorelease];
}

+ (OAProblem2007 *)ConsumerKeyUnknown
{
	return [[[OAProblem2007 alloc] initWithPointer:consumer_key_unknown] autorelease];
}

+ (OAProblem2007 *)TokenRejected
{
	return [[[OAProblem2007 alloc] initWithPointer:token_rejected] autorelease];
}

+ (OAProblem2007 *)SignatureInvalid
{
	return [[[OAProblem2007 alloc] initWithPointer:signature_invalid] autorelease];
}

+ (OAProblem2007 *)NonceUsed
{
	return [[[OAProblem2007 alloc] initWithPointer:nonce_used] autorelease];
}

+ (OAProblem2007 *)TimestampRefused
{
	return [[[OAProblem2007 alloc] initWithPointer:timestamp_refused] autorelease];
}

+ (OAProblem2007 *)TokenExpired
{
	return [[[OAProblem2007 alloc] initWithPointer:token_expired] autorelease];
}

+ (OAProblem2007 *)TokenNotRenewable
{
	return [[[OAProblem2007 alloc] initWithPointer:token_not_renewable] autorelease];
}
					  
@end
