//
//  AddNewYorkTimesEventToScheduleOptions.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewYorkTimesEvent.h"

@interface AddNewYorkTimesEventToScheduleOptions : NSObject

@property (nonatomic, strong) NewYorkTimesEvent *event;
@property (nonatomic, strong) NSDate *when;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;
@property (nonatomic, strong) NSDate *followUpDate;

@end
