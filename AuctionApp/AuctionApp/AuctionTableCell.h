//
//  AuctionTableCell.h
//  AuctionApp
//
//  Created by James Fazio on 1/13/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *orgName;
@property (nonatomic, weak) IBOutlet UILabel *auctionName;

@end

