//
//  RecipeSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeSearchViewController.h"

#define SELECTED_CUISINE_INDEX 0
#define ALL_CUISINES_INDEX 1

@interface RecipeSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameSearchField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientSearchField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterOnCuisineSegmented;
@property (weak, nonatomic) IBOutlet UILabel *selectedCuisineLabel;

@end

@implementation RecipeSearchViewController
@synthesize nameSearchField = _nameSearchField;
@synthesize ingredientSearchField = _ingredientSearchField;
@synthesize filterOnCuisineSegmented = _filterOnCuisineSegmented;
@synthesize selectedCuisineLabel = _selectedCuisineLabel;
@synthesize delegate = _delegate;
@synthesize cuisine = _cuisine;

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
    
    self.nameSearchField.text = [self.delegate getCriteria].nameFilter;
    self.ingredientSearchField.text = [self.delegate getCriteria].ingredientFilter;
    self.filterOnCuisineSegmented.selectedSegmentIndex = (![self.delegate getCriteria] || 
                                                          [self.delegate getCriteria].filterCuisine) ?
        SELECTED_CUISINE_INDEX : ALL_CUISINES_INDEX;
    
    self.selectedCuisineLabel.text = [NSString stringWithFormat:@"Selected Cuisine: %@", self.cuisine.name];
}

- (void)viewDidUnload
{
    [self setNameSearchField:nil];
    [self setIngredientSearchField:nil];
    [self setFilterOnCuisineSegmented:nil];
    [self setSelectedCuisineLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched
{
    if ([self.nameSearchField isFirstResponder])
        [self.nameSearchField resignFirstResponder];
    
    if ([self.ingredientSearchField isFirstResponder])
        [self.ingredientSearchField resignFirstResponder];
}

- (IBAction)cancel
{
    [self.delegate cancel];
}

- (IBAction)done:(id)sender
{
    RecipeSearchCriteria *criteria = [[RecipeSearchCriteria alloc] init];
    criteria.nameFilter = self.nameSearchField.text;
    criteria.ingredientFilter = self.ingredientSearchField.text;
    criteria.filterCuisine = (self.filterOnCuisineSegmented.selectedSegmentIndex == SELECTED_CUISINE_INDEX);
                                
    [self.delegate search:criteria sender:self];
}

@end
