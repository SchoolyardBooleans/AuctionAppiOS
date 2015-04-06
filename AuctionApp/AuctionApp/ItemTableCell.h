// Custom cell for the auctions items tableview

#import <UIKit/UIKit.h>

@interface ItemTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemName;
@property (nonatomic, weak) IBOutlet UILabel *itemCurrentBid;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end

