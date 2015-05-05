//
//  RegisterController.m
//  AuctionApp
//
//  Created by James Fazio on 2/16/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "RegisterController.h"
#import "AccountUtility.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <SalesforceSDKCore/SFPushNotificationManager.h>

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For now creates own model, will change
    self.model = [[RegisterModel alloc] init];
    self.confirmView.hidden = true;
    self.errorLabel.hidden = true;
    
    self.registerButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.registerButton.layer.cornerRadius = 5;
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.confirmButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.confirmButton.layer.cornerRadius = 5;
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadCodeIfPresent)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCodeIfPresent {
    NSString *code = [AccountUtility getCode];
    
    if (code != nil) {
        [self.codeField setText:code];
    }
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSString *code = self.codeField.text;
    
    [self.model confirmAccountwithCode:code callback:^(NSDictionary *dict, NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                self.errorLabel.text = error;
                self.errorLabel.hidden = false;
            } else {
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [AccountUtility removeCode];
                [AccountUtility login: dict];
                
                NSLog(@"Trying to register for notifications...");
                [[SFPushNotificationManager sharedInstance]
                 registerForRemoteNotifications];
                
                [appdelegate switchToAccountView];
                NSLog(@"Success logging in");
            }
        });
        
    }];
}

- (IBAction)registerAction:(UIButton *)sender {
    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    NSString *email = self.emailField.text;
    
    if ([self.model validatefirstName:firstName lastName:lastName email:email]) {
        self.errorLabel.hidden = true;
        
        [self.model registerAccountwithFirstName:firstName lastName:lastName email:email callback:^(BOOL success, NSString *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil) {
                    self.errorLabel.text = error;
                    self.errorLabel.hidden = false;
                } else {
                    self.confirmView.hidden = false;
                }
            });
        }];
        
    } else {
        self.errorLabel.text = @"Error: Invalid name or email";
        self.errorLabel.hidden = false;
    }
    
}
@end
