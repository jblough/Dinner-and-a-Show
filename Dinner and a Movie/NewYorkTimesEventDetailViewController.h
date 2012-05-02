//
//  NewYorkTimesEventDetailViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewYorkTimesEvent.h"

@interface NewYorkTimesEventDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) NewYorkTimesEvent *event;

@end
