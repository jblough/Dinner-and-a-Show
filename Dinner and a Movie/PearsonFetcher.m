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

+ (void)retrieve:(NSString *)url onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
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

+ (void)cuisines:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSLog(@"retrieving cuisines");
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/cuisines.json?limit=50&apikey=%@", kPearsonApiKey];
    [self retrieve:url onCompletion:^(id results) {
        NSMutableArray *cuisines = [NSMutableArray array];
        
        NSArray *jsonCuisines = [results objectForKey:@"results"];
        [jsonCuisines enumerateObjectsUsingBlock:^(id jsonCuisine, NSUInteger idx, BOOL *stop) {
            Cuisine *cuisine = [Cuisine cuisineFromJson:jsonCuisine];
            if (cuisine.recipeCount > 0)
                [cuisines addObject:cuisine];
        }];
        
        onCompletion([cuisines copy]);
    }
     
           onError:onError];
}

+ (void)recipesForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSLog(@"retrieving recipes for %@", cuisine.name);
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/cuisines/%@.json?limit=50&apikey=%@", 
                     cuisine.identifier, kPearsonApiKey];

    [self retrieve:url onCompletion:^(id results) {
        NSMutableArray *recipes = [NSMutableArray array];
        NSArray *jsonRecipes = [results objectForKey:@"recipes"];
        [jsonRecipes enumerateObjectsUsingBlock:^(id jsonRecipe, NSUInteger idx, BOOL *stop) {
            [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
        }];
        
        onCompletion([recipes copy]);
    }
    onError:onError];
}

+ (void)recipesForCuisine:(Cuisine *)cuisine page:(int) page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSLog(@"retrieving recipes for %@", cuisine.name);
    int start = page * kRecipePageSize;
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/cuisines/%@.json?offset=%d&limit=%d&apikey=%@", 
                     cuisine.identifier, start, kRecipePageSize, kPearsonApiKey];

    NSLog(@"url from json: %@", cuisine.url);
    NSLog(@"url: %@", url);
    [self retrieve:url onCompletion:^(id results) {
        NSMutableArray *recipes = [NSMutableArray array];
        NSArray *jsonRecipes = [results objectForKey:@"recipes"];
        [jsonRecipes enumerateObjectsUsingBlock:^(id jsonRecipe, NSUInteger idx, BOOL *stop) {
            [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
        }];
        
        onCompletion([recipes copy]);
    }
           onError:onError];
}

+ (void)recipesForCuisine:(Cuisine *)cuisine search:(RecipeSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSLog(@"retrieving recipes for %@", cuisine.name);
    // Not a perfect URL encoding, but will do for now
    NSString *urlEncodedSearch = @"";//[search stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    if (criteria.filterCuisine && ![@"n-a" isEqualToString:cuisine.identifier]) {
        urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&cuisine=%@", [cuisine.identifier stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    if (criteria.nameFilter && ![@"" isEqualToString:criteria.nameFilter]) {
        urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&name-contains=%@", [criteria.nameFilter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    if (criteria.ingredientFilter && ![@"" isEqualToString:criteria.ingredientFilter]) {
        urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&ingredients-any=%@", [criteria.ingredientFilter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    
    int start = page * kRecipePageSize;
    urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&offset=%d", start];
    
    NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/recipes?%@&limit=50&apikey=%@", 
                     urlEncodedSearch, kPearsonApiKey];

    NSLog(@"Searching with: %@", url);
    [self retrieve:url onCompletion:^(id results) {
        NSMutableArray *recipes = [NSMutableArray array];
        NSArray *jsonRecipes = [results objectForKey:@"results"];
        [jsonRecipes enumerateObjectsUsingBlock:^(id jsonRecipe, NSUInteger idx, BOOL *stop) {
            [recipes addObject:[Recipe recipeFromJson:jsonRecipe]];
        }];
        
        onCompletion([recipes copy]);
    }
           onError:onError];
}

+ (void)loadFullRecipe:(Recipe *)recipe onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    /*NSString *url = [NSString stringWithFormat:@"http://api.pearson.com/kitchen-manager/v1/recipes/%@?apikey=%@", 
                     recipe.identifier, kPearsonApiKey];*/
    NSLog(@"Recipe URL: %@", recipe.url);
    [self retrieve:recipe.url onCompletion:^(id results) {
        Recipe *completeRecipe = [Recipe recipeFromJson:results];
        onCompletion(completeRecipe);
    }
    onError:onError];
}

@end
