//
//  RecipeHeadingCell.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipeHeadingCell.h"

@implementation RecipeHeadingCell
@synthesize nameLabel = _nameLabel;
@synthesize recipeImage = _recipeImage;
@synthesize servesLabel = _servesLabel;
@synthesize yieldsLabel = _yieldsLabel;
@synthesize costLabel = _costLabel;

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

@end
