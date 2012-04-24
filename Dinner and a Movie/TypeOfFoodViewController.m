//
//  TypeOfFoodViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeOfFoodViewController.h"

#define kFoodTypeRecipes 0
#define kFoodTypeRestaurants 1

@interface TypeOfFoodViewController ()

@end

@implementation TypeOfFoodViewController

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
