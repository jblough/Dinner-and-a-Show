//
//  LocalEventsSearchViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalEventsSearchCriteria.h"

@protocol LocalEventsSearchDelegate <NSObject>

- (void)search:(LocalEventsSearchCriteria *)criteria sender:(id)sender;
- (LocalEventsSearchCriteria *)getCriteria;

@end

@interface LocalEventsSearchViewController : UIViewController

@property (nonatomic, weak) id<LocalEventsSearchDelegate> delegate;

@end
