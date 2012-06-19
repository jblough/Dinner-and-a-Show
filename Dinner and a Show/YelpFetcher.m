//
//  YelpFetcher.m
//  Dinner and a Show
//
//  Created by Joe Blough on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YelpFetcher.h"
#import "ApiKeys.h"
#import "OAuthConsumer2007.h"
#import "AppDelegate.h"
#import "Restaurant+Json.h"

#import "NSString+URLEncoding.h"

#define kSortBestMatch 0
#define kSortDistance 1
#define kSortHightestRated 2

#define kMetersPerMile 1600

@interface YelpFetcher ()

@end

@implementation YelpFetcher
+ (OAMutableURLRequest2007 *)generateRequest:(NSString *)url
{
    OAConsumer2007 *consumer = [[OAConsumer2007 alloc] initWithKey:kYelpConsumerKey secret:kYelpConsumerSecret];
    OAToken2007 *token = [[OAToken2007 alloc] initWithKey:kYelpToken secret:kYelpTokenSecret];
    
    id<OASignatureProviding2007, NSObject> provider = [[OAHMAC_SHA1SignatureProvider2007 alloc] init];
    NSString *realm = nil;  
    
    OAMutableURLRequest2007 *request = [[OAMutableURLRequest2007 alloc] initWithURL:[NSURL URLWithString:url]
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    return request;
}

+ (void)retrieve:(NSString *)url onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"com.josephblough.dinner.yelpfetcher";
    [NSURLConnection sendAsynchronousRequest:[YelpFetcher generateRequest:url]
                                       queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            onError(error);
        }
        else {
            //onCompletion(data);
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), jsonError.localizedDescription);
                onError(jsonError);   
            }
            else {
                int statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode == 200) {
                    onCompletion(json);
                }
                else {
                    NSDictionary *info = ([json objectForKey:@"error"]) ? [json objectForKey:@"error"] : json;
                    onError([NSError errorWithDomain:@"Yelp Error" code:statusCode userInfo:info]);
                }
            }
        }
    }];
}

+ (void)parseData:(NSDictionary *)json onCompletion:(CompletionHandler)onCompletion
{
    NSMutableArray *restaurants = [NSMutableArray array];
    
    NSArray *jsonRestaurants = [json objectForKey:@"businesses"];
    [jsonRestaurants enumerateObjectsUsingBlock:^(id jsonRestaurant, NSUInteger idx, BOOL *stop) {
        [restaurants addObject:[Restaurant restaurantFromJson:jsonRestaurant]];
    }];
    onCompletion([restaurants copy]);
}

+ (void)restaurantsForCuisine:(Cuisine *)cuisine onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=%@&sort=%d&location=%@",
                           cuisine.identifier,
                           kSortBestMatch,
                           (appDelegate.userSpecifiedCode) ? appDelegate.userSpecifiedCode : appDelegate.zipCode];
    NSLog(@"for cuisine url: %@", urlString);
    
    [YelpFetcher retrieve:urlString onCompletion:^(id data) {
        [YelpFetcher parseData:data onCompletion:onCompletion];
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)restaurantsForCuisine:(Cuisine *)cuisine page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    int start = page * kRestaurantPageSize;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=%@&sort=%d&location=%@&offset=%d&limit=%d",
                           cuisine.identifier,
                           kSortBestMatch,
                           (appDelegate.userSpecifiedCode) ? appDelegate.userSpecifiedCode : appDelegate.zipCode,
                           start, kRestaurantPageSize];
    NSLog(@"paged url: %@", urlString);
    
    [YelpFetcher retrieve:urlString onCompletion:^(id data) {
        [YelpFetcher parseData:data onCompletion:onCompletion];
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)restaurantsForCuisine:(Cuisine *)cuisine search:(RestaurantSearchCriteria *)criteria page:(int)page onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSString *urlEncodedSearch = @"";
    CLLocation *location;
    if (!criteria.useCurrentLocation && criteria.location) {
        location = criteria.location;
    }
    else {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        location = appDelegate.coordinate;
    }
    urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&latitude=%.6f&longitude=%.6f", 
                        location.coordinate.latitude, location.coordinate.longitude];
    
    if (criteria.searchTerm && ![@"" isEqualToString:criteria.searchTerm]) {
        urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&term=%@", [criteria.searchTerm encodedURLString]];
    }
        
    int start = page * kRestaurantPageSize;
    urlEncodedSearch = [urlEncodedSearch stringByAppendingFormat:@"&offset=%d&limit=%d", start, kRestaurantPageSize];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=%@&sort=%d%@",
                           cuisine.identifier,
                           kSortBestMatch, urlEncodedSearch];
    NSLog(@"search url: %@", urlString);
    [YelpFetcher retrieve:urlString onCompletion:^(id data) {
        [YelpFetcher parseData:data onCompletion:onCompletion];
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)loadFullRestaurant:(Restaurant *)restaurant onCompletion:(CompletionHandler)onCompletion onError:(ErrorHandler)onError
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/business/%@",
                           [restaurant.identifier encodedURLString]];
    NSLog(@"load full restaurant url: %@", urlString);
    
    [YelpFetcher retrieve:urlString onCompletion:^(id data) {
        NSLog(@"Data: %@", data);
        onCompletion([Restaurant restaurantFromJson:data]);
    } onError:^(NSError *error) {
        onError(error);
    }];
}

+ (void)cuisines:(CompletionHandler) onCompletion onError:(ErrorHandler) onError
{
    NSMutableArray *tempCuisines = [[NSMutableArray alloc] initWithCapacity:90];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"All Restaurants" identifier:@"restaurants"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Afghan" identifier:@"afghani"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"African" identifier:@"african"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"American (New)" identifier:@"newamerican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"American (Traditional)" identifier:@"tradamerican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Argentine" identifier:@"argentine"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Asian Fusion" identifier:@"asianfusion"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Barbeque" identifier:@"bbq"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Basque" identifier:@"basque"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Belgian" identifier:@"belgian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Brasseries" identifier:@"brasseries"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Brazilian" identifier:@"brazilian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Breakfast & Brunch" identifier:@"breakfast_brunch"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"British" identifier:@"british"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Buffets" identifier:@"buffets"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Burgers" identifier:@"burgers"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Burmese" identifier:@"burmese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cafes" identifier:@"cafes"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cajun/Creole" identifier:@"cajun"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cambodian" identifier:@"cambodian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Caribbean" identifier:@"caribbean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cheesesteaks" identifier:@"cheesesteaks"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Chicken Wings" identifier:@"chicken_wings"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Chinese" identifier:@"chinese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Dim Sum" identifier:@"dimsum"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Szechuan" identifier:@"szechuan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Creperies" identifier:@"creperies"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Cuban" identifier:@"cuban"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Delis" identifier:@"delis"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Diners" identifier:@"diners"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ethiopian" identifier:@"ethiopian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fast Food" identifier:@"hotdogs"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Filipino" identifier:@"filipino"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fish & Chips" identifier:@"fishnchips"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Fondue" identifier:@"fondue"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Food Stands" identifier:@"foodstands"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"French" identifier:@"french"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Gastropubs" identifier:@"gastropubs"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"German" identifier:@"german"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Gluten-Free" identifier:@"gluten_free"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Greek" identifier:@"greek"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Halal" identifier:@"halal"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hawaiian" identifier:@"hawaiian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Himalayan/Nepalese" identifier:@"himalayan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hot Dogs" identifier:@"hotdog"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Hungarian" identifier:@"hungarian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Indian" identifier:@"indpak"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Indonesian" identifier:@"indonesian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Irish" identifier:@"irish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Italian" identifier:@"italian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Japanese" identifier:@"japanese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Korean" identifier:@"korean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Kosher" identifier:@"kosher"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Latin American" identifier:@"latin"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Live/Raw Food" identifier:@"raw_food"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Malaysian" identifier:@"malaysian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mediterranean" identifier:@"mediterranean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mexican" identifier:@"mexican"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Middle Eastern" identifier:@"mideastern"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Modern European" identifier:@"modern_european"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Mongolian" identifier:@"mongolian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Moroccan" identifier:@"moroccan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pakistani" identifier:@"pakistani"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Persian/Iranian" identifier:@"persian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Peruvian" identifier:@"peruvian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Pizza" identifier:@"pizza"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Polish" identifier:@"polish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Portuguese" identifier:@"portuguese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Russian" identifier:@"russian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Salad" identifier:@"salad"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Sandwiches" identifier:@"sandwiches"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Scandinavian" identifier:@"scandinavian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Seafood" identifier:@"seafood"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Singaporean" identifier:@"singaporean"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Soul Food" identifier:@"soulfood"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Soup" identifier:@"soup"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Southern" identifier:@"southern"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Spanish" identifier:@"spanish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Steakhouses" identifier:@"steak"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Sushi Bars" identifier:@"sushi"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Taiwanese" identifier:@"taiwanese"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tapas Bars" identifier:@"tapas"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tapas/Small Plates" identifier:@"tapasmallplates"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Tex-Mex" identifier:@"tex-mex"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Thai" identifier:@"thai"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Turkish" identifier:@"turkish"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Ukrainian" identifier:@"ukrainian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vegan" identifier:@"vegan"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vegetarian" identifier:@"vegetarian"]];
    [tempCuisines addObject:[[Cuisine alloc] initWithName:@"Vietnamese" identifier:@"vietnamese"]];
    
    onCompletion([tempCuisines copy]);
}

@end
