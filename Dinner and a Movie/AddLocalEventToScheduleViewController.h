//
//  AddLocalEventToScheduleViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatchEvent.h"
#import "AddLocalEventToScheduleOptions.h"
#import "ScheduledLocalEvent.h"

@protocol AddLocalEventDelegate <NSObject>

- (void)add:(AddLocalEventToScheduleOptions *)options sender:(id)sender;
- (void)cancel;
- (PatchEvent *)getEvent;

@end

@interface AddLocalEventToScheduleViewController : UIViewController

@property (nonatomic, weak) id<AddLocalEventDelegate> delegate;
@property (nonatomic, weak) ScheduledLocalEvent *originalEvent;

@end
