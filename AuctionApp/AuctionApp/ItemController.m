//
//  ItemController.m
//  AuctionApp
//
//  Created by James Fazio on 2/19/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "ItemController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ItemController ()

@end

@implementation ItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.auctionItemBasic.name;
    self.currentBidLabel.text = [NSString stringWithFormat: @"$%@", [self.auctionItemBasic.currentBid stringValue]];
    [self.itemImage setImageWithURL:[NSURL URLWithString: self.auctionItemBasic.imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
   // self.descriptionLabel.hidden = true;
   // self.sponsorView.hidden = true;
}

@end
