//
//  AuctionController.m
//  AuctionApp
//
//  Created by James Fazio on 2/24/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AccountController.h"
#import "AccountUtility.h"
#import "AppDelegate.h"

@implementation AccountController
{
    NSString *userId;
    NSString *userName;
}

- (void)viewDidLoad {
    userId = [AccountUtility getId];
    userName = [AccountUtility getName];
    self.nameLabel.text = userName;
}

- (IBAction)logout:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [AccountUtility logout];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appdelegate switchToLoginView];
    });
    
}
@end
