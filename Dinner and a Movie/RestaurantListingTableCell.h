//
//  RestaurantListingTableCell.h
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantListingTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *restaurantImage;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UILabel *reviewsLabel;

@end
