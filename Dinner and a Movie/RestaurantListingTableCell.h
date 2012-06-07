//
//  RestaurantListingTableCell.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface RestaurantListingTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage1;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage2;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage3;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage4;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage5;

- (void)displayRestaurant:(Restaurant *)restaurant isFavorite:(BOOL)isFavorite;

@end
