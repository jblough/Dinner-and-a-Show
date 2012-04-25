//
//  RecipeDetailsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "PearsonFetcher.h"

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
        [html appendFormat:@"<head><title>%@</title></head>", self.recipe.name];
        [html appendString:@"<body>"];
        [html appendFormat:@"Recipe for %@", self.recipe.name];
        [html appendString:@"</body>"];
    }
    else {
        [html appendString:@"<body>No recipe found</body>"];
    }
    [html appendString:@"</html>"];
    return [html copy];
}

@end
