//
//  RecipeNutritionalInformation.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeNutritionalInformation : NSManagedObject

@property (nonatomic, retain) NSString * calcium;
@property (nonatomic, retain) NSString * calories;
@property (nonatomic, retain) NSString * caloriesFat;
@property (nonatomic, retain) NSString * carbohydrates;
@property (nonatomic, retain) NSString * cholesterol;
@property (nonatomic, retain) NSString * fat;
@property (nonatomic, retain) NSString * iron;
@property (nonatomic, retain) NSString * protein;
@property (nonatomic, retain) NSString * saturatedFat;
@property (nonatomic, retain) NSString * sodium;
@property (nonatomic, retain) NSString * transFat;
@property (nonatomic, retain) NSString * vitaminA;
@property (nonatomic, retain) NSString * vitaminC;
@property (nonatomic, retain) Recipe *recipe;

@end
