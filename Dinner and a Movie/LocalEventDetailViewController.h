//
//  LocalEventDetailViewController.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatchStory.h"

@interface LocalEventDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) PatchStory *event;

@end