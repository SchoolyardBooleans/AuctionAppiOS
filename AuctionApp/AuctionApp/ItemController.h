// View Controller for the Auction Item page

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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


- (IBAction)bidChanged:(UISlider *)sender;
- (IBAction)makeBid:(id)sender;
- (IBAction)login:(id)sender;


@end
