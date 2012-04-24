//
//  PearsonFetcher.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PearsonFetcher.h"
#import "ApiKeys.h"
#import "Cuisine+Json.h"
#import "Recipe+Json.h"

@implementation PearsonFetcher

+ (NSDictionary *)retrieve:(NSString *)url
{
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData 
                                                                       options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves 
                                                                         error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    return results;
}

+ (NSArray *)cuisines
{
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/cuisines.json?limit=50&apikey=%@", kPearsonApiKey];
    NSDictionary *results = [self retrieve:url];
    NSMutableArray *cuisines = [NSMutableArray array];
    
    NSArray *jsonCuisines = [results objectForKey:@"results"];
    for (NSDictionary *jsonCuisine in jsonCuisines) {
        [cuisines addObject:[Cuisine cuisineFromJson:jsonCuisine]];
    }
    return cuisines;
}

+ (NSArray *)recipesForCuisine:(Cuisine *)cuisine
{
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/preview/kitchen-manager/v1/cuisines/%@.json?apikey=%@", 
                     cuisine.identifier, kPearsonApiKey];
    NSDictionary *results = [self retrieve:url];
    
    NSMutableArray *recipes = [NSMutableArray array];
    NSArray *jsonRecipes = [results objectForKey:@"recipes"];
    for (NSDictionary *jsonRecipe in jsonRecipes) {
        [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
    }
    
    return recipes;
}

+ (Recipe *)loadFullRecipe:(Recipe *)recipe
{
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/recipes/%@?apikey=%@", 
                     recipe.identifier, kPearsonApiKey];
    NSDictionary *results = [self retrieve:url];
    return [Recipe recipeFromJson:results];
}

@end
