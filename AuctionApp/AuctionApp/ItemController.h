//
//  ItemController.h
//  AuctionApp
//
//  Created by James Fazio on 2/19/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuctionItem.h"
#import "AuctionsModel.h"

@interface ItemController : UIViewController<UIAlertViewDelegate>

@property (nonatomic) AuctionItem *auctionItem;
@property (nonatomic) AuctionsModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UIView *sponsorView;
@property (weak, nonatomic) IBOutlet UILabel *currentBidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UISlider *bidSlider;


- (IBAction)bidChanged:(UISlider *)sender;
- (IBAction)makeBid:(id)sender;


@end
