//
//  LocalEventViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatchEvent.h"

@interface LocalEventViewController : UITableViewController

@property (nonatomic, strong) PatchEvent *event;
@end
