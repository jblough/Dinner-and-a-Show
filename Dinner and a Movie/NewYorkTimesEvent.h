//
//  NewYorkTimesEvent.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewYorkTimesEvent : NSObject

/*
 "event_id":132,
 "event_schedule_id":397,
 "last_modified":"2011-08-18T19:20:52.229Z",
 "event_name":"\u2018One Night With Fanny Brice\u2019",
 "event_detail_url":"http:\/\/nytimes.com\/events\/theater\/off-broadway\/one-night-with-fanny-brice-132.html",
 "web_description":"<p>Kimberly Faye Greenberg gets the vivacity and vocal range of Brice in this one-woman show &#8212; and a lot more of the facts than &#8220;Funny Girl&#8221; does. But with the exception of a wrenching &#8220;My Man,&#8221; Brice&#8217;s signature song, she creates a flinty survivor and largely ducks the pain Brice must have experienced in her fraught relationship with the career criminal Nicky Arnstein (2:00).<\/p>",
 "venue_name":"St. Luke's Theater",
 "geocode_latitude":"40.759789",
 "geocode_longitude":"-73.98824200000001",
 "borough":"Manhattan",
 "neighborhood":"Clinton",
 "street_address":"308 West 46th Street",
 "cross_street":"near Eighth Avenue",
 "city":"New York",
 "state":"NY",
 "postal_code":"10036",
 "telephone":"(212) 239-6200",
 "venue_website":"telecharge.com",
 "critic_name":"Andy Webster",
 "category":"Theater",
 "subcategory":"Off Broadway",
 "times_pick":false,
 "free":false,
 "kid_friendly":false,
 "last_chance":true,
 "festival":false,
 "long_running_show":false,
 "previews_and_openings":false,
 "date_time_description":"continuing",
 "recurring_start_date":"2011-04-11T04:00:00.1Z",
 "recur_days":["wed","sat","sun"]
 */

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventUrl;
@property (nonatomic, strong) NSString *theaterUrl;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *venue;
@property double latitude;
@property double longitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subcategory;
@property BOOL isFree;
@property BOOL isKidFriendly;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSArray *days;

@end
