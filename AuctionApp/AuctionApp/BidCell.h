//
//  BidCell.h
//  AuctionApp
//
//  Created by James Fazio on 3/3/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
