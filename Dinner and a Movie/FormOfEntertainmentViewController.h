//
//  FormOfEntertainmentViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "LocalEventsSearchViewController.h"
#import "NewYorkTimesEventsSearchViewController.h"

@interface FormOfEntertainmentViewController : PullToRefreshViewController //UITableViewController
<UITableViewDataSource, UITableViewDelegate, LocalEventsSearchDelegate, NewYorkTimesEventsSearchDelegate>

@end
