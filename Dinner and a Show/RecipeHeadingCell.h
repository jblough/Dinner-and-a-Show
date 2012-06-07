//
//  RecipeHeadingCell.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeHeadingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *recipeImage;
@property (nonatomic, weak) IBOutlet UILabel *servesLabel;
@property (nonatomic, weak) IBOutlet UILabel *yieldsLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;

@end
