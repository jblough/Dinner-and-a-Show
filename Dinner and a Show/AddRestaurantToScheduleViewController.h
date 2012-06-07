//
//  AddRestaurantToScheduleViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRestaurantToScheduleOptions.h"
#import "ScheduledRestaurantEvent.h"

@protocol AddRestaurantDelegate <NSObject>

- (void)add:(AddRestaurantToScheduleOptions *)options sender:(id)sender;
- (void)cancel;

@end

@interface AddRestaurantToScheduleViewController : UITableViewController//UIViewController

@property (nonatomic, weak) id<AddRestaurantDelegate> delegate;
@property (nonatomic, weak) ScheduledRestaurantEvent *originalEvent;

@end
