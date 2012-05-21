//
//  ScheduledEventLibrary.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledEventLibrary.h"
#import "sqlite3.h"

#import "ScheduledRecipeEvent.h"
#import "ScheduledRestaurantEvent.h"
#import "ScheduledLocalEvent.h"
#import "ScheduledNewYorkTimesEvent.h"

#define kDatabaseFilename @"events.db"

@interface ScheduledEventLibrary ()

@end


@implementation ScheduledEventLibrary


+ (NSString *)editableDatabaseFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:[ScheduledEventLibrary databaseFilePath] toPath:dbPath error:&error];
        if (success) {
            return dbPath;
        }
        else {
            return [ScheduledEventLibrary databaseFilePath];
        }
    }
    return dbPath;
}

+ (NSString *)databaseFilePath {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseFilename];
}

- (id)init
{
    self = [super init];
    if (self) {
        if (sqlite3_open([[ScheduledEventLibrary editableDatabaseFilePath] UTF8String], &database) != SQLITE_OK) {
            NSAssert(0, @"Failed to open event database");
        }
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(database);
}

// Recipes
- (Recipe *)loadRecipe:(NSString *)identifier
{
    Recipe *recipe = nil;
    NSString *query = @"SELECT id, name, url, image_url, thumbnail_url, cuisine, cost, kind, serves, yields, cooking_method FROM recipes WHERE identifier = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            recipe = [[Recipe alloc] init];
            recipe.identifier = identifier;
            char *str = (char *)sqlite3_column_text(statement, 1);
            recipe.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 2);
            recipe.url = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 3);
            recipe.imageUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 4);
            recipe.thumbnailUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            recipe.cuisine = (str) ? [NSString stringWithUTF8String:str] : @"";
            recipe.cost = sqlite3_column_double(statement, 6);
            str = (char *)sqlite3_column_text(statement, 7);
            recipe.kind = (str) ? [NSString stringWithUTF8String:str] : @"";
            recipe.serves = sqlite3_column_int(statement, 8);
            str = (char *)sqlite3_column_text(statement, 9);
            recipe.yields = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 10);
            recipe.cookingMethod = (str) ? [NSString stringWithUTF8String:str] : @"";
        }
    }
    sqlite3_finalize(statement);
    
    NSNumber *recipeId = [self findRecipeId:identifier];
    if (recipeId) {
        query = @"SELECT step_number, instruction FROM recipe_directions WHERE recipe_id = ? ORDER BY step_number;";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [recipeId intValue]);
            
            NSMutableArray *directions = [NSMutableArray array];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                RecipeDirection *direction = [[RecipeDirection alloc] init];
                direction.stepNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                char *str = (char *)sqlite3_column_text(statement, 1);
                direction.instruction = (str) ? [NSString stringWithUTF8String:str] : @"";
                
                //[recipe addDirectionObject:direction];
                [directions addObject:direction];
            }
            [recipe setDirections:directions];
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);

        query = @"SELECT identifier, name, preparation, quantity, unit, url FROM recipe_ingredients WHERE recipe_id = ? ORDER BY id;";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [recipeId intValue]);
            
            NSMutableArray *ingredients = [NSMutableArray array];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                RecipeIngredient *ingredient = [[RecipeIngredient alloc] init];
                char *str = (char *)sqlite3_column_text(statement, 0);
                ingredient.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
                str = (char *)sqlite3_column_text(statement, 1);
                ingredient.name = (str) ? [NSString stringWithUTF8String:str] : @"";
                str = (char *)sqlite3_column_text(statement, 2);
                ingredient.preparation = (str) ? [NSString stringWithUTF8String:str] : @"";
                str = (char *)sqlite3_column_text(statement, 3);
                ingredient.quantity = (str) ? [NSString stringWithUTF8String:str] : @"";
                str = (char *)sqlite3_column_text(statement, 4);
                ingredient.unit = (str) ? [NSString stringWithUTF8String:str] : @"";
                str = (char *)sqlite3_column_text(statement, 5);
                ingredient.url = (str) ? [NSString stringWithUTF8String:str] : @"";
                
                //[recipe addIngredientObject:ingredient];
                [ingredients addObject:ingredient];
            }
            [recipe setIngredients:ingredients];
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    
    return recipe;
}

- (NSNumber *)findRecipeId:(NSString *)identifier
{
    NSNumber *recipeId = nil;
    NSString *query = @"SELECT id FROM recipes WHERE identifier = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            recipeId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }
    sqlite3_finalize(statement);
    
    return recipeId;
}

- (void)removeRecipe:(NSString *)identifier
{
    // CASCADE deletes should take care of the secondary records
    NSString *query = @"DELETE FROM recipes WHERE identifier = ?";
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
    }
    sqlite3_finalize(statement);
}

- (NSNumber *)addRecipe:(Recipe *)recipe
{
    NSNumber *recipeId = nil;
    // Add the primary record
    NSString *query = @"INSERT INTO recipes (identifier, name, url, image_url, thumbnail_url, cuisine, cost, kind, serves, yields, cooking_method) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [recipe.identifier UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [recipe.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [recipe.url UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [recipe.imageUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [recipe.thumbnailUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [recipe.cuisine UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement, 7, recipe.cost);
        sqlite3_bind_text(statement, 8, [recipe.kind UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 9, recipe.serves);
        sqlite3_bind_text(statement, 10, [recipe.yields UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11, [recipe.cookingMethod UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
        if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
            NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        
        recipeId = [self findRecipeId:recipe.identifier];
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    // Add the ingredient and directions secondary records
    if (recipeId != nil) {
        // Directions
        query = @"INSERT INTO recipe_directions (recipe_id, step_number, instruction) VALUES (?, ?, ?);";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            [recipe.directions enumerateObjectsUsingBlock:^(RecipeDirection *direction, NSUInteger idx, BOOL *stop) {
                sqlite3_bind_int(statement, 1, [recipeId intValue]);
                sqlite3_bind_int(statement, 2, idx);
                sqlite3_bind_text(statement, 3, [direction.instruction UTF8String], -1, SQLITE_TRANSIENT);
                
                int success = sqlite3_step(statement);
                // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
                if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                    NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
            }];
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }

        // Ingredients
        query = @"INSERT INTO recipe_ingredients (recipe_id, identifier, name, preparation, quantity, unit, url) VALUES (?, ?, ?, ?, ?, ?, ?);";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            [recipe.ingredients enumerateObjectsUsingBlock:^(RecipeIngredient *ingredient, NSUInteger idx, BOOL *stop) {
                sqlite3_bind_int(statement, 1, [recipeId intValue]);
                sqlite3_bind_text(statement, 2, [ingredient.identifier UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [ingredient.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [ingredient.preparation UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [ingredient.quantity UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [ingredient.unit UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [ingredient.url UTF8String], -1, SQLITE_TRANSIENT);
                
                int success = sqlite3_step(statement);
                // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
                if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                    NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
            }];
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    return recipeId;
}

- (NSArray *)loadScheduledEventsForRecipe:(Recipe *)recipe
{
    return nil;
}

- (BOOL)recipeHasScheduledEvents:(Recipe *)recipe
{
    NSNumber *recipeId = [self findRecipeId:recipe.identifier];
    if (recipeId) {
        BOOL hasEvents = NO;
        NSString *query = @"SELECT id FROM scheduled_recipe_events WHERE recipe_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [recipeId intValue]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                hasEvents = YES;
            }
        }
        sqlite3_finalize(statement);
        return hasEvents;
    }
    else {
        return NO;
    }
    
    return NO;
}

- (NSNumber *)addRecipeEventToSchedule:(AddRecipeToScheduleOptions *)options
{
    // Check if the recipe already exists in the database
    NSNumber *recipeId = [self findRecipeId:options.recipe.identifier];
    if (!recipeId) {
        recipeId = [self addRecipe:options.recipe];
    }
    
    // Check again in case there was an error adding the recipe
    if (recipeId) {
        NSString *query = @"INSERT INTO scheduled_recipe_events (event_date, recipe_id, set_alarm, minutes_before) VALUES (?, ?, ?, ?);";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [options.when timeIntervalSince1970]);
            sqlite3_bind_int(statement, 2, [recipeId intValue]);
            sqlite3_bind_int(statement, 3, (options.reminder) ? 1 : 0);
            sqlite3_bind_int(statement, 4, options.minutesBefore);
            
            int success = sqlite3_step(statement);
            // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
            if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(statement);
        
        // Return the schedule event id
        NSNumber *eventId = nil;
        query = @"SELECT id FROM scheduled_recipe_events WHERE recipe_id = ? AND event_date = ?";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [recipeId intValue]);
            sqlite3_bind_int(statement, 2, [options.when timeIntervalSince1970]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                eventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
        return eventId;
    }
    else {
        return nil;
    }
}

- (void)removeRecipeEvent:(Recipe *)recipe when:(NSDate *)when
{
    NSNumber *recipeId = [self findRecipeId:recipe.identifier];
    
    if (recipeId) {
        // Delete the event
        NSString *query = @"DELETE FROM scheduled_recipe_events WHERE recipe_id = ? AND event_date = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [recipeId intValue]);
            sqlite3_bind_int(statement, 2, [when timeIntervalSince1970]);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
 
        // If the recipe has no more events, remove it
        if (![self recipeHasScheduledEvents:recipe] && ![self isFavoriteRecipe:recipe]) {
            [self removeRecipe:recipe.identifier];
        }
    }
}

- (void)favoriteRecipe:(Recipe *)recipe
{
    NSNumber *recipeId = [self findRecipeId:recipe.identifier];
    
    if (!recipeId)
        recipeId = [self addRecipe:recipe];
    
    if (recipeId) {
        NSString *query = @"UPDATE recipes SET favorite = 1 WHERE identifier = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [recipe.identifier UTF8String], -1, SQLITE_TRANSIENT);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
}

- (void)unfavoriteRecipe:(Recipe *)recipe
{
    NSNumber *recipeId = [self findRecipeId:recipe.identifier];
    
    if (recipeId) {
        NSString *query = @"UPDATE recipes SET favorite = 0 WHERE identifier = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [recipe.identifier UTF8String], -1, SQLITE_TRANSIENT);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
}

- (BOOL)isFavoriteRecipe:(Recipe *)recipe
{
    BOOL isFavorite = NO;
    NSString *query = @"SELECT id FROM recipes WHERE identifier = ? AND favorite = 1";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [recipe.identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            isFavorite = YES;
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return isFavorite;
}

// Restaurants
- (Restaurant *)loadRestaurant:(NSString *)identifier
{
    Restaurant *restaurant = nil;
    NSString *query = @"SELECT id, name, url, image_url, mobile_url, rating_url, phone FROM restaurants WHERE identifier = ?;";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);

        while (sqlite3_step(statement) == SQLITE_ROW) {
            restaurant = [[Restaurant alloc] init];
            restaurant.identifier = identifier;
            char *str = (char *)sqlite3_column_text(statement, 1);
            restaurant.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 2);
            restaurant.url = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 3);
            restaurant.imageUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 4);
            restaurant.mobileUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            restaurant.ratingUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 6);
            restaurant.phone = (str) ? [NSString stringWithUTF8String:str] : @"";
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return restaurant;
}

- (NSNumber *)findRestaurantId:(NSString *)identifier
{
    NSNumber *restaurantId = nil;
    NSString *query = @"SELECT id FROM restaurants WHERE identifier = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            restaurantId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return restaurantId;
    
}

- (void)removeRestaurant:(NSString *)identifier
{
    // CASCADE deletes should take care of the secondary records
    NSString *query = @"DELETE FROM restaurants WHERE identifier = ?";
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
}

- (NSNumber *)addRestaurant:(Restaurant *)restaurant
{
/*    CREATE TABLE restaurants (id INTEGER PRIMARY KEY NOT NULL,
                              identifier VARCHAR(100) UNIQUE NOT NULL,
                              name VARCHAR(255),
                              url VARCHAR(255),
                              image_url VARCHAR(255),
                              mobile_url VARCHAR(255),
                              rating_url VARCHAR(255),
                              phone VARCHAR(20),
                              rating VARCHAR(100));*/
    
    NSNumber *restaurantId = nil;
    // Add the primary record
    NSString *query = @"INSERT INTO restaurants (identifier, name, url, image_url, mobile_url, rating_url, phone) VALUES (?, ?, ?, ?, ?, ?, ?);";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [restaurant.identifier UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [restaurant.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [restaurant.url UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [restaurant.imageUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [restaurant.mobileUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [restaurant.ratingUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [restaurant.phone UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
        if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
            NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        
        restaurantId = [self findRestaurantId:restaurant.identifier];
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    // Add the location secondary records
    /*
    if (restaurantId != nil) {
        // Locations
        query = @"INSERT INTO restaurant_locations (restaurant_id, city, state, country, postal_code, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?);";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [restaurantId intValue]);
            sqlite3_bind_text(statement, 2, [restaurant.location.city UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [restaurant.location.state UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [restaurant.location.country UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [restaurant.location.postalCode UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_double(statement, 6, restaurant.location.latitude);
            sqlite3_bind_double(statement, 7, restaurant.location.longitude);
            
            int success = sqlite3_step(statement);
            // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
            if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        // Ingredients
        query = @"INSERT INTO recipe_ingredients (recipe_id, identifier, name, preparation, quantity, unit, url) VALUES (?, ?, ?, ?, ?, ?, ?);";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            [recipe.ingredients enumerateObjectsUsingBlock:^(RecipeIngredient *ingredient, NSUInteger idx, BOOL *stop) {
                sqlite3_bind_int(statement, 1, [recipeId intValue]);
                sqlite3_bind_text(statement, 2, [ingredient.identifier UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [ingredient.name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [ingredient.preparation UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [ingredient.quantity UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [ingredient.unit UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [ingredient.url UTF8String], -1, SQLITE_TRANSIENT);
                
                int success = sqlite3_step(statement);
                // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
                if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                    NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                    NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
            }];
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
*/    
    return restaurantId;
}

- (NSArray *)loadScheduledEventsForRestaurant:(Restaurant *)restaurant
{
    return nil;
}

- (BOOL)restaurantHasScheduledEvents:(Restaurant *)restaurant
{
    NSNumber *restaurantId = [self findRestaurantId:restaurant.identifier];
    if (restaurantId) {
        BOOL hasEvents = NO;
        NSString *query = @"SELECT id FROM scheduled_restaurant_events WHERE restaurant_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [restaurantId intValue]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                hasEvents = YES;
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        return hasEvents;
    }
    else {
        return NO;
    }
    
    return NO;
}

- (NSNumber *)addRestaurantEventToSchedule:(AddRestaurantToScheduleOptions *)options
{
    // Check if the recipe already exists in the database
    NSNumber *restaurantId = [self findRestaurantId:options.restaurant.identifier];
    if (!restaurantId) {
        restaurantId = [self addRestaurant:options.restaurant];
    }
    
    // Check again in case there was an error adding the recipe
    if (restaurantId) {
        NSString *query = @"INSERT INTO scheduled_restaurant_events (event_date, restaurant_id, set_alarm, minutes_before, set_followup) VALUES (?, ?, ?, ?, ?);";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [options.when timeIntervalSince1970]);
            sqlite3_bind_int(statement, 2, [restaurantId intValue]);
            sqlite3_bind_int(statement, 3, (options.reminder) ? 1 : 0);
            sqlite3_bind_int(statement, 4, options.minutesBefore);
            sqlite3_bind_int(statement, 5, (options.followUp) ? 1 : 0);
            
            int success = sqlite3_step(statement);
            // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
            if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(statement);
        
        // Return the schedule event id
        NSNumber *eventId = nil;
        query = @"SELECT id FROM scheduled_restaurant_events WHERE restaurant_id = ? AND event_date = ?";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [restaurantId intValue]);
            sqlite3_bind_int(statement, 2, [options.when timeIntervalSince1970]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                eventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
        return eventId;
    }
    else {
        return nil;
    }
}

- (void)removeRestaurantEvent:(Restaurant *)restaurant when:(NSDate *)when
{
    NSNumber *restaurantId = [self findRestaurantId:restaurant.identifier];
    
    if (restaurantId) {
        // Delete the event
        NSString *query = @"DELETE FROM scheduled_restaurant_events WHERE restaurant_id = ? AND event_date = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [restaurantId intValue]);
            sqlite3_bind_int(statement, 2, [when timeIntervalSince1970]);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
        // If the restaurant has no more events, remove it
        if (![self restaurantHasScheduledEvents:restaurant] && ![self isFavoriteRestaurant:restaurant]) {
            [self removeRestaurant:restaurant.identifier];
        }
    }
}

- (void)favoriteRestaurant:(Restaurant *)restaurant
{
    NSNumber *restaurantId = [self findRestaurantId:restaurant.identifier];
    
    if (!restaurantId)
        restaurantId = [self addRestaurant:restaurant];
    
    if (restaurantId) {
        NSString *query = @"UPDATE restaurants SET favorite = 1 WHERE identifier = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [restaurant.identifier UTF8String], -1, SQLITE_TRANSIENT);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
}

- (void)unfavoriteRestaurant:(Restaurant *)restaurant
{
    NSNumber *restaurantId = [self findRestaurantId:restaurant.identifier];
    
    if (restaurantId) {
        NSString *query = @"UPDATE restaurants SET favorite = 0 WHERE identifier = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [restaurant.identifier UTF8String], -1, SQLITE_TRANSIENT);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
}

- (BOOL)isFavoriteRestaurant:(Restaurant *)restaurant
{
    BOOL isFavorite = NO;
    NSString *query = @"SELECT id FROM restaurants WHERE identifier = ? AND favorite = 1";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [restaurant.identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            isFavorite = YES;
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return isFavorite;
}


// Local Events
- (PatchEvent *)loadLocalEvent:(NSString *)identifier
{
    PatchEvent *event = nil;
    NSString *query = @"SELECT identifier, title, summary, url FROM local_events WHERE identifier = ?;";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            event = [[PatchEvent alloc] init];
            event.identifier = identifier;
            char *str = (char *)sqlite3_column_text(statement, 1);
            event.title = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 2);
            event.summary = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 3);
            event.url = (str) ? [NSString stringWithUTF8String:str] : @"";
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return event;
}

- (NSNumber *)findLocalEventId:(NSString *)identifier
{
    NSNumber *eventId = nil;
    NSString *query = @"SELECT id FROM local_events WHERE identifier = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            eventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return eventId;
}

- (void)removeLocalEvent:(NSString *)identifier
{
    // CASCADE deletes should take care of the secondary records
    NSString *query = @"DELETE FROM local_events WHERE identifier = ?";
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
}

- (NSNumber *)addLocalEvent:(PatchEvent *)event
{
    /*CREATE TABLE local_events (id INTEGER PRIMARY KEY NOT NULL,
     identifier VARCHAR(100), 
     title VARCHAR(255), 
     summary VARCHAR(500), 
     url VARCHAR(255));*/
    
    NSNumber *eventId = nil;
    // Add the primary record
    NSString *query = @"INSERT INTO local_events (identifier, title, summary, url) VALUES (?, ?, ?, ?);";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [event.identifier UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [event.title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [event.summary UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [event.url UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
        if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
            NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        
        eventId = [self findLocalEventId:event.identifier];
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    return eventId;
}

- (NSArray *)loadScheduledEventsForLocalEvent:(PatchEvent *)event
{
    return nil;
}

- (BOOL)localEventHasScheduledEvents:(PatchEvent *)event
{
    NSNumber *eventId = [self findLocalEventId:event.identifier];
    if (eventId) {
        BOOL hasEvents = NO;
        NSString *query = @"SELECT id FROM scheduled_local_events WHERE local_event_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                hasEvents = YES;
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        return hasEvents;
    }
    else {
        return NO;
    }
    
    return NO;
}

- (NSNumber *)addLocalEventToSchedule:(AddLocalEventToScheduleOptions *)options;
{
    // Check if the recipe already exists in the database
    NSNumber *eventId = [self findLocalEventId:options.event.identifier];
    if (!eventId) {
        eventId = [self addLocalEvent:options.event];
    }
    
    // Check again in case there was an error adding the recipe
    if (eventId) {
        NSString *query = @"INSERT INTO scheduled_local_events (event_date, local_event_id, set_alarm, minutes_before, set_followup) VALUES (?, ?, ?, ?, ?);";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [options.when timeIntervalSince1970]);
            sqlite3_bind_int(statement, 2, [eventId intValue]);
            sqlite3_bind_int(statement, 3, (options.reminder) ? 1 : 0);
            sqlite3_bind_int(statement, 4, options.minutesBefore);
            sqlite3_bind_int(statement, 5, (options.followUp) ? 1 : 0);
            
            int success = sqlite3_step(statement);
            // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
            if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(statement);
        
        // Return the schedule event id
        NSNumber *scheduledEventId = nil;
        query = @"SELECT id FROM scheduled_local_events WHERE local_event_id = ? AND event_date = ?";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            sqlite3_bind_int(statement, 2, [options.when timeIntervalSince1970]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                scheduledEventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
        return scheduledEventId;
    }
    else {
        return nil;
    }
}

- (void)removeLocalEvent:(PatchEvent *)event when:(NSDate *)when
{
    NSNumber *eventId = [self findLocalEventId:event.identifier];
    
    if (eventId) {
        // Delete the event
        NSString *query = @"DELETE FROM scheduled_local_events WHERE local_event_id = ? AND event_date = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            sqlite3_bind_int(statement, 2, [when timeIntervalSince1970]);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        
        // If the restaurant has no more events, remove it
        if (![self localEventHasScheduledEvents:event]) {
            [self removeLocalEvent:event.identifier];
        }
    }
}

// New York Times Events
- (NewYorkTimesEvent *)loadNewYorkTimesEvent:(NSString *)identifier
{
    NewYorkTimesEvent *event = nil;

    NSString *query = @"SELECT identifier, name, description, address, state, postal_code, phone, event_url, theater_url, latitude, longitude, category, subcategory, start_date, venue, times_pick, free, kid_friendly, last_chance, festival, long_running, preview FROM nytimes_events WHERE identifier = ?;";

    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            event = [[NewYorkTimesEvent alloc] init];
            event.identifier = identifier;
            char *str = (char *)sqlite3_column_text(statement, 1);
            event.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 2);
            event.description = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 3);
            event.address = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 4);
            event.state = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            event.zipCode = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 6);
            event.phone = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 7);
            event.eventUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 8);
            event.theaterUrl = (str) ? [NSString stringWithUTF8String:str] : @"";
            event.latitude = sqlite3_column_double(statement, 9);
            event.longitude = sqlite3_column_double(statement, 10);
            str = (char *)sqlite3_column_text(statement, 11);
            event.category = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 12);
            event.subcategory = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 13);
            event.startDate = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 14);
            event.venue = (str) ? [NSString stringWithUTF8String:str] : @"";
            event.isTimesPick = sqlite3_column_int(statement, 15) == 1;
            event.isFree = sqlite3_column_int(statement, 16) == 1;
            event.isKidFriendly = sqlite3_column_int(statement, 17) == 1;
            event.isLastChance = sqlite3_column_int(statement, 18) == 1;
            event.isFestival = sqlite3_column_int(statement, 19) == 1;
            event.isLongRunningShow = sqlite3_column_int(statement, 20) == 1;
            event.isPreviewAndOpenings = sqlite3_column_int(statement, 21) == 1;
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return event;
}

- (NSNumber *)findNewYorkTimesEventId:(NSString *)identifier
{
    NSNumber *eventId = nil;
    NSString *query = @"SELECT id FROM nytimes_events WHERE identifier = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            eventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }
    sqlite3_finalize(statement);
    
    return eventId;
}

- (void)removeNewYorkTimesEvent:(NSString *)identifier
{
    // CASCADE deletes should take care of the secondary records
    NSString *query = @"DELETE FROM nytimes_events WHERE identifier = ?";
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [identifier UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
    }
    sqlite3_finalize(statement);
}

- (NSNumber *)addNewYorkTimesEvent:(NewYorkTimesEvent *)event
{
    /*CREATE TABLE nytimes_events (id INTEGER PRIMARY KEY NOT NULL,
                                 identifier VARCHAR(100), 
                                 name VARCHAR(255),
                                 description VARCHAR(500), 
                                 address VARCHAR(255), 
                                 state VARCHAR(5),
                                 postal_code VARCHAR(10),
                                 phone VARCHAR(500), 
                                 event_url VARCHAR(255),
                                 theater_url VARCHAR(255),
                                 latitude REAL,
                                 longitude REAL,
                                 category VARCHAR(100),
                                 subcategory VARCHAR(100),
                                 start_date TIMESTAMP,
                                 venue VARCHAR(100),
                                 times_pick BOOL,
                                 free BOOL,
                                 kid_friendly BOOL,
                                 last_chance BOOL,
                                 festival BOOL,
                                 long_running BOOL,
                                 preview BOOL);*/
    
    NSNumber *eventId = nil;
    // Add the primary record
    NSString *query = @"INSERT INTO nytimes_events (identifier, name, description, address, state, postal_code, phone, event_url, theater_url, latitude, longitude, category, subcategory, start_date, venue, times_pick, free, kid_friendly, last_chance, festival, long_running, preview) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [event.identifier UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [event.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [event.description UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [event.address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [event.state UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [event.zipCode UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [event.phone UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [event.eventUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [event.theaterUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement, 10, event.latitude);
        sqlite3_bind_double(statement, 11, event.longitude);
        sqlite3_bind_text(statement, 12, [event.category UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 13, [event.subcategory UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 14, [event.startDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 15, [event.venue UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 16, (event.isTimesPick) ? 1 : 0);
        sqlite3_bind_int(statement, 17, (event.isFree) ? 1 : 0);
        sqlite3_bind_int(statement, 18, (event.isKidFriendly) ? 1 : 0);
        sqlite3_bind_int(statement, 19, (event.isLastChance) ? 1 : 0);
        sqlite3_bind_int(statement, 20, (event.isFestival) ? 1 : 0);
        sqlite3_bind_int(statement, 21, (event.isLongRunningShow) ? 1 : 0);
        sqlite3_bind_int(statement, 22, (event.isPreviewAndOpenings) ? 1 : 0);
        
        int success = sqlite3_step(statement);
        // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
        if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
            NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        
        eventId = [self findNewYorkTimesEventId:event.identifier];
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    return eventId;
}

- (NSArray *)loadScheduledEventsForNewYorkTimesEvent:(NewYorkTimesEvent *)event
{
    return nil;
}

- (BOOL)newYorkTimesEventHasScheduledEvents:(NewYorkTimesEvent *)event
{
    NSNumber *eventId = [self findNewYorkTimesEventId:event.identifier];
    if (eventId) {
        BOOL hasEvents = NO;
        NSString *query = @"SELECT id FROM scheduled_nytimes_events WHERE nytimes_event_id = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                hasEvents = YES;
            }
        }
        sqlite3_finalize(statement);
        return hasEvents;
    }
    else {
        return NO;
    }
    
    return NO;
}

- (NSNumber *)addNewYorkTimesEventToSchedule:(AddNewYorkTimesEventToScheduleOptions *)options
{
    // Check if the recipe already exists in the database
    NSNumber *eventId = [self findNewYorkTimesEventId:options.event.identifier];
    if (!eventId) {
        eventId = [self addNewYorkTimesEvent:options.event];
    }
    
    // Check again in case there was an error adding the recipe
    if (eventId) {
        NSString *query = @"INSERT INTO scheduled_nytimes_events (event_date, nytimes_event_id, set_alarm, minutes_before, set_followup) VALUES (?, ?, ?, ?, ?);";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [options.when timeIntervalSince1970]);
            sqlite3_bind_int(statement, 2, [eventId intValue]);
            sqlite3_bind_int(statement, 3, (options.reminder) ? 1 : 0);
            sqlite3_bind_int(statement, 4, options.minutesBefore);
            sqlite3_bind_int(statement, 5, (options.followUp) ? 1 : 0);
            
            int success = sqlite3_step(statement);
            // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
            if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
                NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_finalize(statement);
        
        // Return the schedule event id
        NSNumber *scheduledEventId = nil;
        query = @"SELECT id FROM scheduled_nytimes_events WHERE nytimes_event_id = ? AND event_date = ?";
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            sqlite3_bind_int(statement, 2, [options.when timeIntervalSince1970]);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                scheduledEventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        else {
            NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
        return scheduledEventId;
    }
    else {
        return nil;
    }
}

- (void)removeNewYorkTimesEvent:(NewYorkTimesEvent *)event when:(NSDate *)when
{
    NSNumber *eventId = [self findNewYorkTimesEventId:event.identifier];
    
    if (eventId) {
        // Delete the event
        NSString *query = @"DELETE FROM scheduled_nytimes_events WHERE nytimes_event_id = ? AND event_date = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, [eventId intValue]);
            sqlite3_bind_int(statement, 2, [when timeIntervalSince1970]);
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSAssert1(0, @"Error: failed to remove from the database with message '%s'.", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        
        // If the restaurant has no more events, remove it
        if (![self newYorkTimesEventHasScheduledEvents:event]) {
            [self removeNewYorkTimesEvent:event.identifier];
        }
    }
}


// Custom Events
- (CustomEvent *)loadCustomEvent:(NSString *)name on:(NSDate *)date
{
    CustomEvent *event = nil;
    NSString *query = @"SELECT latitude, longitude, set_alarm, minutes_before, set_followup FROM scheduled_custom_events WHERE name = ? AND event_date = ?";// WHERE s.event_date > ? ORDER BY s.event_date";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, [date timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            event = [[CustomEvent alloc] init];
            event.name = name;
            event.when = date;
            event.latitude = sqlite3_column_double(statement, 0);
            event.longitude = sqlite3_column_double(statement, 1);
            event.when = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 2)];
            event.reminder = sqlite3_column_int(statement, 3) == 1;
            event.minutesBefore = sqlite3_column_int(statement, 4);
            event.followUp = sqlite3_column_int(statement, 5) == 1;
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
                                                    
                                                    return event;
}

- (NSNumber *)addCustomEventToSchedule:(CustomEvent *)event
{
    NSString *query = @"INSERT INTO scheduled_custom_events (name, event_date, latitude, longitude, set_alarm, minutes_before, set_followup) VALUES (?, ?, ?, ?, ?, ?, ?);";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [event.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, [event.when timeIntervalSince1970]);
        sqlite3_bind_double(statement, 3, event.latitude);
        sqlite3_bind_double(statement, 4, event.longitude);
        sqlite3_bind_int(statement, 5, (event.reminder) ? 1 : 0);
        sqlite3_bind_int(statement, 6, event.minutesBefore);
        sqlite3_bind_int(statement, 7, (event.followUp) ? 1 : 0);
        
        int success = sqlite3_step(statement);
        // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
        if (success == SQLITE_ERROR || success == SQLITE_CONSTRAINT) {
            NSLog(@"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
            NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statement);
    
    // Return the schedule event id
    NSNumber *scheduledEventId = nil;
    query = @"SELECT id FROM scheduled_custom_events WHERE name = ? AND event_date = ?";
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [event.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, [event.when timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            scheduledEventId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return scheduledEventId;
}

- (void)removeCustomEvent:(CustomEvent *)event when:(NSDate *)when
{
    
}

// Methods applicable to all schedules items
- (BOOL)hasScheduledItems
{
    BOOL itemsScheduled = NO;
    
    NSString *query = @"SELECT COUNT(*) FROM (SELECT id FROM scheduled_recipe_events UNION SELECT id FROM scheduled_restaurant_events UNION SELECT id FROM scheduled_local_events UNION SELECT id FROM scheduled_nytimes_events UNION SELECT id FROM scheduled_custom_events);";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            itemsScheduled = sqlite3_column_int(statement, 0) > 0;
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return itemsScheduled;
}

- (NSArray *)scheduledItems
{
    NSMutableArray *items = [NSMutableArray array];
    
    // Recipes
    NSString *query = @"SELECT s.event_date, s.set_alarm, s.minutes_before, r.name, r.identifier FROM scheduled_recipe_events s JOIN recipes r ON r.id = s.recipe_id;";// WHERE s.event_date > ? ORDER BY s.event_date";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //sqlite3_bind_int(statement, 1, [[NSDate date] timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ScheduledRecipeEvent *recipeEvent = [[ScheduledRecipeEvent alloc] init];
            recipeEvent.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 0)];
            recipeEvent.reminder = sqlite3_column_int(statement, 1) == 1;
            recipeEvent.minutesBefore = sqlite3_column_int(statement, 2);
            
            recipeEvent.recipe = [[Recipe alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 3);
            recipeEvent.recipe.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 4);
            recipeEvent.recipe.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [items addObject:recipeEvent];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    
    // Restaurants
    query = @"SELECT s.event_date, s.set_alarm, s.minutes_before, s.set_followup, r.name, r.identifier FROM scheduled_restaurant_events s JOIN restaurants r ON r.id = s.restaurant_id;";// WHERE s.event_date > ? ORDER BY s.event_date";
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //sqlite3_bind_int(statement, 1, [[NSDate date] timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ScheduledRestaurantEvent *restaurantEvent = [[ScheduledRestaurantEvent alloc] init];
            restaurantEvent.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 0)];
            restaurantEvent.reminder = sqlite3_column_int(statement, 1) == 1;
            restaurantEvent.minutesBefore = sqlite3_column_int(statement, 2);
            restaurantEvent.followUp = sqlite3_column_int(statement, 3) == 1;
            
            restaurantEvent.restaurant = [[Restaurant alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 4);
            restaurantEvent.restaurant.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            restaurantEvent.restaurant.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [items addObject:restaurantEvent];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    // Local Events
    query = @"SELECT s.event_date, s.set_alarm, s.minutes_before, s.set_followup, r.title, r.identifier FROM scheduled_local_events s JOIN local_events r ON r.id = s.local_event_id;";// WHERE s.event_date > ? ORDER BY s.event_date";
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //sqlite3_bind_int(statement, 1, [[NSDate date] timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ScheduledLocalEvent *localEvent = [[ScheduledLocalEvent alloc] init];
            localEvent.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 0)];
            localEvent.reminder = sqlite3_column_int(statement, 1) == 1;
            localEvent.minutesBefore = sqlite3_column_int(statement, 2);
            localEvent.followUp = sqlite3_column_int(statement, 3) == 1;
            
            localEvent.event = [[PatchEvent alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 4);
            localEvent.event.title = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            localEvent.event.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [items addObject:localEvent];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);

    
    // New York Times Events
    query = @"SELECT s.event_date, s.set_alarm, s.minutes_before, s.set_followup, r.name, r.identifier FROM scheduled_nytimes_events s JOIN nytimes_events r ON r.id = s.nytimes_event_id;";// WHERE s.event_date > ? ORDER BY s.event_date";
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //sqlite3_bind_int(statement, 1, [[NSDate date] timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ScheduledNewYorkTimesEvent *nyTimesEvent = [[ScheduledNewYorkTimesEvent alloc] init];
            nyTimesEvent.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 0)];
            nyTimesEvent.reminder = sqlite3_column_int(statement, 1) == 1;
            nyTimesEvent.minutesBefore = sqlite3_column_int(statement, 2);
            nyTimesEvent.followUp = sqlite3_column_int(statement, 3) == 1;
            
            nyTimesEvent.event = [[NewYorkTimesEvent alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 4);
            nyTimesEvent.event.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 5);
            nyTimesEvent.event.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [items addObject:nyTimesEvent];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    
    // Custom Events
    query = @"SELECT name, event_date, set_alarm, minutes_before, set_followup FROM scheduled_custom_events;";// WHERE s.event_date > ? ORDER BY s.event_date";
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //sqlite3_bind_int(statement, 1, [[NSDate date] timeIntervalSince1970]);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            CustomEvent *event = [[CustomEvent alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 0);
            event.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            event.when = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 1)];
            event.reminder = sqlite3_column_int(statement, 2) == 1;
            event.minutesBefore = sqlite3_column_int(statement, 3);
            event.followUp = sqlite3_column_int(statement, 4) == 1;

            [items addObject:event];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    // Sort the array based on date
    return [items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSTimeInterval interval1 = [[(id<ScheduledEventitem>)obj1 eventDate] timeIntervalSince1970];
        NSTimeInterval interval2 = [[(id<ScheduledEventitem>)obj2 eventDate] timeIntervalSince1970];
        if (interval1 < interval2)
            return NSOrderedAscending;
        else if (interval1 > interval2)
            return NSOrderedDescending;
        else {
            return NSOrderedSame;
        }
    }];
}

- (NSSet *)getFavoriteRecipes
{
    NSMutableSet *favorites = [NSMutableSet set];
    NSString *query = @"SELECT identifier FROM recipes WHERE favorite = 1";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *str = (char *)sqlite3_column_text(statement, 0);
            NSString *identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [favorites addObject:identifier];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return [favorites copy];
}

- (NSSet *)getFavoriteRestaurants
{
    NSMutableSet *favorites = [NSMutableSet set];
    NSString *query = @"SELECT identifier FROM restaurants WHERE favorite = 1";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *str = (char *)sqlite3_column_text(statement, 0);
            NSString *identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            [favorites addObject:identifier];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return [favorites copy];
}

- (NSArray *)getFavoriteFullRecipes
{
    NSMutableArray *favorites = [NSMutableArray array];
    NSString *query = @"SELECT name, identifier FROM recipes WHERE favorite = 1 ORDER BY name";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Recipe *recipe = [[Recipe alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 0);
            recipe.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 1);
            recipe.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            
            [favorites addObject:recipe];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return [favorites copy];
}

- (NSArray *)getFavoriteFullRestaurants
{
    NSMutableArray *favorites = [NSMutableArray array];
    NSString *query = @"SELECT name, identifier FROM restaurants WHERE favorite = 1 ORDER BY name";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Restaurant *restaurant = [[Restaurant alloc] init];
            char *str = (char *)sqlite3_column_text(statement, 0);
            restaurant.name = (str) ? [NSString stringWithUTF8String:str] : @"";
            str = (char *)sqlite3_column_text(statement, 1);
            restaurant.identifier = (str) ? [NSString stringWithUTF8String:str] : @"";
            
            [favorites addObject:restaurant];
        }
    }
    else {
        NSLog(@"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
        NSAssert1(0, @"Error: failed to prepare the statement with message '%s'.", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    
    return [favorites copy];
}

@end
