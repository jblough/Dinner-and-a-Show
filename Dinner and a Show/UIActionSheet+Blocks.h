//
//  UIActionSheet+Blocks.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionDismissBlock)(int);
typedef void (^ActionCancelBlock)();

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

+ (UIActionSheet *)showActionSheetWithTitle:(NSString *)title 
                          cancelButtonTitle:(NSString *)cancelButtonTitle 
                     destructiveButtonTitle:(NSString *)destructiveButtonTitle 
                          otherButtonTitles:(NSArray *)otherButtons
                                       view:(UIView *)view
                                  onDismiss:(ActionDismissBlock) dismissed                   
                                   onCancel:(ActionCancelBlock) cancelled;

@end
