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
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UISlider *bidSlider;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *bidField;
@property (weak, nonatomic) IBOutlet UILabel *bidStatus;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;


- (IBAction)bidChanged:(UISlider *)sender;
- (IBAction)makeBid:(id)sender;
- (IBAction)login:(id)sender;


@end
