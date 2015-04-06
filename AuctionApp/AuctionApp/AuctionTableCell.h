// Custom cell for the auctions tableview


#import <UIKit/UIKit.h>

@interface AuctionTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *orgName;
@property (nonatomic, weak) IBOutlet UILabel *auctionName;
@property (weak, nonatomic) IBOutlet UILabel *auctionStatus;
@end

