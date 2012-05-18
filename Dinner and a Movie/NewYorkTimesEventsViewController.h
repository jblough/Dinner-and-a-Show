//
//  NewYorkTimesEventsViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "NewYorkTimesEventsSearchViewController.h"


@interface NewYorkTimesEventsViewController : PullToRefreshViewController //UIViewController 
<UITableViewDataSource, UITableViewDelegate, NewYorkTimesEventsSearchDelegate>

- (void)loadMore;

@end
