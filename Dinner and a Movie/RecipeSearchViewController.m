//
//  RecipeSearchViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeSearchViewController.h"

@interface RecipeSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameSearchField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientSearchField;
@end

@implementation RecipeSearchViewController
@synthesize nameSearchField = _nameSearchField;
@synthesize ingredientSearchField = _ingredientSearchField;
@synthesize delegate = _delegate;

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
}

- (void)viewDidUnload
{
    [self setNameSearchField:nil];
    [self setIngredientSearchField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (IBAction)done:(id)sender
{
    RecipeSearchCriteria *criteria = [[RecipeSearchCriteria alloc] init];
    criteria.nameFilter = self.nameSearchField.text;
    criteria.ingredientFilter = self.ingredientSearchField.text;
                                
    [self.delegate search:criteria sender:self];
}

@end
