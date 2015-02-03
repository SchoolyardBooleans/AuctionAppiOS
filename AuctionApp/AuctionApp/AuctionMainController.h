//
//  AuctionMainController.h
//  AuctionApp
//
//  Created by James Fazio on 1/25/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"
#import "AuctionInfo.h"

@interface AuctionMainController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *featuredCollection;

@property (nonatomic) AuctionsModel *model;
@property (nonatomic, weak) IBOutlet UILabel *nonprofitName;
@property (weak, nonatomic) IBOutlet UILabel *auctionName;
@property (weak, nonatomic) IBOutlet UILabel *auctionStatusMessage;

- (void)setAuctionInfo:(AuctionInfo *) auction;

@end
