// Controller for the Pick Auction page

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"

@interface PickAuctionController : UITableViewController

@property (nonatomic) AuctionsModel *model;
@property (nonatomic) NSArray *auctions;

@end
