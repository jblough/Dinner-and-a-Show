//
//  AddRestaurantToScheduleOptions.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface AddRestaurantToScheduleOptions : NSObject

@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSDate *when;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;
@property (nonatomic, strong) NSDate *followUpDate;

@end
