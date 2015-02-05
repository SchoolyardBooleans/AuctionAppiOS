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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface AuctionMainController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *featuredCollection;

@property (nonatomic) AuctionsModel *model;
@property (nonatomic, weak) IBOutlet UILabel *nonprofitName;
@property (weak, nonatomic) IBOutlet UILabel *auctionName;
@property (weak, nonatomic) IBOutlet UILabel *auctionStatusMessage;

- (void)setAuctionInfo:(AuctionInfo *) auction;

@end
