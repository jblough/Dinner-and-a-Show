//
//  RecipeDetailsViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "AddRecipeToScheduleViewController.h"
#import "ScheduledRecipeEvent.h"

@interface RecipeDetailsViewController : UIViewController <AddRecipeDelegate>

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, weak) ScheduledRecipeEvent *originalEvent;

@end
