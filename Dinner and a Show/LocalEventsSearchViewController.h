//
//  LocalEventsSearchViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalEventsSearchCriteria.h"

@protocol LocalEventsSearchDelegate <NSObject>

- (void)cancel;
- (void)searchLocalEvents:(LocalEventsSearchCriteria *)localEventCriteria sender:(id)sender;
- (LocalEventsSearchCriteria *)getLocalEventCriteria;

@end

@interface LocalEventsSearchViewController : UIViewController

@property (nonatomic, weak) id<LocalEventsSearchDelegate> delegate;

@end
