//
//  MyAlertView.m
//  Dinner and a Show
//
//  Created by Joe Blough on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAlertView.h"

static MyDismissBlock _dismissBlock;
static MyCancelBlock _cancelBlock;

@implementation MyAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UIAlertView*) showAlertViewWithTitle:(NSString*) title                    
                                message:(NSString*) message 
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(MyDismissBlock) dismissed                   
                               onCancel:(MyCancelBlock) cancelled {
    
    _cancelBlock  = [cancelled copy];
    _dismissBlock  = [dismissed copy];
    
    MyAlertView *alert = [[MyAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
	if(buttonIndex == [alertView cancelButtonIndex])
	{
		_cancelBlock();
	}
    else
    {
        _dismissBlock();
    }  
}

@end
