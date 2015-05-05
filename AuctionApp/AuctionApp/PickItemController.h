// Controller for picking an Auction Item

#import <UIKit/UIKit.h>
#import "AuctionsModel.h"

@interface PickItemController : UITableViewController

@property (nonatomic) NSArray *auctionItems;
@property (nonatomic) AuctionsModel *model;
@property (nonatomic) NSString *auctionId;

@end
