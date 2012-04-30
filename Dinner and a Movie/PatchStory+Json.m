//
//  PatchStory+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatchStory+Json.h"

#define kIdentifierTag @"uuid"
#define kTitleTag @"title"
#define kSummaryTag @"summary"
#define kUrlTag @"story_url"

@implementation PatchStory (Json)

+ (PatchStory *)storyFromJson:(NSDictionary *)json
{
    PatchStory *story = [[PatchStory alloc] init];
    story.identifier = [json objectForKey:kIdentifierTag];
    story.title = [json objectForKey:kTitleTag];
    story.summary = [json objectForKey:kSummaryTag];
    story.url = [json objectForKey:kUrlTag];
    return story;
}

@end
