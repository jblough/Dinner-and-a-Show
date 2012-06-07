//
//  PatchEvent+Json.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatchEvent.h"

#define kIdentifierTag @"uuid"
#define kTitleTag @"title"
#define kSummaryTag @"summary"
#define kUrlTag @"story_url"

@implementation PatchEvent (Json)

+ (PatchEvent *)eventFromJson:(NSDictionary *)json
{
    PatchEvent *event = [[PatchEvent alloc] init];
    event.identifier = [json objectForKey:kIdentifierTag];
    event.title = [json objectForKey:kTitleTag];
    event.summary = [json objectForKey:kSummaryTag];
    event.url = [json objectForKey:kUrlTag];
    return event;
}

@end
