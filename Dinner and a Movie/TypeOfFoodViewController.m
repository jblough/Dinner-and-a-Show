//
//  TypeOfFoodViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeOfFoodViewController.h"
#import "PearsonFetcher.h"

#define kFoodTypeRecipes 0
#define kFoodTypeRestaurants 1

@interface TypeOfFoodViewController ()

@property (nonatomic, strong) NSArray *cuisines;
@property (nonatomic, strong) NSArray *restaurants;

@end

@implementation TypeOfFoodViewController

@synthesize cuisines = _cuisines;
@synthesize restaurants = _restaurants;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadRecipeTypes
{
    if (![self.cuisines count]) self.cuisines = [PearsonFetcher cuisines];
    for (Cuisine *cuisine in self.cuisines) {
        NSLog(@"Cuisine: %@, %d recipes", cuisine.name, cuisine.recipeCount);
    }
}

- (void)loadRestaurantTypes
{
    
}

- (IBAction)changedFoodTypeSource:(UISegmentedControl *)sender
{
    switch ([sender selectedSegmentIndex]) {
        case kFoodTypeRecipes:
            [self loadRecipeTypes];
            break;
        case kFoodTypeRestaurants:
            [self loadRestaurantTypes];
            break;
        default:
            break;
    } 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
