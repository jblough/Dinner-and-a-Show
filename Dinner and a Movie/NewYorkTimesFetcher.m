//
//  NewYorkTimesFetcher.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesFetcher.h"
#import "ApiKeys.h"
#import "NewYorkTimesEvent+Json.h"

#define kBaseUrl @"http://api.nytimes.com/svc/events/v2/listings?"
#define kResultsPageSize 50

@implementation NewYorkTimesFetcher

+ (void)retrieve:(NSString *)url onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    dispatch_queue_t queue= dispatch_queue_create("com.josephblough.dinner.nyt.event.fetcher", nil);
    
    dispatch_async(queue, ^{
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData 
                                                                           options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves 
                                                                             error:&error] : nil;
        if (error) {
            NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            onError(error);   
        }
        else {
            onCompletion(results);
        }
    });
    dispatch_release(queue);
}

+ (void)events:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    NSString *url = [NSString stringWithFormat:@"%@limit=%d&api-key=%@", 
                     kBaseUrl, kResultsPageSize, kTimesEventsApiKey];
    
    [NewYorkTimesFetcher retrieve:url onCompletion:^(id data) {
        NSMutableArray *events = [NSMutableArray array];
        
        NSArray *jsonEvents = [data objectForKey:@"results"];
        [jsonEvents enumerateObjectsUsingBlock:^(id jsonEvent, NSUInteger idx, BOOL *stop) {
            [events addObject:[NewYorkTimesEvent eventFromJson:jsonEvent]];
        }];
        
        onCompletion([events copy]);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

@end
