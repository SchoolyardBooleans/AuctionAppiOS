//
//  PickAuctionController.m
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "PickAuctionController.h"
#import "PickNonprofitModel.h"
#import "AuctionInfo.h"

@interface PickAuctionController ()

@end

@implementation PickAuctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.auctions count] > 0) {
        return [self.auctions count];
    }
    else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* pickAuctionCellID = @"PickAuctionCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pickAuctionCellID forIndexPath:indexPath];
    
    if ([self.auctions count] > 0) {
        AuctionInfo* auction = [self.auctions objectAtIndex:[indexPath row]];
        cell.textLabel.text = auction.name;
    }
    else {
        cell.textLabel.text = @"Unable to access nonprofit auction";
    }
    
    return cell;
}

@end
