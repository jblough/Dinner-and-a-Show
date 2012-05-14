//
//  RestaurantViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantViewController : UITableViewController

@property (nonatomic, strong) Restaurant *restaurant;

@end
