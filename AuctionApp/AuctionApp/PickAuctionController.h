//
//  PickNonprofitController.h
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"

@interface PickAuctionController : UITableViewController

@property (nonatomic) AuctionsModel *model;
@property (nonatomic) NSArray *auctions;

@end
