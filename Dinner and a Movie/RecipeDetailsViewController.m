//
//  RecipeDetailsViewController.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeDetailsViewController.h"

#import "RecipeIngredient.h"
#import "RecipeDirection.h"

#import "PearsonFetcher.h"

#import "AppDelegate.h"
#import "ScheduledEventLibrary.h"

#import "SVProgressHUD.h"

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
    
    //self.title = self.recipe.name;
    [SVProgressHUD showWithStatus:@"Downloading recipe"];
    [PearsonFetcher loadFullRecipe:self.recipe onCompletion:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipe = data;
            [self.recipeWebview loadHTMLString:[self recipeAsHtml] baseURL:nil];
            [SVProgressHUD dismiss];
        });
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithError:error.localizedDescription];
        });
    }];
}

- (void)viewDidUnload
{
    [self setRecipeWebview:nil];
    [self setRecipe:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)recipeAsHtml
{
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<html>"];
    if (self.recipe) {
        [html appendFormat:@"<head><title>%@</title><style>#thumbnail img {float: left;} #thumbnail span.title {float: right; font-weight: bold; text-align: right;} #thumbnail span.header {font-weight: bold: text-align: center;} div#stats {clear: both;}</style></head>", self.recipe.name];
        [html appendString:@"<body>"];
        if (self.recipe.thumbnailUrl && [self.recipe.thumbnailUrl isKindOfClass:[NSString class]]) {
            [html appendFormat:@"<div id='thumbnail'><img src='%@'/><span class='title'>%@</span></div>", 
                self.recipe.thumbnailUrl, self.recipe.name];
        }
        else {
            [html appendFormat:@"<div id='thumbnail'><span class='header'>%@</span></div>", self.recipe.name];
        }
        
        [html appendFormat:@"<div id='stats'><h5>Information</h5><ul><li>serves: %d</li><li>yields: %@</li><li>cost: %.2f</li></ul></div>", 
            self.recipe.serves, 
            self.recipe.yields, 
            self.recipe.cost];
        [html appendString:@"<div id='ingredients'><h5>Ingredients</h5><ul>"];
        [self.recipe.ingredients enumerateObjectsUsingBlock:^(RecipeIngredient *ingredient, NSUInteger idx, BOOL *stop) {
            if (ingredient.quantity)
                [html appendFormat:@"<li>%@ %@ - %@</li>", ingredient.quantity, ingredient.unit, ingredient.name];
            else
                [html appendFormat:@"<li>%@ %@</li>", ingredient.name, ingredient.unit];
        }];
        
        [html appendString:@"</ul></div><div id='directions'><h5>Directions</h5><ol>"];
        [self.recipe.directions enumerateObjectsUsingBlock:^(RecipeDirection *direction, NSUInteger idx, BOOL *stop) {
            if ([@"" isEqualToString:direction.instruction])
                [html appendFormat:@"</ol><ol>", direction.instruction];
            else                 
                [html appendFormat:@"<li>%@</li>", direction.instruction];
        }];
        
        [html appendString:@"</ol></div>"];
        [html appendString:@"</body>"];
    }
    else {
        [html appendString:@"<body>No recipe found</body>"];
    }
    [html appendString:@"</html>"];
    NSLog(@"%@", html);
    return [html copy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Recipe Segue"]) {
        [(AddRecipeToScheduleViewController *)segue.destinationViewController setDelegate:self];
    }
}

- (void)add:(AddRecipeToScheduleOptions *)options sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScheduledEventLibrary *library = appDelegate.eventLibrary;
    options.recipe = self.recipe;
    [library addRecipeEventToSchedule:options];
    
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
