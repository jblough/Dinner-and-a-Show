//
//  NewYorkTimesEventViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewYorkTimesEvent.h"
#import "AddNewYorkTimesEventToScheduleViewController.h"
#import "ScheduledNewYorkTimesEvent.h"

@interface NewYorkTimesEventViewController : UITableViewController <AddNewYorkTimesEventDelegate>

@property (nonatomic, strong) NewYorkTimesEvent *event;
@property (nonatomic, strong) ScheduledNewYorkTimesEvent *originalEvent;

@end
