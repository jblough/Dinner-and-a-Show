//
//  AppDelegate.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ScheduledEventLibrary.h"
#import "CalendarEvent.h"
#import "ScheduledEventitem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *userSpecifiedCode;
//@property CLLocationCoordinate2D coordinate;
//@property CLLocationCoordinate2D userSpecifiedCoordinate;
@property (nonatomic, strong) CLLocation *coordinate;
@property (nonatomic, strong) CLLocation *userSpecifiedCoordinate;
@property (nonatomic, strong) ScheduledEventLibrary *eventLibrary;

- (void)addNotification:(CalendarEvent *)calendarEvent;
- (void)removeNotification:(id<ScheduledEventitem>)calendarEvent;

@end
