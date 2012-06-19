//
//  AppDelegate.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MyAlertView.h"
#import "UIActionSheet+Blocks.h"
#import "ScheduledEventsViewController.h"
#import "ECSlidingViewController.h"
#import "ApiKeys.h"
#import "EventPublisher.h"

#import <EventKit/EventKit.h>

#define k24HoursInSeconds (24 * 60 * 60)
#define kCalendarPermissionKey @"PermissionToCalendar"

static PostFacebookLoginBlock _postFacebookLoginBlock;

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
@synthesize userSpecifiedCoordinate = _userSpecifiedCoordinate;
@synthesize eventLibrary = _eventLibrary;
@synthesize eventStore = _eventStore;
@synthesize facebook = _facebook;

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

- (void)initLocationManager
{
    // Override point for customization after application launch.
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        [self.locationManager startUpdatingLocation];
    }
}

- (id<ScheduledEventitem>)loadEventFromNotification:(UILocalNotification *)notification
{
    id<ScheduledEventitem> event = nil;
    
    NSString *type = [notification.userInfo objectForKey:@"type"];
    NSString *identifier = [notification.userInfo objectForKey:@"identifier"];
    NSString *when = [notification.userInfo objectForKey:@"when"];
    
    // Format the date for consistent retrieval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSDate *date = [dateFormatter dateFromString:when];
    
    if ([type hasPrefix:@"custom"]) {
        event = [self.eventLibrary loadCustomEvent:identifier on:date];
    }
    else if ([type hasPrefix:@"recipe"]) {
        event = [self.eventLibrary loadRecipeEvent:identifier when:date];
    }
    else if ([type hasPrefix:@"restaurant"]) {
        event = [self.eventLibrary loadRestaurantEvent:identifier when:date];
    }
    else if ([type hasPrefix:@"local"]) {
        event = [self.eventLibrary loadLocalEvent:identifier when:date];
    }
    else if ([type hasPrefix:@"nytimes"]) {
        event = [self.eventLibrary loadNewYorkTimesEvent:identifier when:date];
    }
    
    return event;
}

- (void)handleCheckin:(UILocalNotification *)notification
{
    /*[MyAlertView showAlertViewWithTitle:[notification.userInfo objectForKey:@"name"]
                                message:[NSString stringWithFormat:@"Checkin for %@", [notification.userInfo objectForKey:@"name"]]
                      cancelButtonTitle:@"NO" 
                      otherButtonTitles:[NSArray arrayWithObject:@"YES"] 
                              onDismiss:^() {
                                  [self checkin];
                              } 
                               onCancel:^{
                               }];*/

    id<ScheduledEventitem> event = [self loadEventFromNotification:notification];
    if (event) {
        [UIActionSheet showActionSheetWithTitle:[NSString stringWithFormat:@"Checkin for %@?", [notification.userInfo objectForKey:@"name"]]
                              cancelButtonTitle:@"Cancel" 
                         destructiveButtonTitle:nil 
                              otherButtonTitles:[NSArray arrayWithObjects:@"Facebook", @"Foursquare", @"Twitter", nil]
                                           view:self.window.rootViewController.view
                                      onDismiss:^(int selected) {
                                          switch (selected) {
                                              case 0:
                                                  [EventPublisher checkinWithFacebook:event];
                                                  break;
                                              default:
                                                  break;
                                          }
                                      } onCancel:^{
                                          NSLog(@"Cancelled");
                                      }];
    }
    
}

- (void)handleFollowup:(UILocalNotification *)notification
{
    id<ScheduledEventitem> event = [self loadEventFromNotification:notification];
    if (event) {
        [UIActionSheet showActionSheetWithTitle:[NSString stringWithFormat:@"Write follow-up review for %@?", 
                                                 [notification.userInfo objectForKey:@"name"]]
                              cancelButtonTitle:@"Cancel" 
                         destructiveButtonTitle:nil 
                              otherButtonTitles:[NSArray arrayWithObjects:@"Facebook", @"Foursquare", @"Twitter", nil]
                                           view:self.window.rootViewController.view
                                      onDismiss:^(int selected) {
                                          switch (selected) {
                                              case 0:
                                                  [EventPublisher reviewOnFacebook:event];
                                                  break;
                                              default:
                                                  break;
                                          }
                                      } onCancel:^{
                                          NSLog(@"Cancelled");
                                      }];
    }
}

- (void)respondToNotification:(UILocalNotification *)notification
{
    NSString *type = [notification.userInfo objectForKey:@"type"];

    // Check for follow-up notifications
    if ([type hasSuffix:@" followup"]) {
        [self handleFollowup:notification];
    }    
    // Check for checkin notifications
    else if ([type hasSuffix:@" checkin"]) {
        [self handleCheckin:notification];
    }
    // All other notifications
    else {
        /*
        self.window.rootViewController // ECSlidingViewController
        topViewController // UINavigationController
        topViewController // ???
        */
        if ([self.window.rootViewController isKindOfClass:[ECSlidingViewController class]]) {
            ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
            if ([slidingViewController.topViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navController = (UINavigationController *)slidingViewController.topViewController;
                if ([navController.topViewController isKindOfClass:[ScheduledEventsViewController class]]) {
                    ScheduledEventsViewController *viewController = (ScheduledEventsViewController *)navController.topViewController;
                    [viewController handleLocalNotification:notification];
                }
            }
        }
        
        /*
        //po [[[[self window] rootViewController] topViewController] topViewController]
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            if ([navController.topViewController isKindOfClass:[ScheduledEventsViewController class]]) {
                ScheduledEventsViewController *viewController = (ScheduledEventsViewController *)navController.topViewController;
                [viewController handleLocalNotification:notification];
            }
        }
        */
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    [self initLocationManager];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    slidingViewController.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"FirstTop"];
    
    UILocalNotification *notification = [launchOptions objectForKey:
                                         UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        [self respondToNotification:notification];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
    [self initLocationManager];

    [self respondToNotification:notification];
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

    //self.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.coordinate = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    NSLog(@"Coordinate: %.5f, %.5f", self.coordinate.coordinate.latitude, self.coordinate.coordinate.longitude);
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark *placemark, NSUInteger idx, BOOL *stop) {
            self.zipCode = placemark.postalCode;
        }];
    }];
}

- (BOOL)hasPermissionToAccessCalendar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:kCalendarPermissionKey];
    return [value isEqualToString:@"YES"];
}

- (void)recordPermissionToAccessCalendarGranted
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"YES" forKey:kCalendarPermissionKey];
    [defaults synchronize];
}

// Add event as a local notification
- (void)addLocalNotification:(CalendarEvent *)calendarEvent
{
    if (calendarEvent.reminder) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [calendarEvent.startDate dateByAddingTimeInterval:(-60 * calendarEvent.minutesBefore)];
        notification.alertBody = calendarEvent.title;
        notification.userInfo = [calendarEvent generateUserInfo];
        notification.alertAction = @"Open";
        notification.hasAction = YES;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    // Check-in
    if (calendarEvent.checkin) {
        UILocalNotification *checkinNotification = [[UILocalNotification alloc] init];
        checkinNotification.fireDate = [calendarEvent.startDate dateByAddingTimeInterval:(60 * calendarEvent.checkinMinutes)];
        checkinNotification.alertBody = [NSString stringWithFormat:@"%@ checkin", calendarEvent.title];
        checkinNotification.userInfo = [calendarEvent generateCheckinUserInfo];
        checkinNotification.alertAction = @"Open";
        checkinNotification.hasAction = YES;
        checkinNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:checkinNotification];
    }
    
    // Follow-up
    if (calendarEvent.followUp) {
        UILocalNotification *followUpNotification = [[UILocalNotification alloc] init];
        followUpNotification.fireDate = calendarEvent.followUpWhen;
        followUpNotification.alertBody = [NSString stringWithFormat:@"%@ followup", calendarEvent.title];
        followUpNotification.userInfo = [calendarEvent generateFollowUpUserInfo];
        followUpNotification.alertAction = @"Open";
        followUpNotification.hasAction = YES;
        followUpNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:followUpNotification];
    }
}

// Add event to iPhone calendar
- (void)addToCalendar:(CalendarEvent *)calendarEvent
{
    /* 
     According to Apple's iOS guidelines - "If your application modifies a user’s Calendar database programmatically, it must get confirmation from the user before doing so. An application should never modify the Calendar database without specific instruction from the user."
    */
    if ((calendarEvent.reminder || calendarEvent.checkin || calendarEvent.followUp) &&
        ![self hasPermissionToAccessCalendar]) {
        [MyAlertView showAlertViewWithTitle:@"Calendar" 
                                    message:@"Allow Dinner and a Show to modify your calendar?" 
                          cancelButtonTitle:@"NO" 
                          otherButtonTitles:[NSArray arrayWithObject:@"YES"] 
                                  onDismiss:^() {
                                      // Record the user's decision
                                      [self recordPermissionToAccessCalendarGranted];
                                      
                                      // Resubmit the add to calendar
                                      [self addToCalendar:calendarEvent];
                                  } 
                                   onCancel:^{
                                   }];
        return;
    }
    
    if (calendarEvent.reminder) {
        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        event.calendar = [self.eventStore defaultCalendarForNewEvents];
        event.title = calendarEvent.title;
        event.startDate = calendarEvent.startDate;
        event.endDate = [event.startDate dateByAddingTimeInterval:60];
        if (calendarEvent.url)
            event.URL = [NSURL URLWithString:calendarEvent.url];
        if (calendarEvent.location)
            event.location = calendarEvent.location;
        if (calendarEvent.notes)
            event.notes = calendarEvent.notes;
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:(calendarEvent.minutesBefore * 60)]; // time offset in seconds
        [event addAlarm:alarm];
        NSError *error;
        BOOL saved = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (!saved) {
            NSLog(@"Error saving event.");
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }
    }
    
    // Check-in
    if (calendarEvent.checkin) {
        EKEvent *checkinEvent = [EKEvent eventWithEventStore:self.eventStore];
        checkinEvent.calendar = [self.eventStore defaultCalendarForNewEvents];
        checkinEvent.title = [NSString stringWithFormat:@"%@ checkin", calendarEvent.title];
        checkinEvent.startDate = [calendarEvent.startDate dateByAddingTimeInterval:(calendarEvent.checkinMinutes * 60)];
        checkinEvent.endDate = [checkinEvent.startDate dateByAddingTimeInterval:60];
        if (calendarEvent.followUpUrl)
            checkinEvent.URL = [NSURL URLWithString:calendarEvent.followUpUrl];
        if (calendarEvent.followUpNotes)
            checkinEvent.notes = calendarEvent.followUpNotes;
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[calendarEvent.startDate dateByAddingTimeInterval:(60 * calendarEvent.checkinMinutes)]];
        [checkinEvent addAlarm:alarm];
        NSError *error;
        BOOL saved = [self.eventStore saveEvent:checkinEvent span:EKSpanThisEvent commit:YES error:&error];
        if (!saved) {
            NSLog(@"Error saving event.");
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }
    }
    
    // Follow-up
    if (calendarEvent.followUp) {
        EKEvent *followUpEvent = [EKEvent eventWithEventStore:self.eventStore];
        followUpEvent.calendar = [self.eventStore defaultCalendarForNewEvents];
        followUpEvent.title = [NSString stringWithFormat:@"%@ followup", calendarEvent.title];
        followUpEvent.startDate = calendarEvent.followUpWhen;
        followUpEvent.endDate = [followUpEvent.startDate dateByAddingTimeInterval:60];
        if (calendarEvent.followUpUrl)
            followUpEvent.URL = [NSURL URLWithString:calendarEvent.followUpUrl];
        if (calendarEvent.followUpNotes)
            followUpEvent.notes = calendarEvent.followUpNotes;
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:followUpEvent.startDate];
        [followUpEvent addAlarm:alarm];
        NSError *error;
        BOOL saved = [self.eventStore saveEvent:followUpEvent span:EKSpanThisEvent commit:YES error:&error];
        if (!saved) {
            NSLog(@"Error saving event.");
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }
    }
}

- (void)addNotification:(CalendarEvent *)calendarEvent
{
    // Use Local notification system
    [self addLocalNotification:calendarEvent];
    
    // Use iOS Calendar
    //[self addToCalendar:calendarEvent];
}

- (void)removeLocalNotification:(id<ScheduledEventitem>)calendarEvent
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [notifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSDictionary *userInfo = notification.userInfo;
        if ([[userInfo objectForKey:@"id"] isEqualToString:[calendarEvent eventId]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }];
    
    /*
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [calendarEvent 
    notification.fireDate = [calendarEvent.startDate dateByAddingTimeInterval:(-60 * calendarEvent.minutesBefore)];
    notification.alertBody = calendarEvent.title;
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
     */
}


- (void)removeFromCalendar:(id<ScheduledEventitem>)calendarEvent
{
    // Main event
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[calendarEvent eventDate]
                                                                      endDate:[[calendarEvent eventDate] dateByAddingTimeInterval:60]
                                                                    calendars:[NSArray arrayWithObject:[self.eventStore defaultCalendarForNewEvents]]];
    [self.eventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(EKEvent *event, BOOL *stop) {
        if ([[calendarEvent eventDescription] isEqualToString:event.title]) {
            NSError *error;
            BOOL removed = [self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
            if (!removed) {
                NSLog(@"Error removing event.");
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
            }
        }
    }];

    // Check-in event
    if ([calendarEvent respondsToSelector:@selector(checkin)]) {
        BOOL checkin = (BOOL)[calendarEvent performSelector:@selector(checkin)];
        if (checkin) {
            // Assume that if it responds to checkin, then it responds to checkinMinutes
            int checkinMinutes = (int)[calendarEvent performSelector:@selector(checkinMinutes)];
            NSDate *checkinDate = [[calendarEvent eventDate] dateByAddingTimeInterval:checkinMinutes * 60];
            NSString *checkinTitle = [NSString stringWithFormat:@"%@ checkin", [calendarEvent eventDescription]];
            predicate = [self.eventStore predicateForEventsWithStartDate:checkinDate
                                                                 endDate:[checkinDate dateByAddingTimeInterval:60]
                                                               calendars:[NSArray arrayWithObject:[self.eventStore defaultCalendarForNewEvents]]];
            [self.eventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(EKEvent *event, BOOL *stop) {
                if ([checkinTitle isEqualToString:event.title]) {
                    NSError *error;
                    BOOL removed = [self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
                    if (!removed) {
                        NSLog(@"Error removing event.");
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                        }
                    }
                }
            }];
        }
    }
    
    // Follow-up event
    if ([calendarEvent respondsToSelector:@selector(followUpWhen)]) {
        NSDate *followUpDate = [calendarEvent performSelector:@selector(followUpWhen)];
        NSString *followTitle = [NSString stringWithFormat:@"%@ followup", [calendarEvent eventDescription]];
        predicate = [self.eventStore predicateForEventsWithStartDate:followUpDate
                                                             endDate:[followUpDate dateByAddingTimeInterval:60]
                                                           calendars:[NSArray arrayWithObject:[self.eventStore defaultCalendarForNewEvents]]];
        [self.eventStore enumerateEventsMatchingPredicate:predicate usingBlock:^(EKEvent *event, BOOL *stop) {
            if ([followTitle isEqualToString:event.title]) {
                NSError *error;
                BOOL removed = [self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
                if (!removed) {
                    NSLog(@"Error removing event.");
                    if (error) {
                        NSLog(@"Error: %@", error.localizedDescription);
                    }
                }
            }
        }];
    }
}

- (void)removeNotification:(id<ScheduledEventitem>)calendarEvent
{
    // Use Local notification system
    [self removeLocalNotification:calendarEvent];
    
    // Use iOS Calendar
    //[self removeFromCalendar:calendarEvent];
}

// Facebook methods

// Set up Facebook URL handling in the app
- (void)initFacebook:(PostFacebookLoginBlock) onLogin
{
    _postFacebookLoginBlock = [onLogin copy];
    
    // Create an instance of Facebook
    if (!self.facebook)
        self.facebook = [[Facebook alloc] initWithAppId:kFacebookAppId andDelegate:self];
    
    // Check for previously saved access token information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Log the user in and prompt the user to authorize the app
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:[NSArray arrayWithObjects:
                                  @"publish_checkins", 
                                  @"publish_stream",
                                  nil]];
    }
    else {
        _postFacebookLoginBlock();
    }
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]; 
}

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];

    _postFacebookLoginBlock();
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    _postFacebookLoginBlock = nil;
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    _postFacebookLoginBlock = nil;
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated {
    
}

@end
