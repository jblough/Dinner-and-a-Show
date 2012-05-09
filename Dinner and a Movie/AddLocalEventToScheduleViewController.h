//
//  AddLocalEventToScheduleViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddLocalEventToScheduleOptions.h"

@protocol AddLocalEventDelegate <NSObject>

- (void)add:(AddLocalEventToScheduleOptions *)options sender:(id)sender;
- (void)cancel;

@end

@interface AddLocalEventToScheduleViewController : UIViewController

@property (nonatomic, weak) id<AddLocalEventDelegate> delegate;

@end
