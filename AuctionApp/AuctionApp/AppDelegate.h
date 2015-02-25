//
//  AppDelegate.h
//  AuctionApp
//
//  Created by Jon Vazquez on 11/9/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) switchToAccountView;
-(void) switchToLoginView;
-(void) selectSecondTab;

@end

