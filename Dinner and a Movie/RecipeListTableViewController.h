//
//  RecipeListTableViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cuisine.h"
#import "PullToRefreshViewController.h"

@interface RecipeListTableViewController : UITableViewController//PullToRefreshViewController

@property (nonatomic, weak) Cuisine *cuisine;

@end
