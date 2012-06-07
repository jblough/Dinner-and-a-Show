//
//  RestaurantDetailsViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "AddRestaurantToScheduleViewController.h"
#import "ScheduledRestaurantEvent.h"

@interface RestaurantDetailsViewController : UIViewController <UIWebViewDelegate, AddRestaurantDelegate>

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, weak) ScheduledRestaurantEvent *originalEvent;

@end
