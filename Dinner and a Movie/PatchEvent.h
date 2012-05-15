//
//  PatchEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatchEvent : NSObject

/*
** total: Total number of stories in the location requested in the past 10 days. This number may be greater than the number of stories provided in the stories field, which indicates that there are more stories available for your query than are returned in the current results.
** stories: Up to 10 most recent stories in the location requested within the past 10 days. For each story we will provide:
 uuid: A universally unique ID for the story.
 **** title: Title of the story.
 **** summary: First 200 characters of the story.
 **** story_url: Permalink to the story on the website of the original source. The story_url is routed through an Outside.in/Patch redirect, which may not be stripped out.
 feed_title: The name of the feed from which the story was found.
 feed_url: The homepage for the original publisher of the story.
 tags:  All topic tags associated with the story.
 source_verticals: All verticals attached to the feed or feeds from which we found the story.
 source_author_types: All author types attached to the feed or feeds from which we found the story.
 source_formats: All formats attached to the feed or feeds from which we found the story.
 published_at: The timestamp at which the story was published in the source feed.
 
** location: All results to the Stories Query Resource except for Nearby Queries will include metadata about the location requested, including:
 uuid: A universally unique ID for the location.
 display_name: User-friendly name for the location.
 url_name: URL-friendly name for the location. 
 city: The name of the city that contains the location, if any.
 state: The name of the state that contains the location, if any.
 state_abbrev: The two-character postal abbreviation for the state that contains the location, if any.
 url: The Outside.in/Patch permalink for stories about the requested location. This is useful for linking your users to more results.
 category: Information about the type of location requested, including:
 display_name: User-friendly name for the type of location.
 name: URL-friendly name for the type of location.
 lat: The latitude of the centroid of the location.
 lng: The longitude of the centroid of the location.
 links: A list of links to queries that use the page parameter to retrieve other sets of results matching the query, if there are more results than 10 (or the number specified in the limit parameter). This list may include:
 first: The first set of results matching the query.
 last: The last set of results matching the query.
 next: The next set of results matching the query.
 previous: The previous set of results matching the query.

 */

/*
 summary is in the format : "Location: 1253 Woodward Ave, Detroit, MI 48226 When: May 12, 2012 Time: 10:00 am–2:00 pm Michigan—especially metro Detroit—loves its coney island hot dogs. We're as passionate about the secret sauces and the recipes as the people and places that serve them. Join Patch this spring and summer as"
        "Location: Katie's Food & Spirits 2830 Baker Rd, Dexter, MI When: May 4, 2012 / May 5, 2012 Time: 9:30 pm–1:30 am The band Matrix will perform at Katie's from 9:30 p.m. to 1:30 a.m. There is no charge for the event. Price: $0"
    "Location: X When: Y Z*"
 */

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *tags;

@end
