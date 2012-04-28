//
//  TypeOfFoodViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeOfFoodViewController.h"
#import "PearsonFetcher.h"
#import "YelpFetcher.h"
#import "RecipeListTableViewController.h"
#import "RestaurantListTableViewController.h"

#define kFoodTypeRecipes 0
#define kFoodTypeRestaurants 1

@interface TypeOfFoodViewController ()

@property (nonatomic, strong) NSArray *recipeCuisines;
@property (nonatomic, strong) NSArray *restaurantCuisines;
@property (weak, nonatomic) IBOutlet UISegmentedControl *foodTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *foodTypesTableView;

@end

@implementation TypeOfFoodViewController

@synthesize recipeCuisines = _recipeCuisines;
@synthesize restaurantCuisines = _restaurantCuisines;
@synthesize foodTypeSegmentControl = _foodTypeSegmentControl;
@synthesize foodTypesTableView = _foodTypesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadRecipeTypes];
}

- (void)viewDidUnload
{
    [self setFoodTypeSegmentControl:nil];
    [self setFoodTypesTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadRecipeTypes
{
    if (![self.recipeCuisines count]) {
        [PearsonFetcher cuisines:^(id results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recipeCuisines = results;
                NSLog(@"%d cuisines:", [self.recipeCuisines count]);
                [self.foodTypesTableView reloadData];
            });

        }
        onError:^(NSError* error){}];
    }
    else {
        [self.foodTypesTableView reloadData];
    }
}

- (void)loadRestaurantTypes
{
    if (![self.restaurantCuisines count]) {
        YelpFetcher *fetcher = [[YelpFetcher alloc] init];
        [fetcher cuisines:^(id data) {
            self.restaurantCuisines = data;
            [self.foodTypesTableView reloadData];
        }
        onError:^(NSError *error) {}];
    }
    else {
        [self.foodTypesTableView reloadData];
    }
}

- (IBAction)changedFoodTypeSource:(UISegmentedControl *)sender
{
    [self.foodTypesTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

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
    return (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeRecipes) ? 
        [self.recipeCuisines count] : [self.restaurantCuisines count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Type of Food Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeRecipes) {
        Cuisine *cuisine = [self.recipeCuisines objectAtIndex:indexPath.row];
        cell.textLabel.text = cuisine.name;
        cell.detailTextLabel.text = (cuisine.recipeCount == 1) ? @"1 recipe" : [NSString stringWithFormat:@"%d recipes", cuisine.recipeCount];
    }
    else {
        Cuisine *cuisine = [self.restaurantCuisines objectAtIndex:indexPath.row];
        cell.textLabel.text = cuisine.name;
        cell.detailTextLabel.text = @"";        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Since the segue is dynamically either recipes or restaurants, we need to use the did select row method instead of a IB segue
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeRecipes) {
        [self performSegueWithIdentifier:@"Recipe Type Segue" 
                                  sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else {
        [self performSegueWithIdentifier:@"Restaurant Type Segue" 
                                  sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    NSIndexPath *indexPath = [self.foodTypesTableView indexPathForCell:sender];
   if ([segue.identifier isEqualToString:@"Recipe Type Segue"]) {
       RecipeListTableViewController *newController = segue.destinationViewController;
       newController.cuisine = [self.recipeCuisines objectAtIndex:indexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"Restaurant Type Segue"]) {
        RestaurantListTableViewController *newController = segue.destinationViewController;
        newController.cuisine = [self.restaurantCuisines objectAtIndex:indexPath.row];
    }
    
    [self.foodTypesTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
