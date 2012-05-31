//
//  AddRecipeToScheduleViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRecipeToScheduleOptions.h"
#import "ScheduledRecipeEvent.h"

@protocol AddRecipeDelegate <NSObject>

- (void)add:(AddRecipeToScheduleOptions *)options sender:(id)sender;
- (void)cancel;

@end


@interface AddRecipeToScheduleViewController : UITableViewController//UIViewController

@property (nonatomic, weak) id<AddRecipeDelegate> delegate;
@property (nonatomic, weak) ScheduledRecipeEvent *originalEvent;

@end
