//
//  PickItemController.h
//  AuctionApp
//
//  Created by James Fazio on 2/4/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"

@interface PickItemController : UITableViewController

@property (nonatomic) NSArray *auctionItems;
@property (nonatomic) AuctionsModel *model;
@property (nonatomic) NSString *auctionId;

@end
