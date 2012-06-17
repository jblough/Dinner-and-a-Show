//
//  ScheduledEventCell.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduledEventitem.h"

@interface ScheduledEventCell : UITableViewCell

- (void)displayEvent:(id<ScheduledEventitem>)event dateCellFormatter:(NSDateFormatter *)dateCellFormatter;

@end
