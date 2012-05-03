//
//  NewYorkTimesEvent+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewYorkTimesEvent+Json.h"

#define kIdentifierTag @"event_id"
#define kNameTag @"event_name"
#define kEventUrlTag @"event_detail_url"
#define kTheaterUrlTag @"theater_url"
#define kDescriptionTag @"web_description"
#define kVenueTag @"venue_name"
#define kLatitudeTag @"geocode_latitude"
#define kLongitudeTag @"geocode_longitude"
#define kAddressTag @"street_address"
#define kCityTag @"city"
#define kStateTag @"state"
#define kZipCodeTag @"postal_code"
#define kPhoneNumberTag @"telephone"
#define kCategoryTag @"category"
#define kSubcategoryTag @"subcategory"
#define kFreeTag @"free" // true/false
#define kKidFriendlyTag @"kid_friendly" // true/false
#define kStartDateTag @"recurring_start_date" // Date format
#define kDaysTag @"recur_days" // Array of strings

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


@implementation NewYorkTimesEvent (Json)

+ (NewYorkTimesEvent *)eventFromJson:(NSDictionary *)json
{
    NewYorkTimesEvent *event = [[NewYorkTimesEvent alloc] init];
    
    event.identifier = [json objectForKey:kIdentifierTag];
    event.name = [json objectForKey:kNameTag];
    event.eventUrl = [json objectForKey:kEventUrlTag];
    event.theaterUrl = [json objectForKey:kTheaterUrlTag];
    event.description = [json objectForKey:kDescriptionTag];
    event.venue = [json objectForKey:kVenueTag];
    event.latitude = [[json valueForKey:kLatitudeTag] doubleValue];
    event.longitude = [[json valueForKey:kLongitudeTag] doubleValue];
    event.address = [json objectForKey:kAddressTag];
    event.city = [json objectForKey:kCityTag];
    event.state = [json objectForKey:kStateTag];
    event.zipCode = [json objectForKey:kZipCodeTag];
    event.phone = [json objectForKey:kPhoneNumberTag];
    event.category = [json objectForKey:kCategoryTag];
    event.subcategory = [json objectForKey:kSubcategoryTag];
    event.isFree = [[json valueForKey:kFreeTag] boolValue];
    event.isKidFriendly = [[json valueForKey:kKidFriendlyTag] boolValue];
    event.startDate = [json objectForKey:kStartDateTag];
    event.days = [json objectForKey:kDaysTag];
    
    return event;
}

@end
