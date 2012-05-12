//
//  TypeOfFoodViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeOfFoodViewController.h"
#import "RecipeListTableViewController.h"
#import "RestaurantListTableViewController.h"

#import "UIAlertView+Blocks.h"
#import "SVProgressHUD.h"

#import "PearsonFetcher.h"
#import "YelpFetcher.h"

#import "AppDelegate.h"



#define kFoodTypeFavorites 0
#define kFoodTypeRecipes 1
#define kFoodTypeRestaurants 2

@interface TypeOfFoodViewController ()

@property (nonatomic, strong) NSArray *recipeCuisines;
@property (nonatomic, strong) NSArray *restaurantCuisines;
@property (weak, nonatomic) IBOutlet UISegmentedControl *foodTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *foodTypesTableView;

@property (nonatomic, strong) NSArray *favoriteRecipes;
@property (nonatomic, strong) NSArray *favoriteRestaurants;

@end

@implementation TypeOfFoodViewController

@synthesize recipeCuisines = _recipeCuisines;
@synthesize restaurantCuisines = _restaurantCuisines;
@synthesize foodTypeSegmentControl = _foodTypeSegmentControl;
@synthesize foodTypesTableView = _foodTypesTableView;

@synthesize favoriteRecipes = _favoriteRecipes;
@synthesize favoriteRestaurants = _favoriteRestaurants;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self loadRecipeTypes];
    [self loadFavorites];
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
        [SVProgressHUD showWithStatus:@"Downloading recipe types"];
        [PearsonFetcher cuisines:^(id results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recipeCuisines = results;
                NSLog(@"%d cuisines:", [self.recipeCuisines count]);
                [self.foodTypesTableView reloadData];
                [SVProgressHUD dismiss];
            });

        }
        onError:^(NSError* error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:error.localizedDescription];
            });
        }];
    }
    else {
        [self.foodTypesTableView reloadData];
    }
}

- (void)loadRestaurantTypes
{
    if (![self.restaurantCuisines count]) {
        //YelpFetcher *fetcher = [[YelpFetcher alloc] init];
        [YelpFetcher cuisines:^(id data) {
            self.restaurantCuisines = data;
            [self.foodTypesTableView reloadData];
        }
        onError:^(NSError *error) {}];
    }
    else {
        [self.foodTypesTableView reloadData];
    }
}

- (void)loadFavorites
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.favoriteRecipes = [appDelegate.eventLibrary getFavoriteFullRecipes];
    self.favoriteRestaurants = [appDelegate.eventLibrary getFavoriteFullRestaurants];
    
    [self.foodTypesTableView reloadData];
}

- (IBAction)changedFoodTypeSource:(UISegmentedControl *)sender
{
    [self.foodTypesTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    switch ([sender selectedSegmentIndex]) {
        case kFoodTypeFavorites:
            [self loadFavorites];
            break;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeFavorites) {
        int count = 0;
        if ([self.favoriteRecipes count] > 0) count++;
        if ([self.favoriteRestaurants count] > 0) count++;
        return count;
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeFavorites) {
        if (section == 1) return @"Restaurants";
        else if (section == 0) return ([self.favoriteRecipes count] == 0) ? @"Restaurants" : @"Recipes";
        else return @"";
    }
    else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeFavorites) {
        if ((section == 1) || ([self.favoriteRecipes count] == 0)) {
            return [self.favoriteRestaurants count];
        }
        else if (section == 0) {
            return [self.favoriteRecipes count];
        }
        else {
            return 0;
        }
    }
    else {
        return (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeRecipes) ? 
        [self.recipeCuisines count] : [self.restaurantCuisines count];
    }
}

- (UITableViewCell *):(UITableView *)tableView getFavoritesCell:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Type of Food Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ((indexPath.section == 1) || ([self.favoriteRecipes count] == 0)) {
        Restaurant *restaurant = [self.favoriteRestaurants objectAtIndex:indexPath.row];
        cell.textLabel.text = restaurant.name;
        cell.detailTextLabel.text = @"";
    }
    else if (indexPath.section == 0) {
        Recipe *recipe = [self.favoriteRecipes objectAtIndex:indexPath.row];
        cell.textLabel.text = recipe.name;
        cell.detailTextLabel.text = @"";
    }

    return cell;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeFavorites) {
        return [self:tableView getFavoritesCell:indexPath];
    }

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
    if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeFavorites) {
        [self performSegueWithIdentifier:@"Recipe Type Segue" 
                                  sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else if (self.foodTypeSegmentControl.selectedSegmentIndex == kFoodTypeRecipes) {
        [self performSegueWithIdentifier:@"Recipe Type Segue" 
                                  sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!appDelegate.zipCode || [@"" isEqualToString:appDelegate.zipCode]) {
            
            [UIAlertView showAlertViewWithTitle:@"Zip Code" 
                                        message:@"Please enter zip code" 
                              cancelButtonTitle:@"Cancel" 
                              otherButtonTitles:[NSArray arrayWithObject:@"OK"] 
                                      onDismiss:^(NSString *text) {
                                          appDelegate.userSpecifiedCode = text;
                                          [self performSegueWithIdentifier:@"Restaurant Type Segue" 
                                                                    sender:[tableView cellForRowAtIndexPath:indexPath]];
                                      } 
                                       onCancel:^{
                                           [self.foodTypesTableView deselectRowAtIndexPath:indexPath animated:YES];
                                       }];
        }
        else {
            [self performSegueWithIdentifier:@"Restaurant Type Segue" 
                                      sender:[tableView cellForRowAtIndexPath:indexPath]];
        }
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
