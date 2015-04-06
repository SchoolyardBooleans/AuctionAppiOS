// Custom cell for the my bids tableview

#import <UIKit/UIKit.h>

@interface BidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
