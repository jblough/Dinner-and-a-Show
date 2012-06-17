//
//  OACall.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 04/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

@class OAProblem;
@class OACall;

@protocol OACallDelegate

- (void)call:(OACall *)call failedWithError:(NSError *)error;
- (void)call:(OACall *)call failedWithProblem:(OAProblem *)problem;

@end

@class OAConsumer;
@class OAToken;
@class OADataFetcher2007;
@class OAMutableURLRequest;
@class OAServiceTicket2007;

@interface OACall : NSObject {
	NSURL *url;
	NSString *method;
	NSArray *parameters;
	NSDictionary *files;
	NSObject <OACallDelegate> *delegate;
	SEL finishedSelector;
	OADataFetcher2007 *fetcher;
	OAMutableURLRequest *request;
	OAServiceTicket2007 *ticket;
}

@property(readonly) NSURL *url;
@property(readonly) NSString *method;
@property(readonly) NSArray *parameters;
@property(readonly) NSDictionary *files;
@property(nonatomic, retain) OAServiceTicket2007 *ticket;

- (id)init;
- (id)initWithURL:(NSURL *)aURL;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters files:(NSDictionary*)theFiles;

- (id)initWithURL:(NSURL *)aURL
		   method:(NSString *)aMethod
	   parameters:(NSArray *)theParameters
			files:(NSDictionary*)theFiles;

- (void)perform:(OAConsumer *)consumer
		  token:(OAToken *)token
		  realm:(NSString *)realm
	   delegate:(NSObject <OACallDelegate> *)aDelegate
	  didFinish:(SEL)finished;

@end
