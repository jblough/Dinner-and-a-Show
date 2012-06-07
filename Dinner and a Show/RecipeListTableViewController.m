//
//  RecipeListTableViewController.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeListTableViewController.h"
#import "RecipeDetailsViewController.h"
#import "RecipeSearchViewController.h"
#import "RecipeListingTableCell.h"
#import "RecipeViewController.h"

#import "SVProgressHUD.h"
#import "AppDelegate.h"

#import "PearsonFetcher.h"

#import "Recipe.h"

@interface RecipeListTableViewController ()

@property (nonatomic, strong) NSMutableArray *recipes;
@property (nonatomic, strong) NSMutableSet *favorites;
@property (nonatomic, strong) RecipeSearchCriteria *criteria;

@end

@implementation RecipeListTableViewController

@synthesize cuisine = _cuisine;
@synthesize recipes = _recipes;
@synthesize favorites = _favorites;
@synthesize criteria = _criteria;

- (NSMutableArray *)recipes
{
    if (!_recipes) _recipes = [[NSMutableArray alloc] init];
    return _recipes;
}
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)doRefresh
{
    self.loading = NO;
    /*[SVProgressHUD showWithStatus:@"Downloading recipes"];
    [PearsonFetcher recipesForCuisine:self.cuisine onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recipes addObjectsFromArray:data];
            NSLog(@"doRefresh - Adding %d recipes", [data count]);
            self.loading = NO;
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithError:error.localizedDescription];
        });
    }];*/
}

- (void)loadMore
{
    int page = (int)([self.recipes count] / kRecipePageSize);
    [PearsonFetcher recipesForCuisine:self.cuisine page:page onCompletion:^(id data) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recipes addObjectsFromArray:data];

            NSLog(@"comparing %d to %d", [self.recipes count], self.cuisine.recipeCount);
            if ([self.recipes count] == self.cuisine.recipeCount) self.endReached = YES;
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.cuisine.name;
    
    self.numberOfSections = 1;

    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.favorites = [NSMutableSet setWithSet:[appDelete.eventLibrary getFavoriteRecipes]];
    
    //[self loadMore];
    //[self doRefresh];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.numberOfSections) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return [self.recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.numberOfSections) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"Recipe List Cell";
    RecipeListingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Recipe *recipe = [self.recipes objectAtIndex:indexPath.row];
    cell.nameLabel.text = recipe.name;

    if ([self.favorites containsObject:recipe.identifier]) {
        [cell.favoriteImageButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.favoriteImageButton setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (IBAction)toggleFavoriteStatus:(UIButton *)sender forEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:[touch locationInView:self.tableView]];
    Recipe *recipe = [self.recipes objectAtIndex:path.row];
    AppDelegate *appDelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.favorites containsObject:recipe.identifier]) {
        [self.favorites removeObject:recipe.identifier];
        [sender setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
        
        [appDelete.eventLibrary unfavoriteRecipe:recipe];
    }
    else {
        [self.favorites addObject:recipe.identifier];
        [sender setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
        
        [appDelete.eventLibrary favoriteRecipe:recipe];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Recipe Selection Segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        /*[(RecipeDetailsViewController *)segue.destinationViewController setRecipe:[self.recipes objectAtIndex:indexPath.row]];*/
        [(RecipeViewController *)segue.destinationViewController setRecipe:[self.recipes objectAtIndex:indexPath.row]];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([segue.identifier isEqualToString:@"Recipe Search Segue"]) {
        RecipeSearchViewController *newController = (RecipeSearchViewController *)segue.destinationViewController;
        [newController setDelegate:self];
        newController.cuisine = self.cuisine;
    }
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)search:(RecipeSearchCriteria *)criteria sender:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];

    self.criteria = criteria;
    
    [self.recipes removeAllObjects];
    [self.tableView reloadData];
    
    // If the search criteria was removed, reset to the cuisine
    if ((!criteria.nameFilter || [@"" isEqualToString:criteria.nameFilter]) &&
        (!criteria.ingredientFilter || [@"" isEqualToString:criteria.ingredientFilter]) &&
        criteria.filterCuisine) {
            // Reset to the passed in cuisine 
        //[self loadMore];
        self.endReached = NO;
        [self.tableView reloadData];
    }
    else {
        int page = 0;//(int)([self.recipes count] / kRecipePageSize);
        [PearsonFetcher recipesForCuisine:self.cuisine search:criteria page:page onCompletion:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recipes addObjectsFromArray:data];
                
                NSLog(@"comparing %d to %d", [self.recipes count], self.cuisine.recipeCount);
                /*if ([self.recipes count] == self.cuisine.recipeCount)*/ self.endReached = YES;
                [self.tableView reloadData];
            });
        } onError:^(NSError *error) {
            NSLog(@"Error - %@", error.localizedDescription);
        }];
    }
}

- (RecipeSearchCriteria *)getCriteria
{
    return self.criteria;
}

@end
