//
//  RegisterController.m
//  AuctionApp
//
//  Created by James Fazio on 2/16/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "RegisterController.h"

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void) loadCodeIfPresent {
    NSString *code = [[NSUserDefaults standardUserDefaults] stringForKey:@"code"];
    
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"code"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"Id"] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"first"] forKey:@"firstName"];
                [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"flast"] forKey:@"lastName"];
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
