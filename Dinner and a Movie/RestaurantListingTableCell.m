//
//  RestaurantListingTableCell.m
//  Dinner and a Movie
//
//  Created by Joe Blough on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantListingTableCell.h"
#import "UIImageView+WebCache.h"

@implementation RestaurantListingTableCell

@synthesize nameLabel = _nameLabel;
@synthesize restaurantImage = _restaurantImage;
@synthesize favoriteButton = _favoriteButton;
@synthesize ratingsLabel = _ratingsLabel;
@synthesize ratingImage1 = _ratingImage1;
@synthesize ratingImage2 = _ratingImage2;
@synthesize ratingImage3 = _ratingImage3;
@synthesize ratingImage4 = _ratingImage4;
@synthesize ratingImage5 = _ratingImage5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRatingImages:(float)rating
{
    // Handle whole stars
    if (rating >= 1) {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 2) {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 3) {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 4) {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    if (rating >= 5) {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    else {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"unfavorite.png"]];
    }
    
    // Handle 1/2 stars
    if (rating == 4.5) {
        [self.ratingImage5 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 3.5) {
        [self.ratingImage4 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 2.5) {
        [self.ratingImage3 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 1.5) {
        [self.ratingImage2 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
    else if (rating == 0.5) {
        [self.ratingImage1 setImage:[UIImage imageNamed:@"half_star.png"]];
    }
}

- (void)displayRestaurant:(Restaurant *)restaurant isFavorite:(BOOL)isFavorite
{
    self.nameLabel.text = restaurant.name;
    self.ratingsLabel.text = [NSString stringWithFormat:@"rating %.1f", restaurant.rating];
    
    if (restaurant.imageUrl) {
        [self.restaurantImage setImageWithURL:[NSURL URLWithString:restaurant.imageUrl]
                             placeholderImage:[UIImage imageNamed:@"restaurant_placeholder.png"]];
    }
    else {
        [self.restaurantImage setImage:[UIImage imageNamed:@"no_image.png"]];
    }
    
    [self setRatingImages:restaurant.rating];

    if (isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"unfavorite.png"] forState:UIControlStateNormal];
    }
    
    NSLog(@"%@ - rating %.2f", restaurant.name, restaurant.rating);
}

@end
