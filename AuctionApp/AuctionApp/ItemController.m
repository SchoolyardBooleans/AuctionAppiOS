#import "ItemController.h"
#import "AccountUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ItemController ()

@end

@implementation ItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.auctionItem.name;
    self.descriptionLabel.text = self.auctionItem.descrip;
    self.sponsorLabel.text = self.auctionItem.sponsorName;
    [self.itemImage setImageWithURL:[NSURL URLWithString: self.auctionItem.imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    // Style buttons
    self.loginButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.bidButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.bidButton.layer.cornerRadius = 5;
    [self.bidButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Close keyboard on outside tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Add refresh button for currentBid
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadCurrentBid)];
    self.navigationItem.rightBarButtonItem = button;
    
    [self updateView];
}

#pragma Keyboard

// Move the textfield up when keyboard is present
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y - 30);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

// Return view to where it was
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

//Close keyboard on outside tap
-(void)dismissKeyboard {
    [self.bidField resignFirstResponder];
}

//Close keyboard on return/done press
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


#pragma IBActions

- (IBAction)bidChanged:(UISlider *)sender {
    NSMutableString *newBid = [NSMutableString stringWithString:@"$"];
    // Round float value to integer and set slider to that value
    int discreteValue = ((int)(([sender value] + 2.5) / 5) * 5);
    [sender setValue:(float)discreteValue];
    
    [newBid appendString:[[NSNumber numberWithFloat:discreteValue] stringValue]];
    self.bidField.text = newBid;
}

- (IBAction)makeBid:(id)sender {
    NSString *itemID = [NSString stringWithString:self.auctionItem.itemID];
    NSString *currentBid = self.bidField.text;
    NSString *accountID = [AccountUtility getId];
    NSString *currencyRegex = @"(?=.)^\\$?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\\.[0-9]{1,2})?$";
    NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", currencyRegex];
    
    
    if ([currencyPredicate evaluateWithObject:currentBid]) {
        currentBid = [currentBid stringByReplacingOccurrencesOfString:@"$" withString:@""];
        [self.model makeBidForItem:itemID withAmount:currentBid withBidderId:accountID callback:^(BOOL success, NSString *error) {
            if (error != nil || success == false) {
                [self performSelectorOnMainThread:@selector(showErrorDialog:) withObject:error waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(showSuccessDialog) withObject:nil waitUntilDone:NO];
            }
        }];
    } else {
         [self performSelectorOnMainThread:@selector(showErrorDialog:) withObject:@"Invalid currency format" waitUntilDone:NO];
    }
    
}

- (IBAction)login:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}


#pragma Updating

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self loadCurrentBid];
}

-(void) loadCurrentBid {
    [self.model getAuctionItemForId:[self.auctionItem itemID] callback:^(AuctionItem* item, NSString *error) {
        self.auctionItem = item;
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
    }];
}

// Add shit to check for closed auctions or auctions that are coming up
-(void) updateView {
    NSInteger status = self.auctionItem.status;
    NSString *currentBid = [NSString stringWithFormat: @"$%@", [self.auctionItem.currentBid stringValue]];
    
    // Not logged in or the auction is not in progress
    if (![AccountUtility loggedIn] || (status != IN_PROGRESS)) {
        self.bidSlider.hidden = YES;
        self.bidButton.hidden = YES;
        self.bidLabel.hidden = NO;
        self.bidField.hidden = YES;
        
        // If the user is not logged in and the auction is in progress show the login button
        if (![AccountUtility loggedIn] && status == IN_PROGRESS) {
            self.loginButton.hidden = NO;
        }
        
        self.bidLabel.text = currentBid;
    } else {
        self.bidSlider.minimumValue = [self.auctionItem.currentBid floatValue];
        self.bidSlider.maximumValue = self.bidSlider.minimumValue * 2.5 + 100;
        self.bidSlider.value = [self.auctionItem.currentBid floatValue];
        
        self.bidSlider.hidden = NO;
        self.bidButton.hidden = NO;
        self.loginButton.hidden = YES;
        self.bidLabel.hidden = YES;
        self.bidField.hidden = NO;

        self.bidField.text = currentBid;
    }
    
    if (status == COMPLETE) {
        self.bidStatus.text = @"Winning Bid";
    } else if (status == BEFORE) {
        self.bidStatus.text = @"Starting Price";
    } else  {
        self.bidStatus.text = @"Current Bid";
    }
}

#pragma Dialogs

-(void) showErrorDialog:(NSString *)error {
    NSMutableString *errorMessage = [NSMutableString stringWithString: (error == nil) ? @"Someone placed a higher bid, please try again" : error];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Bid Failed!"
                                                     message:errorMessage
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles: nil];
    [alert show];
}

-(void) showSuccessDialog {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success!"
                                                     message:@"You have placed the highest current bid"
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles: nil];
    [alert show];
}

@end
