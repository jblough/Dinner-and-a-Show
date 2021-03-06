//
//  RestaurantSearchViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantSearchCriteria.h"

@protocol RestauranSearchDelegate <NSObject>

- (void)cancel;
- (void)search:(RestaurantSearchCriteria *)criteria sender:(id)sender;
- (RestaurantSearchCriteria *)getCriteria;

@end


@interface RestaurantSearchViewController : UIViewController

@property (nonatomic, weak) id<RestauranSearchDelegate> delegate;

@end
