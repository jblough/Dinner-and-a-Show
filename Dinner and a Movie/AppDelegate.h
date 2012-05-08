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

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *userSpecifiedCode;
@property CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) ScheduledEventLibrary *eventLibrary;

@end
