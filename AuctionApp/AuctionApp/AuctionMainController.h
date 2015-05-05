// Controller for viewing an Auction

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"
#import "AuctionInfo.h"


@interface AuctionMainController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *featuredCollection;

@property (nonatomic) AuctionsModel *model;
@property (nonatomic, weak) IBOutlet UILabel *nonprofitName;
@property (weak, nonatomic) IBOutlet UILabel *auctionName;
@property (weak, nonatomic) IBOutlet UILabel *auctionStatusMessage;
@property (weak, nonatomic) IBOutlet UIButton *viewAllButton;

- (void)setAuctionInfo:(AuctionInfo *) auction;

@end
