//
//  NutritionalInfo+Json.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NutritionalInfo+Json.h"
#import "NSDictionary+Json.h"

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
    
    info.calcium = [json objectForKeyFromJson:kCalciumTag];
    info.calories = [json objectForKeyFromJson:kCaloriesTag];
    info.caloriesFat = [json objectForKeyFromJson:kCaloriesFromFatTag];
    info.carbohydrates = [json objectForKeyFromJson:kCarbohydratesTag];
    info.cholesterol = [json objectForKeyFromJson:kCholesterolTag];
    info.fat = [json objectForKeyFromJson:kFatTag];
    info.iron = [json objectForKeyFromJson:kIronTag];
    info.protein = [json objectForKeyFromJson:kProteinTag];
    info.saturatedFat = [json objectForKeyFromJson:kSaturatedFatTag];
    info.sodium = [json objectForKeyFromJson:kSodiumTag];
    info.transFat = [json objectForKeyFromJson:kTransFatTag];
    info.vitaminA = [json objectForKeyFromJson:kVitaminATag];
    info.vitaminC = [json objectForKeyFromJson:kVitaminCTag];
    return info;
}

@end
