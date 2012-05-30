//
//  RestaurantViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "AddRestaurantToScheduleViewController.h"
#import "ScheduledRestaurantEvent.h"

@interface RestaurantViewController : UITableViewController <AddRestaurantDelegate>

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, weak) ScheduledRestaurantEvent *originalEvent;

@end
