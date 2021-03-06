//
//  NewYorkTimesFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesFetcher.h"
#import "ApiKeys.h"
#import "NewYorkTimesEvent+Json.h"

#define kBaseUrl @"http://api.nytimes.com/svc/events/v2/listings?"

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
    NSString *url = [NSString stringWithFormat:@"%@limit=%d&api-key=%@&sort=%@", 
                     kBaseUrl, kNewYorkTimesEventsPageSize, kTimesEventsApiKey, @"last_modified+desc"];
    
    NSLog(@"NYT URL: %@", url);

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

+ (void)events:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSString *url = [NSString stringWithFormat:@"%@limit=%d&offset=%d&api-key=%@&sort=%@", 
                     kBaseUrl, kNewYorkTimesEventsPageSize, (kNewYorkTimesEventsPageSize * page), kTimesEventsApiKey, @"last_modified+desc"];
    
    NSLog(@"NYT URL: %@", url);
    
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

+ (void)events:(NewYorkTimesEventsSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    __block NSString *filter = @"&filters=category:";
    if (!criteria.filterCategories || [criteria.filterCategories count] == 0) {
        filter = nil;
    }
    else if ([criteria.filterCategories count] == 1) {
        filter = [filter stringByAppendingString:[criteria.filterCategories anyObject]];
    }
    else {
        [[criteria.filterCategories allObjects] enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                filter = [filter stringByAppendingFormat:@"(%@", category];
            }
            else {
                filter = [filter stringByAppendingFormat:@" %@", category];
            }
        }];
        filter = [filter stringByAppendingString:@")"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@limit=%d&offset=%d&api-key=%@&sort=%@", 
                     kBaseUrl, kNewYorkTimesEventsPageSize, (kNewYorkTimesEventsPageSize * page), kTimesEventsApiKey, @"last_modified+desc"];
    
    if (filter) {
        url = [url stringByAppendingString:filter];
    }
    
    NSLog(@"NYT URL: %@", url);
    
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
