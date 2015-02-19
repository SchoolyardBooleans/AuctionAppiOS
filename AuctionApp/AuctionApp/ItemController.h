//
//  ItemController.h
//  AuctionApp
//
//  Created by James Fazio on 2/19/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionItemBasic.h"

@interface ItemController : UIViewController

@property (nonatomic) AuctionItemBasic *auctionItemBasic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UIView *sponsorView;
@property (weak, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;


@end
