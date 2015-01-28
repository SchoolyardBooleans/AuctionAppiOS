//
//  AuctionMainController.h
//  AuctionApp
//
//  Created by James Fazio on 1/25/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAuctionsModel.h"

@interface AuctionMainController : UIViewController

@property (nonatomic) GetAuctionsModel *model;
@property (nonatomic, weak) IBOutlet UILabel *auctionLabel;

- (void)setAuctionId:(NSString *) aucId;

@end
