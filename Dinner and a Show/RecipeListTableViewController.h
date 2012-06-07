//
//  RecipeListTableViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cuisine.h"
#import "PullToRefreshViewController.h"
#import "RecipeSearchViewController.h"

@interface RecipeListTableViewController : PullToRefreshViewController <RecipeSearchDelegate>

@property (nonatomic, weak) Cuisine *cuisine;

@end
