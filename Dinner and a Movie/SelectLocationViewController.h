//
//  SelectLocationViewController.h
//  Dinner and a Show
//
//  Created by Joe Blough on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@protocol SelectLocationDelegate <NSObject>

- (void)selectLocation:(CLLocationCoordinate2D)location sender:(id)sender;
- (void)cancel;

@end

@interface SelectLocationViewController : UIViewController

@property (nonatomic, weak) id<SelectLocationDelegate> delegate;

@end
