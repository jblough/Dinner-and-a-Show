//
//  NutritionalInfo+Json.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NutritionalInfo+Json.h"

#define kCalciumTag @"calcium"
#define kCaloriesTag @"calories"
#define kCaloriesFromFatTag @"calories_fat"
#define kCarbohydratesTag @"carbohydrates"
#define kCholesterolTag @"cholesterol"
#define kFatTag @"fat"
#define kIronTag @"iron"
#define kProteinTag @"protein"
#define kSaturatedFatTag @"saturated_fat"
#define kSodiumTag @"sodium"
#define kTransFatTag @"trans_fat"
#define kVitaminATag @"vitamin_a"
#define kVitaminCTag @"vitamin_c"

@implementation NutritionalInfo (Json)

+ (NutritionalInfo *)nutritionalInfoFromJson:(NSDictionary *)json
{
    NutritionalInfo *info = [[NutritionalInfo alloc] init];
    
    info.calcium = [json objectForKey:kCalciumTag];
    info.calories = [json objectForKey:kCaloriesTag];
    info.caloriesFat = [json objectForKey:kCaloriesFromFatTag];
    info.carbohydrates = [json objectForKey:kCarbohydratesTag];
    info.cholesterol = [json objectForKey:kCholesterolTag];
    info.fat = [json objectForKey:kFatTag];
    info.iron = [json objectForKey:kIronTag];
    info.protein = [json objectForKey:kProteinTag];
    info.saturatedFat = [json objectForKey:kSaturatedFatTag];
    info.sodium = [json objectForKey:kSodiumTag];
    info.transFat = [json objectForKey:kTransFatTag];
    info.vitaminA = [json objectForKey:kVitaminATag];
    info.vitaminC = [json objectForKey:kVitaminCTag];
    return info;
}

@end
