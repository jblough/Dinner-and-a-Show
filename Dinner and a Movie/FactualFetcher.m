//
//  FactualFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FactualFetcher.h"
#import "AppDelegate.h"
#import "ApiKeys.h"
#import "Restaurant+FactualRow.h"

#define kMetersPerMile 1600
#define kAllRestaurantsIdentifier @"ALL"

@interface FactualFetcher()

@property (nonatomic, strong) FactualAPI *api;
@property (nonatomic, strong) FactualAPIRequest *request;

@property (nonatomic, strong) CompletionHandler onComplete;
@property (nonatomic, strong) ErrorHandler onError;

@end


@implementation FactualFetcher
@synthesize api = _api;
@synthesize request = _request;
@synthesize onComplete = _onComplete;
@synthesize onError = _onError;

- (FactualAPI *)api
{
    if (!_api) _api = [[FactualAPI alloc] initWithAPIKey:kFactualKey secret:kFactualSecret];
    return _api;
}

- (void)cuisines:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSMutableArray *tempCuisines = [[NSMutableArray alloc] initWithCapacity:135];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"All Restaurants" identifier:kAllRestaurantsIdentifier]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Afghan" identifier:@"Afghan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"American" identifier:@"American"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Argentine" identifier:@"Argentine"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Asian" identifier:@"Asian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Austrian" identifier:@"Austrian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Bagels" identifier:@"Bagels"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Bakery" identifier:@"Bakery"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Barbecue" identifier:@"Barbecue"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Belgian" identifier:@"Belgian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Bistro" identifier:@"Bistro"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Brazilian" identifier:@"Brazilian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"British" identifier:@"British"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Buffet" identifier:@"Buffet"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Burgers" identifier:@"Burgers"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cafe" identifier:@"Cafe"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cajun" identifier:@"Cajun"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Californian" identifier:@"Californian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Calzones" identifier:@"Calzones"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cambodian" identifier:@"Cambodian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Caribbean" identifier:@"Caribbean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Catering" identifier:@"Catering"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cheesesteaks" identifier:@"Cheesesteaks"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Chicken" identifier:@"Chicken"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Chinese" identifier:@"Chinese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Chowder" identifier:@"Chowder"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Coffee" identifier:@"Coffee"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Colombian" identifier:@"Colombian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Contemporary" identifier:@"Contemporary"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Continental" identifier:@"Continental"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Creole" identifier:@"Creole"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Crepes" identifier:@"Crepes"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cuban" identifier:@"Cuban"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Czech" identifier:@"Czech"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Deli" identifier:@"Deli"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Dim Sum" identifier:@"Dim Sum"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Diner" identifier:@"Diner"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Dominican" identifier:@"Dominican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Donuts" identifier:@"Donuts"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Eastern European" identifier:@"Eastern European"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Eclectic" identifier:@"Eclectic"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"English" identifier:@"English"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ethiopian" identifier:@"Ethiopian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"European" identifier:@"European"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fast Food" identifier:@"Fast Food"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Filipino" identifier:@"Filipino"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fish and Chips" identifier:@"Fish and Chips"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fondue" identifier:@"Fondue"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"French" identifier:@"French"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Frozen Yogurt" identifier:@"Frozen Yogurt"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fusion" identifier:@"Fusion"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Gastropub" identifier:@"Gastropub"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"German" identifier:@"German"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Greek" identifier:@"Greek"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Grill" identifier:@"Grill"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Gyros" identifier:@"Gyros"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Haitian" identifier:@"Haitian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Halal" identifier:@"Halal"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hawaiian" identifier:@"Hawaiian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Healthy" identifier:@"Healthy"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hookah Bar" identifier:@"Hookah Bar"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hot Dogs" identifier:@"Hot Dogs"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ice Cream" identifier:@"Ice Cream"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Indian" identifier:@"Indian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Indonesian" identifier:@"Indonesian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"International" identifier:@"International"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Irish" identifier:@"Irish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Israeli" identifier:@"Israeli"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Italian" identifier:@"Italian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Japanese" identifier:@"Japanese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Juices" identifier:@"Juices"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Korean" identifier:@"Korean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Korean Barbeque" identifier:@"Korean Barbeque"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Kosher" identifier:@"Kosher"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Latin" identifier:@"Latin"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Latin American" identifier:@"Latin American"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Lebanese" identifier:@"Lebanese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Malaysian" identifier:@"Malaysian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mediterranean" identifier:@"Mediterranean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mexican" identifier:@"Mexican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Middle Eastern" identifier:@"Middle Eastern"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mongolian" identifier:@"Mongolian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Moroccan" identifier:@"Moroccan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Nepalese" identifier:@"Nepalese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Noodle Bar" identifier:@"Noodle Bar"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Norwegian" identifier:@"Norwegian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Organic" identifier:@"Organic"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Oysters" identifier:@"Oysters"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pacific Rim" identifier:@"Pacific Rim"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pakistani" identifier:@"Pakistani"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pan Asian" identifier:@"Pan Asian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pasta" identifier:@"Pasta"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pasteries" identifier:@"Pasteries"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Persian" identifier:@"Persian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Peruvian" identifier:@"Peruvian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pho" identifier:@"Pho"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pizza" identifier:@"Pizza"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Polish" identifier:@"Polish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Polynesian" identifier:@"Polynesian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Portuguese" identifier:@"Portuguese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pub Food" identifier:@"Pub Food"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Puerto Rican" identifier:@"Puerto ]Rican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ribs" identifier:@"Ribs"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Salad" identifier:@"Salad"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Salvadoran" identifier:@"Salvadoran"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Sandwiches" identifier:@"Sandwiches"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Seafood" identifier:@"Seafood"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Singaporean" identifier:@"Singaporean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Smoothies" identifier:@"Smoothies"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Soul Food" identifier:@"Soul Food"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Soup" identifier:@"Soup"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"South American" identifier:@"South American"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"South Pacific" identifier:@"South Pacific"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Southern" identifier:@"Southern"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Southwestern" identifier:@"Southwestern"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Spanish" identifier:@"Spanish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Steak" identifier:@"Steak"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Subs" identifier:@"Subs"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Sushi" identifier:@"Sushi"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Taiwanese" identifier:@"Taiwanese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tapas" identifier:@"Tapas"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tea" identifier:@"Tea"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tex Mex" identifier:@"Tex Mex"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Thai" identifier:@"Thai"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tibetan" identifier:@"Tibetan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Traditional" identifier:@"Traditional"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Turkish" identifier:@"Turkish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ukrainian" identifier:@"Ukrainian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vegan" identifier:@"Vegan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vegetarian" identifier:@"Vegetarian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Venezuelan" identifier:@"Venezuelan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Venusian" identifier:@"Venusian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vietnamese" identifier:@"Vietnamese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Wings" identifier:@"Wings"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Wraps" identifier:@"Wraps"]];
 
    onCompletion(tempCuisines);
}

- (void)restaurantsForCuisine:(Cuisine *)cuisine page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    self.onComplete = onCompletion;
    self.onError = onError;
    
    FactualQuery* queryObject = [FactualQuery query];
    
    // set limit
    queryObject.offset = (page * kFactualRestaurantPageSize);
    queryObject.limit = kFactualRestaurantPageSize;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.zipCode) { 
        // set geo location and filter
        [queryObject setGeoFilter:appDelegate.coordinate 
                   radiusInMeters:(10 * kMetersPerMile)];
    }
    
    if (![kAllRestaurantsIdentifier isEqualToString:cuisine.identifier])
        [queryObject addRowFilter:[FactualRowFilter fieldName:@"cuisine" equalTo:cuisine.identifier]];
    
    self.request = [self.api queryTable:@"restaurants-us" optionalQueryParams:queryObject withDelegate:self];
    
    //NSString *url = @"http://api.v3.factual.com/t/restaurants-us?filters={\"name\":{\"$bw\":\"Star\"}}";
    
}

- (void)restaurantsForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    
}

- (void)restaurantsForCuisine:(Cuisine *)cuisine search:(RestaurantSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    
}

- (void)loadFullRestaurant:(Restaurant *)restaurant onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    
}

#pragma mark -
#pragma mark FactualAPIDelegate methods

- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request
{
    
}

- (void)requestDidReceiveData:(FactualAPIRequest *)request
{
    
}

- (void)requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error
{
    self.onError(error);
}

- (void)requestComplete:(FactualAPIRequest*) request receivedQueryResult:(FactualQueryResult*) queryResult
{
    NSMutableArray *restaurants = [NSMutableArray array];
    
    if (queryResult) {
        [queryResult.rows enumerateObjectsUsingBlock:^(FactualRow *row, NSUInteger idx, BOOL *stop) {
            if (row) {
                Restaurant *restaurant = [Restaurant restaurantFromRow:row];
                [restaurants addObject:restaurant];
            }
        }];
    }
    self.onComplete(restaurants);
}


@end
