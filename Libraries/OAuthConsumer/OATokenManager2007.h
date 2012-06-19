//
//  OATokenManager2007.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 01/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

#import "OACall2007.h"

@class OATokenManager2007;

@protocol OATokenManagerDelegate2007

- (BOOL)tokenManager:(OATokenManager2007 *)manager failedCall:(OACall2007 *)call withError:(NSError *)error;
- (BOOL)tokenManager:(OATokenManager2007 *)manager failedCall:(OACall2007 *)call withProblem:(OAProblem *)problem;

@optional

- (BOOL)tokenManagerNeedsToken:(OATokenManager2007 *)manager;

@end

@class OAConsumer;
@class OAToken2007;

@interface OATokenManager2007 : NSObject<OACallDelegate2007> {
	OAConsumer *consumer;
	OAToken2007 *acToken;
	OAToken2007 *reqToken;
	OAToken2007 *initialToken;
	NSString *authorizedTokenKey;
	NSString *oauthBase;
	NSString *realm;
	NSString *callback;
	NSObject <OATokenManagerDelegate2007> *delegate;
	NSMutableArray *calls;
	NSMutableArray *selectors;
	NSMutableDictionary *delegates;
	BOOL isDispatching;
}


- (id)init;

- (id)initWithConsumer:(OAConsumer *)aConsumer token:(OAToken2007 *)aToken oauthBase:(const NSString *)base
				 realm:(const NSString *)aRealm callback:(const NSString *)aCallback
			  delegate:(NSObject <OATokenManagerDelegate2007> *)aDelegate;

- (void)authorizedToken:(const NSString *)key;

- (void)fetchData:(NSString *)aURL finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
		 finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish delegate:(NSObject*)aDelegate;

- (void)call:(OACall2007 *)call failedWithError:(NSError *)error;
- (void)call:(OACall2007 *)call failedWithProblem:(OAProblem *)problem;

@end
