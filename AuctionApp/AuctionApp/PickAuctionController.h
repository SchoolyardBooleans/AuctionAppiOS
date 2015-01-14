//
//  PickNonprofitController.h
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAuctionsModel.h"

@interface PickAuctionController : UITableViewController

@property (nonatomic) GetAuctionsModel *model;
@property (nonatomic) NSArray *auctions;

@end
