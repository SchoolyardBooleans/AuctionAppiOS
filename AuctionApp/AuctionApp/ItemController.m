//
//  ItemController.m
//  AuctionApp
//
//  Created by James Fazio on 2/19/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

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
    [self updateView];
    
    
    // Add refresh button for currentBid
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadCurrentBid)];
    self.navigationItem.rightBarButtonItem = button;
}

- (IBAction)bidChanged:(UISlider *)sender {
    NSMutableString *newBid = [NSMutableString stringWithString:@"$"];
    // Round float value to integer and set slider to that value
    int discreteValue = roundl([sender value]);
    [sender setValue:(float)discreteValue];
    
    [newBid appendString:[[NSNumber numberWithFloat:discreteValue] stringValue]];
    self.currentBidLabel.text = newBid;
}

- (IBAction)makeBid:(id)sender {
    NSString *itemID = [NSString stringWithString:self.auctionItem.itemID];
    NSString *currentBid = [self.currentBidLabel.text substringFromIndex:1];
    NSString *accountID = [AccountUtility getId];
    
    [self.model makeBid:itemID :currentBid :accountID :^(BOOL success, NSString *error) {
        if (error != nil || success == false) {
            [self performSelectorOnMainThread:@selector(showErrorDialog:) withObject:error waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(showSuccessDialog) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (IBAction)login:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self loadCurrentBid];
}

-(void) loadCurrentBid {
    [self.model getCurrentBid:[self.auctionItem itemID] :^(NSNumber* currentBid, NSString *error) {
        [self.auctionItem setCurrentBid:currentBid];
        [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
    }];
}

-(void) updateView {
    self.currentBidLabel.text = [NSString stringWithFormat: @"$%@", [self.auctionItem.currentBid stringValue]];
    self.bidSlider.minimumValue = [self.auctionItem.currentBid floatValue];
    self.bidSlider.maximumValue = self.bidSlider.minimumValue * 2.5 + 100;
    self.bidSlider.value = [self.auctionItem.currentBid floatValue];
    
    if (![AccountUtility loggedIn]) {
        self.bidSlider.hidden = YES;
        self.bidButton.hidden = YES;
        self.loginButton.hidden = NO;
    } else {
        self.bidSlider.hidden = NO;
        self.bidButton.hidden = NO;
        self.loginButton.hidden = YES;
    }
}

-(void) showErrorDialog:(NSString *)error {
    NSMutableString *errorMessage = [NSMutableString stringWithString: (error == nil) ? @"Someone placed a higher bid, please try again" : error];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Sorry, a bid could not be made"
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
