//
//  OACall2007.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 04/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OAConsumer2007.h"
#import "OAToken2007.h"
#import "OAProblem2007.h"
#import "OADataFetcher2007.h"
#import "OAServiceTicket2007.h"
#import "OAMutableURLRequest2007.h"
#import "OACall2007.h"

@interface OACall2007 (Private)

- (void)callFinished:(OAServiceTicket2007 *)ticket withData:(NSData *)data;
- (void)callFailed:(OAServiceTicket2007 *)ticket withError:(NSError *)error;

@end

@implementation OACall2007

@synthesize url, method, parameters, files, ticket;

- (id)init {
	return [self initWithURL:nil
					  method:nil
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL {
	return [self initWithURL:aURL
					  method:nil
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod {
	return [self initWithURL:aURL
					  method:aMethod
				  parameters:nil
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters {
	return [self initWithURL:aURL
					  method:nil
				  parameters:theParameters];
}

- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters {
	return [self initWithURL:aURL
					  method:aMethod
				  parameters:theParameters
					   files:nil];
}

- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters files:(NSDictionary*)theFiles {
	return [self initWithURL:aURL
					  method:@"POST"
				  parameters:theParameters
					   files:theFiles];
}

- (id)initWithURL:(NSURL *)aURL
		   method:(NSString *)aMethod
	   parameters:(NSArray *)theParameters
			files:(NSDictionary*)theFiles {
	url = [aURL retain];
	method = [aMethod retain];
	parameters = [theParameters retain];
	files = [theFiles retain];
	fetcher = nil;
	request = nil;
	
	return self;
}

- (void)dealloc {
	[url release];
	[method release];
	[parameters release];
	[files release];
	[fetcher release];
	[request release];
	[ticket release];
	[super dealloc];
}

- (void)callFailed:(OAServiceTicket2007 *)aTicket withError:(NSError *)error {
	NSLog(@"error body: %@", aTicket.body);
	self.ticket = aTicket;
	[aTicket release];
	OAProblem2007 *problem = [OAProblem2007 problemWithResponseBody:ticket.body];
	if (problem) {
		[delegate call:self failedWithProblem:problem];
	} else {
		[delegate call:self failedWithError:error];
	}
}

- (void)callFinished:(OAServiceTicket2007 *)aTicket withData:(NSData *)data {
	self.ticket = aTicket;
	[aTicket release];
	if (ticket.didSucceed) {
//		NSLog(@"Call body: %@", ticket.body);
		[delegate performSelector:finishedSelector withObject:self withObject:ticket.body];
	} else {
//		NSLog(@"Failed call body: %@", ticket.body);
		[self callFailed:[ticket retain] withError:nil];
	}
}

- (void)perform:(OAConsumer2007 *)consumer
		  token:(OAToken2007 *)token
		  realm:(NSString *)realm
	   delegate:(NSObject <OACallDelegate2007> *)aDelegate
	didFinish:(SEL)finished

{
	delegate = aDelegate;
	finishedSelector = finished;

	request = [[OAMutableURLRequest2007 alloc] initWithURL:url
											  consumer:consumer
												token:token
												 realm:realm
									 signatureProvider:nil];
	if(method) {
		[request setHTTPMethod:method];
	}

	if (self.parameters) {
		[request setParameters:self.parameters];
	}
	if (self.files) {
		for (NSString *key in self.files) {
			[request attachFileWithName:@"file" filename:NSLocalizedString(@"Photo.jpg", @"") data:[self.files objectForKey:key]];
		}
	}
	fetcher = [[OADataFetcher2007 alloc] init];
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(callFinished:withData:)
				  didFailSelector:@selector(callFailed:withError:)];
}

/*- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[self class]]) {
		return [self isEqualToCall:(OACall2007 *)object];
	}
	return NO;
}

- (BOOL)isEqualToCall:(OACall2007 *)aCall {
	return (delegate == aCall->delegate
			&& finishedSelector == aCall->finishedSelector 
			&& [url isEqualTo:aCall.url]
			&& [method isEqualToString:aCall.method]
			&& [parameters isEqualToArray:aCall.parameters]
			&& [files isEqualToDictionary:aCall.files]);
}*/

@end
