//
//  RecipeDetailsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "PearsonFetcher.h"
#import "RecipeIngredient.h"

@interface RecipeDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *recipeWebview;
- (NSString *)recipeAsHtml;

@end

@implementation RecipeDetailsViewController
@synthesize recipeWebview = _recipeWebview;

@synthesize recipe = _recipe;

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
    
    self.title = self.recipe.name;
    self.recipe = [PearsonFetcher loadFullRecipe:self.recipe];
    [self.recipeWebview loadHTMLString:[self recipeAsHtml] baseURL:nil];
}

- (void)viewDidUnload
{
    [self setRecipeWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)recipeAsHtml
{
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<html>"];
    if (self.recipe) {
        [html appendFormat:@"<head><title>%@</title><style>#thumbnail {text-align: center;}</style></head>", self.recipe.name];
        [html appendString:@"<body>"];
        if (self.recipe.thumbnameUrl)
            [html appendFormat:@"<div id='thumbnail'><img src='%@'/></div>", self.recipe.thumbnameUrl];
        
        [html appendFormat:@"<div id='stats'><h5>Information</h5><ul><li>serves: %d</li><li>yields: %@</li><li>cost: %.2f</li></ul></div>", 
            self.recipe.serves, 
            self.recipe.yields, 
            self.recipe.cost];
        [html appendString:@"<div id='ingredients'><h5>Ingredients</h5><ul>"];
        for (RecipeIngredient *ingredient in self.recipe.ingredients) {
            [html appendFormat:@"<li>%@ %@ - %@</li>", ingredient.quantity, ingredient.unit, ingredient.name];
        }
        [html appendString:@"</ul></div><div id='directions'><h5>Directions</h5><ol>"];
        for (NSString *direction in self.recipe.directions) {
            [html appendFormat:@"<li>%@</li>", direction];
        }
        [html appendString:@"</ol></div>"];
        [html appendString:@"</body>"];
    }
    else {
        [html appendString:@"<body>No recipe found</body>"];
    }
    [html appendString:@"</html>"];
    return [html copy];
}

@end
