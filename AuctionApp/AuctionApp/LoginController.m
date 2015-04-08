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

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.invalidEmail.hidden = YES;
    self.model = [[RegisterModel alloc] init];
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
