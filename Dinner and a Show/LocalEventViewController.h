//
//  LocalEventViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatchEvent.h"
#import "AddLocalEventToScheduleViewController.h"
#import "ScheduledLocalEvent.h"

@interface LocalEventViewController : UITableViewController <AddLocalEventDelegate>

@property (nonatomic, strong) PatchEvent *event;
@property (nonatomic, strong) ScheduledLocalEvent *originalEvent;

@end
