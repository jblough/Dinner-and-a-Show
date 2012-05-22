//
//  MyAlertView.h
//  Dinner and a Show
//
//  Created by Joe Blough on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyDismissBlock)();
typedef void (^MyCancelBlock)();

@interface MyAlertView : UIAlertView <UIAlertViewDelegate> 

+ (MyAlertView*) showAlertViewWithTitle:(NSString*) title                    
                                message:(NSString*) message 
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(MyDismissBlock) dismissed                   
                               onCancel:(MyCancelBlock) cancelled;

@end
