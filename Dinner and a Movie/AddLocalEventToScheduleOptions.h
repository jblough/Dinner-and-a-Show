//
//  AddLocalEventToScheduleOptions.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatchEvent.h"

@interface AddLocalEventToScheduleOptions : NSObject

@property (nonatomic, strong) PatchEvent *event;
@property (nonatomic, strong) NSDate *when;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;
@property (nonatomic, strong) NSDate *followUpDate;

@end
