//
//  RecipeSearchViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeSearchCriteria.h"

@protocol RecipeSearchDelegate <NSObject>

- (void)search:(RecipeSearchCriteria *)criteria sender:(id)sender;
- (RecipeSearchCriteria *)getCriteria;

@end

@interface RecipeSearchViewController : UIViewController

@property (nonatomic, weak) id<RecipeSearchDelegate> delegate;

@end
