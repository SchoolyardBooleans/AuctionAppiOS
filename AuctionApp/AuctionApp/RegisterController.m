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

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For now creates own model, will change
    self.model = [[RegisterModel alloc] init];
    self.confirmView.hidden = true;
    self.errorLabel.hidden = true;
    
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
    
    [self.model confirmAccount:code :^(NSDictionary *dict, NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                self.errorLabel.text = error;
                self.errorLabel.hidden = false;
            } else {
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [AccountUtility removeCode];
                [AccountUtility login: dict];
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
    
    if ([self.model validate:firstName :lastName :email]) {
        self.errorLabel.hidden = true;
        
        [self.model registerAccount:firstName :lastName :email :^(BOOL success, NSString *error) {
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
