//
//  AddRestaurantToScheduleViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRestaurantToScheduleOptions.h"

@protocol AddRestaurantDelegate <NSObject>

- (void)add:(AddRestaurantToScheduleOptions *)options sender:(id)sender;
- (void)cancel;

@end

@interface AddRestaurantToScheduleViewController : UIViewController

@property (nonatomic, weak) id<AddRestaurantDelegate> delegate;

@end
