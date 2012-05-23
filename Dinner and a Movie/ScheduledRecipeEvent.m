//
//  ScheduledRecipeEvent.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledRecipeEvent.h"
#import "Recipe.h"
#import "RecipeDetailsViewController.h"
#import "AppDelegate.h"


@implementation ScheduledRecipeEvent

@synthesize date = _date;
@synthesize recipe = _recipe;
@synthesize reminder = _reminder;
@synthesize minutesBefore = _minutesBefore;

- (NSDate *)eventDate
{
    return self.date;
}

- (NSString *)eventDescription
{
    return (self.recipe) ? self.recipe.name : @"";
}

- (void)deleteEvent
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelete.eventLibrary removeRecipeEvent:self.recipe when:self.date];
    [appDelete removeFromCalendar:self];
}

- (NSString *)getSegue
{
    return @"Recipe Selection Segue";
}

- (void)prepSegueDestination:(id)destinationViewController
{
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Recipe *fullRecipe = [appDelete.eventLibrary loadRecipe:self.recipe.identifier];
    [(RecipeDetailsViewController *)destinationViewController setRecipe:fullRecipe];
}

@end
