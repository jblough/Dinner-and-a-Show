//
//  UIActionSheet+Blocks.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIActionSheet+Blocks.h"

static ActionDismissBlock _dismissBlock;
static ActionCancelBlock _cancelBlock;

@implementation UIActionSheet (Blocks)

+ (UIActionSheet *)showActionSheetWithTitle:(NSString *)title 
                          cancelButtonTitle:(NSString *)cancelButtonTitle 
                     destructiveButtonTitle:(NSString *)destructiveButtonTitle 
                          otherButtonTitles:(NSArray *)otherButtons
                                       view:(UIView *)view
                                  onDismiss:(ActionDismissBlock) dismissed                   
                                   onCancel:(ActionCancelBlock) cancelled
{
    _cancelBlock  = [cancelled copy];
    _dismissBlock  = [dismissed copy];
    
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:title
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert showInView:view];
    return alert;
    
}


+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	if(buttonIndex == [actionSheet cancelButtonIndex])
	{
		_cancelBlock();
	}
    else
    {
        _dismissBlock(buttonIndex-1);
    }  
}


@end
