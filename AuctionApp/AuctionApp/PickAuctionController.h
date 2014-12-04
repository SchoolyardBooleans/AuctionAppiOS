//
//  PickAuctionController.h
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickNonprofitModel.h"

@interface PickAuctionController : UITableViewController

@property (nonatomic) NSString* orgId;
@property (nonatomic) NSArray* auctions;
@property (nonatomic) PickNonprofitModel* model;

@end
