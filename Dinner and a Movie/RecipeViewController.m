//
//  RecipeViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipeHeadingCell.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "PearsonFetcher.h"

#define kHeadingSection 0
#define kIngredientsSection 1
#define kDirectionsSection 2

@interface RecipeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RecipeViewController
@synthesize tableView = _tableView;
@synthesize recipe = _recipe;
@synthesize originalEvent = _originalEvent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"Downloading recipe"];
    [PearsonFetcher loadFullRecipe:self.recipe onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipe = data;
            //[self.recipeWebview loadHTMLString:[self recipeAsHtml] baseURL:nil];
            [SVProgressHUD dismiss];
            
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithError:error.localizedDescription];
        });
    }];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3; // Heading/Information, Ingredients, Directions
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kHeadingSection:
            return self.recipe.name;
            break;
            
        case kIngredientsSection:
            return @"Ingredients";
            break;

        case kDirectionsSection:
            return @"Directions";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kHeadingSection:
            return 1;
            break;

        case kIngredientsSection:
            return [self.recipe.ingredients count];
            break;

        case kDirectionsSection:
            return [self.recipe.directions count];
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView populateInformationCell:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recipe Details Heading Cell";

    RecipeHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    /*if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }*/
    
    cell.nameLabel.text = @"";//self.recipe.name;
    if (!self.recipe.serves) {
        cell.servesLabel.text = @"";
        cell.yieldsLabel.text = @"";
        cell.costLabel.text = @"";
    }
    else {
        cell.servesLabel.text = [NSString stringWithFormat:@"Serves: %d", self.recipe.serves];
        cell.yieldsLabel.text = [NSString stringWithFormat:@"Yields: %@", self.recipe.yields];
        cell.costLabel.text = [NSString stringWithFormat:@"Costs: %.2f", self.recipe.cost];
        
        if (self.recipe.thumbnailUrl) {
            [cell.recipeImage setImageWithURL:[NSURL URLWithString:self.recipe.thumbnailUrl]
                             placeholderImage:[UIImage imageNamed:@"restaurant_placeholder.png"]];
        }
        else {
            [cell.recipeImage setImage:[UIImage imageNamed:@"blank.gif"]];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView populateInformationCell:indexPath];
    }
        
    static NSString *CellIdentifier = @"Recipe Details Item Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;

    
    if (indexPath.section == kIngredientsSection) {
        RecipeIngredient *ingredient = [self.recipe.ingredients objectAtIndex:indexPath.row];
        if (ingredient.quantity)
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", ingredient.quantity, ingredient.unit, ingredient.name];
        else
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", ingredient.name, ingredient.unit];
    }
    else if (indexPath.section == kDirectionsSection) {
        RecipeDirection *direction = [self.recipe.directions objectAtIndex:indexPath.row];
        cell.textLabel.text = direction.instruction;
    }
               
    CGSize s = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cell.textLabel.frame.size.width, 500)];
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 
                                      cell.textLabel.frame.size.height, s.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGFloat width = tableView.frame.size.width - 20;
    static NSString *CellIdentifier = @"Recipe Details Item Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    width = cell.textLabel.frame.size.width;
    
    //return (indexPath.section == kHeadingSection) ? 140 : 30;
    switch (indexPath.section) {
        case kHeadingSection:
            return 140;
            break;
        case kIngredientsSection:
        {
            RecipeIngredient *ingredient = [self.recipe.ingredients objectAtIndex:indexPath.row];
            CGSize s = [ingredient.name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width, 500)];
            return MAX(s.height + cell.textLabel.frame.origin.y + 11, 30);
        }
            break;
        case kDirectionsSection:
        {
            RecipeDirection *direction = [self.recipe.directions objectAtIndex:indexPath.row];
            CGSize s = [direction.instruction sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width, 500)];
            return MAX(s.height + cell.textLabel.frame.origin.y + 11, 30);
        }
            break;
        default:
            return 30;
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Recipe Segue"]) {
        UINavigationController *navController = segue.destinationViewController;
        [(AddRecipeToScheduleViewController *)navController.topViewController setDelegate:self];
        if (self.originalEvent)
            [(AddRecipeToScheduleViewController *)navController.topViewController setOriginalEvent:self.originalEvent];
    }
}

- (void)add:(AddRecipeToScheduleOptions *)options sender:(id)sender
{
    // Delete the original event
    [self.originalEvent deleteEvent];
    
    // Add the new event
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.recipe = self.recipe;
    [library addRecipeEventToSchedule:options];
    
    // Add to calendar
    if (options.reminder) {
        CalendarEvent *event = [[CalendarEvent alloc] init];
        event.eventId = [NSString stringWithFormat:@"%@ - %@", self.recipe.identifier, options.when];
        event.type = @"recipe";
        event.identifier = self.recipe.identifier;
        event.title = self.recipe.name;
        event.startDate = options.when;
        event.reminder = options.reminder;
        event.minutesBefore = options.minutesBefore;
        [appDelegate addToCalendar:event];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
