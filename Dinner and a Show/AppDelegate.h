//
//  AppDelegate.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ScheduledEventLibrary.h"
#import "CalendarEvent.h"
#import "ScheduledEventitem.h"
#import "FBConnect.h"
#import "BZFoursquare.h"

typedef void (^PostLoginBlock)();

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, 
    FBSessionDelegate, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *userSpecifiedCode;
//@property CLLocationCoordinate2D coordinate;
//@property CLLocationCoordinate2D userSpecifiedCoordinate;
@property (nonatomic, strong) CLLocation *coordinate;
@property (nonatomic, strong) CLLocation *userSpecifiedCoordinate;
@property (nonatomic, strong) ScheduledEventLibrary *eventLibrary;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) BZFoursquare *foursquare;

- (void)addNotification:(CalendarEvent *)calendarEvent;
- (void)removeNotification:(id<ScheduledEventitem>)calendarEvent;
- (void)initFacebook:(PostLoginBlock) onLogin;
- (void)initFoursquare:(PostLoginBlock) onLogin;

@end
