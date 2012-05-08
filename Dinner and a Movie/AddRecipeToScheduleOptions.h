//
//  AddRecipeToScheduleOptions.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"

@interface AddRecipeToScheduleOptions : NSObject

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, strong) NSDate *when;
@property BOOL reminder;
@property int minutesBefore;
@property BOOL followUp;

@end
