//
//  AuctionTableCell.h
//  AuctionApp
//
//  Created by James Fazio on 1/13/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemName;
@property (nonatomic, weak) IBOutlet UILabel *itemCurrentBid;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end

