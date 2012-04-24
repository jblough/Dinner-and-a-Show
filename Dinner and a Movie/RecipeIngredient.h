//
//  RecipeIngredient.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeIngredient : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property int quantity;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *preparation;

@end
