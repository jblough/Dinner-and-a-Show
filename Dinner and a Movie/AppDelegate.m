//
//  AppDelegate.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <EventKit/EventKit.h>

#define k24HoursInSeconds (24 * 60 * 60)
@interface AppDelegate()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) EKEventStore *eventStore;

@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize zipCode = _zipCode;
@synthesize userSpecifiedCode = _userSpecifiedCode;
@synthesize locationManager = _locationManager;
@synthesize coordinate = _coordinate;
@synthesize eventLibrary = _eventLibrary;
@synthesize eventStore = _eventStore;

- (EKEventStore *)eventStore
{
    if (!_eventStore) _eventStore = [[EKEventStore alloc] init];
    return _eventStore;
}

- (ScheduledEventLibrary *)eventLibrary
{
    if (!_eventLibrary) _eventLibrary = [[ScheduledEventLibrary alloc] init];
    return _eventLibrary;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager startUpdatingLocation];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];

    self.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Coordinate: %.5f, %.5f", self.coordinate.latitude, self.coordinate.longitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark *placemark, NSUInteger idx, BOOL *stop) {
            self.zipCode = placemark.postalCode;
        }];
    }];
}

- (void)addToCalendar:(NSString *)name when:(NSDate *)when reminder:(BOOL)reminder minutesBefore:(int)minutesBefore followUp:(BOOL)followUp
{
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.calendar = [self.eventStore defaultCalendarForNewEvents];
    event.title = name;
    event.startDate = when;
    event.endDate = [event.startDate dateByAddingTimeInterval:60];
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:(minutesBefore * 60)]; // time offset in seconds
    [event addAlarm:alarm];
    NSError *error;
    BOOL saved = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (!saved) {
        NSLog(@"Error saving event.");
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }

    if (followUp) {
        EKEvent *followUpEvent = [EKEvent eventWithEventStore:self.eventStore];
        followUpEvent.calendar = [self.eventStore defaultCalendarForNewEvents];
        followUpEvent.title = name;
        followUpEvent.startDate = [when dateByAddingTimeInterval:k24HoursInSeconds];
        followUpEvent.endDate = [followUpEvent.startDate dateByAddingTimeInterval:60];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:followUpEvent.startDate];
        [followUpEvent addAlarm:alarm];
        saved = [self.eventStore saveEvent:followUpEvent span:EKSpanThisEvent commit:YES error:&error];
        if (!saved) {
            NSLog(@"Error saving event.");
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }
    }
}

- (void)addToCalendar:(NSString *)name when:(NSDate *)when reminder:(BOOL)reminder minutesBefore:(int)minutesBefore
{
    [self addToCalendar:name when:when reminder:reminder minutesBefore:minutesBefore followUp:NO];
}     

- (void)addToCalender:(NSString *)name when:(NSDate *)when
{
    [self addToCalendar:name when:when reminder:NO minutesBefore:0];
}

@end
