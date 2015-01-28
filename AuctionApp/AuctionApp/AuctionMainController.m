//
//  AuctionMainController.m
//  AuctionApp
//
//  Created by James Fazio on 1/25/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AuctionMainController.h"

@interface AuctionMainController ()

@end

@implementation AuctionMainController{
    NSString *auctionId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.auctionLabel setText: auctionId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAuctionId:(NSString *) aucId {
    auctionId = aucId;
}



@end
