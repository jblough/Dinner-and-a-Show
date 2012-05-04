//
//  RestaurantListTableViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "RestaurantSearchViewController.h"
#import "Cuisine.h"

@interface RestaurantListTableViewController : PullToRefreshViewController//UIViewController 
    <UITableViewDataSource, UITableViewDelegate, RestauranSearchDelegate>

@property (nonatomic, weak) Cuisine *cuisine;

@end
