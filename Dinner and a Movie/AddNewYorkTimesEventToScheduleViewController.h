//
//  AddNewYorkTimesEventToScheduleViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewYorkTimesEventToScheduleOptions.h"
#import "NewYorkTimesEvent.h"
#import "ScheduledNewYorkTimesEvent.h"

@protocol AddNewYorkTimesEventDelegate <NSObject>

- (void)add:(AddNewYorkTimesEventToScheduleOptions *)options sender:(id)sender;
- (void)cancel;
- (NewYorkTimesEvent *)getEvent;

@end

@interface AddNewYorkTimesEventToScheduleViewController : UIViewController

@property (nonatomic, weak) id<AddNewYorkTimesEventDelegate> delegate;
@property (nonatomic, weak) ScheduledNewYorkTimesEvent *originalEvent;

@end
