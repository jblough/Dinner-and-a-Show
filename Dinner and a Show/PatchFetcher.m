//
//  PatchFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatchFetcher.h"
#import "PatchEvent+Json.h"
#import "ApiKeys.h"
#import "MD5.h"
#import "AppDelegate.h"

#import "NSString+URLEncoding.h"

NSString * const BASE_URL = @"http://news-api.patch.com/v1.1";

@implementation PatchFetcher

// story fetching
+ (void)request:(NSString *)relativePath onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    dispatch_queue_t queue= dispatch_queue_create("com.josephblough.dinner.patchfetcher", nil);
    
    dispatch_async(queue, ^{
        NSURL *url = [self sign:relativePath];
        NSLog(@"Requesting %@", url);

        NSData *jsonData = [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
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

+ (NSURL *)sign:(NSString *)relativePath {
    long time = (long)[[NSDate date] timeIntervalSince1970];
    NSString* sig = [MD5 md5hex:[NSString stringWithFormat:@"%@%@%d", kPatchKey, kPatchSecret, time]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&format=event-listings&dev_key=%@&sig=%@", BASE_URL, relativePath, kPatchKey, sig]];
}

+ (void)events:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    double latitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.latitude :
        appDelegate.coordinate.coordinate.latitude;
    double longitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.longitude :
        appDelegate.coordinate.coordinate.longitude;

    //[PatchFetcher request:[NSString stringWithFormat:@"/zipcodes/%@/stories?limit=%d", zipCode, kLocalEventPageSize] onCompletion:^(NSDictionary *data) {
    [PatchFetcher request:[NSString stringWithFormat:@"/nearby/%.6f,%.6f/stories?limit=%d", latitude, longitude, kLocalEventPageSize] onCompletion:^(NSDictionary *data) {
        NSMutableArray *events = [NSMutableArray array];
        
        NSArray *jsonEvents = [data objectForKey:@"stories"];
        [jsonEvents enumerateObjectsUsingBlock:^(NSDictionary *story, NSUInteger idx, BOOL *stop) {
            [events addObject:[PatchEvent eventFromJson:story]];
        }];
        onCompletion(events);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)events:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler)onError
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    double latitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.latitude :
        appDelegate.coordinate.coordinate.latitude;
    double longitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.longitude :
        appDelegate.coordinate.coordinate.longitude;
    
    //[PatchFetcher request:[NSString stringWithFormat:@"/zipcodes/%@/stories?limit=%d&page=%d", zipCode, kLocalEventPageSize, page+1] onCompletion:^(NSDictionary *data) {
    [PatchFetcher request:[NSString stringWithFormat:@"/nearby/%.6f,%.6f/stories?limit=%d&page=%d", latitude, longitude, kLocalEventPageSize, page+1] onCompletion:^(NSDictionary *data) {
        NSMutableArray *events = [NSMutableArray array];
        
        NSArray *jsonEvents = [data objectForKey:@"stories"];
        [jsonEvents enumerateObjectsUsingBlock:^(NSDictionary *story, NSUInteger idx, BOOL *stop) {
            [events addObject:[PatchEvent eventFromJson:story]];
        }];
        onCompletion(events);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)events:(LocalEventsSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    CLLocation *location = criteria.location;
    if (!location) {
        location = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate : appDelegate.coordinate;
    }
    
    // TODO get these from criteria
    double latitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.latitude :
    appDelegate.coordinate.coordinate.latitude;
    double longitude = (appDelegate.userSpecifiedCoordinate) ? appDelegate.userSpecifiedCoordinate.coordinate.longitude :
    appDelegate.coordinate.coordinate.longitude;

    //NSString *url = [NSString stringWithFormat:@"/zipcodes/%@/stories?limit=%d&page=%d", zipCode, kLocalEventPageSize, page+1];
    NSString *url = [NSString stringWithFormat:@"/nearby/%.6f,%.6f/stories?limit=%d&page=%d", latitude, longitude, kLocalEventPageSize, page+1];
    
    if (criteria.searchTerm && ![@"" isEqualToString:criteria.searchTerm]) {
        url = [url stringByAppendingFormat:@"&keyword=%@", 
               [criteria.searchTerm encodedURLParameterString]];
    }
    
    [PatchFetcher request:url onCompletion:^(NSDictionary *data) {
        NSMutableArray *events = [NSMutableArray array];
        
        NSArray *jsonEvents = [data objectForKey:@"stories"];
        [jsonEvents enumerateObjectsUsingBlock:^(NSDictionary *story, NSUInteger idx, BOOL *stop) {
            [events addObject:[PatchEvent eventFromJson:story]];
        }];
        onCompletion(events);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

@end
