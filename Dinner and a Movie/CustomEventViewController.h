//
//  CustomEventViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomEvent.h"

@interface CustomEventViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, weak) CustomEvent *event;

@end
