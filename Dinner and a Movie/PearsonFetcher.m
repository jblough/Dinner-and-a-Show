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

+ (void)retrieve:(NSString *)url onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    dispatch_queue_t queue= dispatch_queue_create("com.josephblough.dinner.pearsonfetcher", nil);
    
    dispatch_async(queue, ^{
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData 
                                                                           options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves 
                                                                             error:&error] : nil;
        if (error) {
            NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            onError(error);   
        }
        else {
            onCompletion(results);
        }
    });
    dispatch_release(queue);
}

+ (void)cuisines:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    NSLog(@"retrieving cuisines");
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/cuisines.json?limit=50&apikey=%@", kPearsonApiKey];
    [self retrieve:url onCompletion:^(id results) {
        NSMutableArray *cuisines = [NSMutableArray array];
        
        NSArray *jsonCuisines = [results objectForKey:@"results"];
        /*for (NSDictionary *jsonCuisine in jsonCuisines) {
         [cuisines addObject:[Cuisine cuisineFromJson:jsonCuisine]];
         }*/
        [jsonCuisines enumerateObjectsUsingBlock:^(id jsonCuisine, NSUInteger idx, BOOL *stop) {
            Cuisine *cuisine = [Cuisine cuisineFromJson:jsonCuisine];
            if (cuisine.recipeCount > 0)
                [cuisines addObject:cuisine];
        }];
        
        onCompletion([cuisines copy]);
    }
     
           onError:onError];
}

+ (void)recipesForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    NSLog(@"retrieving recipes for %@", cuisine.name);
    /*NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/preview/kitchen-manager/v1/cuisines/%@.json?limit=50&apikey=%@", 
                     cuisine.identifier, kPearsonApiKey];
    NSDictionary *results = [self retrieve:url];*/
    [self retrieve:cuisine.url onCompletion:^(id results) {
        NSMutableArray *recipes = [NSMutableArray array];
        NSArray *jsonRecipes = [results objectForKey:@"recipes"];
        /*for (NSDictionary *jsonRecipe in jsonRecipes) {
         [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
         }*/
        [jsonRecipes enumerateObjectsUsingBlock:^(id jsonRecipe, NSUInteger idx, BOOL *stop) {
            [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
        }];
        
        onCompletion([recipes copy]);
    }
    onError:onError];
}

+ (void)loadFullRecipe:(Recipe *)recipe onCompletion:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    /*NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/recipes/%@?apikey=%@", 
                     recipe.identifier, kPearsonApiKey];*/
    [self retrieve:recipe.url onCompletion:^(id results) {
        Recipe *completeRecipe = [Recipe recipeFromJson:results];
        onCompletion(completeRecipe);
    }
    onError:onError];
}

@end
