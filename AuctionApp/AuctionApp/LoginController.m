//
//  LoginController.m
//  AuctionApp
//
//  Created by James Fazio on 2/12/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "LoginController.h"
#import "AccountUtility.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <SalesforceSDKCore/SFPushNotificationManager.h>

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.invalidEmail.hidden = YES;
    self.model = [[RegisterModel alloc] init];
    
    self.loginButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.registerButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.registerButton.layer.cornerRadius = 5;
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)login:(id)sender {
    NSString *email = self.emailField.text;
    if ([email length]) {
        [self.model loginWithEmail:email callback:^(NSDictionary *dic, NSString *err) {
            if (err != nil || [[dic objectForKey:@"success"] boolValue] == NO) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.invalidEmail.hidden = NO;
                });
            } else {
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [AccountUtility login:dic];
                
                NSLog(@"Trying to register for notifications...");
                [[SFPushNotificationManager sharedInstance]
                 registerForRemoteNotifications];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appdelegate switchToAccountView];
                });
                
            }
        }];
    } else {
        NSLog(@"Error");
    }
}

@end
