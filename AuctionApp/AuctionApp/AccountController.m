//
//  AuctionController.m
//  AuctionApp
//
//  Created by James Fazio on 2/24/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AccountController.h"
#import "AccountUtility.h"
#import "AppDelegate.h"
#import "AuctionsModel.h"
#import "BidCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemController.h"

@implementation AccountController
{
    NSString *userId;
    AuctionsModel *model;
    NSArray *winningBids;
    NSArray *winningSearchResults;
    NSArray *losingBids;
    NSArray *losingSearchResults;
    UILabel *messageLabel;
    
}

- (void)viewDidLoad {
    userId = [AccountUtility getId];
    model = [[AuctionsModel alloc] init];
    
    [self getLatestBids];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestBids)
                  forControlEvents:UIControlEventValueChanged];
    
    // Fixes small cell size when searching
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
    
    // Remove extra rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)logout:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [AccountUtility logout];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appdelegate switchToLoginView];
    });
    
}

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (winningBids.count || losingBids.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 2;
    }
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle;
    if (section == 0) {
        headerTitle = @"Winning Bids";
    } else {
        headerTitle = @"Losing Bids";
    }
    
    return headerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If search is activated, show it
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section == 0) {
            return [winningSearchResults count];
        } else {
            return [losingSearchResults count];
        }
    } else {
        if (section == 0) {
            return [winningBids count];
        } else {
            return [losingBids count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bidCellID = @"BidItem";
    BidCell *cell = (BidCell *) [self.tableView dequeueReusableCellWithIdentifier:bidCellID];
    NSMutableString *myBid = [NSMutableString stringWithString:@"My Bid: $"];
    NSMutableString *nameAndAuction = [[NSMutableString alloc] init];
    
    // Create cell if it doesn't exist
    if (cell == nil) {
        cell = [[BidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bidCellID];
    }
    
    Bid *item = [self getBidFromTable:tableView atIndex:indexPath];
    
    [nameAndAuction appendString: item.itemName];
    [nameAndAuction appendString: @" - "];
    [nameAndAuction appendString: item.auctionName];
    
    [myBid appendString:[item.amount stringValue]];
    
    cell.itemNameLabel.text = nameAndAuction;
    cell.myBidLabel.text = myBid;
    [cell.itemImage setImageWithURL:[NSURL URLWithString: item.imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

#pragma mark - Reload Data

- (void) getLatestBids {
    [model getBidsForUser:userId :^(NSMutableArray *recentBids, NSString *error) {
        if (error == nil) {
            NSPredicate *winningPred = [NSPredicate predicateWithFormat:@"isWinning == YES"];
            NSPredicate *losingPred = [NSPredicate predicateWithFormat:@"isWinning == NO"];
            winningBids = [recentBids filteredArrayUsingPredicate:winningPred];
            losingBids = [recentBids filteredArrayUsingPredicate:losingPred];
            
            if ([winningBids count] == 0 && [losingBids count] == 0) {
                // Display a message when the table is empty
                messageLabel.text = @"You have not made any bids. Please pull down to refresh.";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                [messageLabel sizeToFit];
                
                self.tableView.backgroundView = messageLabel;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            } else {
                messageLabel.hidden = YES;
            }
            
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        // Set datetime of last refresh
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Filter search on orgization name and auction name
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(itemName contains[c] %@) OR (auctionName contains[c] %@)", searchText, searchText];
    winningSearchResults = [winningBids filteredArrayUsingPredicate:resultPredicate];
    losingSearchResults = [losingBids filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bid *bid = [self getBidFromTable:tableView atIndex:indexPath];
    
    [model getAuctionItemForId:bid.itemID callback:^(AuctionItem *item, NSString *error) {
        if (error == nil) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ItemController *itemController = [storyboard instantiateViewControllerWithIdentifier:@"ItemController"];
            [itemController setModel:model];
            [itemController setAuctionItem:item];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:itemController animated:YES];
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSString* fromPickNonprofitsSegue = @"ItemDetail";
//    
//    if ([[segue identifier] isEqualToString:fromPickNonprofitsSegue]) {
//        ItemController *controller = [segue destinationViewController];
//        NSIndexPath *indexPath = nil;
//        AuctionItem *selectedItem = nil;
//        
//        
//        if (self.searchDisplayController.active) {
//            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//            selectedItem = [searchResults objectAtIndex:indexPath.row];
//        } else {
//            indexPath = [self.tableView indexPathForSelectedRow];
//            selectedItem = [self.auctionItems objectAtIndex:indexPath.row];
//        }
//        
//        // Pass itemId off to controller
//        [controller setAuctionItem:selectedItem];
//        [controller setModel:self.model];
//    }
//}

#pragma mark - Utility
-(Bid *) getBidFromTable:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath {
    Bid *bid;
    // Grab cell from search table
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.section == 0) {
            bid = [winningSearchResults objectAtIndex:indexPath.row];
        } else {
            bid = [losingSearchResults objectAtIndex:indexPath.row];
        }
    }
    // Grab cell from normal table
    else {
        if (indexPath.section == 0) {
            bid = [winningBids objectAtIndex:indexPath.row];
        } else {
            bid = [losingBids objectAtIndex:indexPath.row];
        }
    }
    
    return bid;
}
@end
