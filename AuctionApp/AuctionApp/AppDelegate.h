//
//  AppDelegate.h
//  AuctionApp
//
//  Created by Jon Vazquez on 11/9/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) switchToAccountView;
-(void) switchToLoginView;
-(void) selectSecondTab;

@end

