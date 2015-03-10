//
//  PickItemController.m
//  AuctionApp
//
//  Created by James Fazio on 2/4/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "PickItemController.h"
#import "ItemTableCell.h"
#import "ItemController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PickItemController
{
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestItems)
                  forControlEvents:UIControlEventValueChanged];
    
    // Fixes small cell size when searching
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
    
    // Remove extra rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    // If items are available show the table
    // Deal with this
    if (self.auctionItems && self.auctionItems.count) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // If search is activated, show it
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [self.auctionItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *nonprofitCellID = @"PickAuctionItem";
    ItemTableCell *cell = (ItemTableCell *) [self.tableView dequeueReusableCellWithIdentifier:nonprofitCellID];
    NSMutableString *currentBid = [NSMutableString stringWithString:@"Current Bid: $"];
    
    // Create cell if it doesn't exist
    if (cell == nil) {
        cell = [[ItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nonprofitCellID];
    }
    
    AuctionItem* item = nil;
    // Grab cell from search table
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [searchResults objectAtIndex:indexPath.row];
    }
    // Grab cell from normal table
    else {
        item = [self.auctionItems objectAtIndex:indexPath.row];
    }
    
    cell.itemName.text = item.name;
    cell.itemCurrentBid.text = currentBid;
    cell.itemCurrentBid.text = [cell.itemCurrentBid.text stringByAppendingString:[item.currentBid stringValue]];
    [cell.itemImage setImageWithURL:[NSURL URLWithString: item.imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

#pragma mark - Reload Data

- (void) getLatestItems {
    
    [self.model getAuctionItems:self.auctionId :^(NSMutableArray *items, NSString *error) {
        if (error == nil) {
            self.auctionItems = items;
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
//    self.auctionItems = [self.model getAuctionItems:self.auctionId];
//    // might already be on the main thread
//    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [self.auctionItems filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* fromPickNonprofitsSegue = @"PickItem";
    
    if ([[segue identifier] isEqualToString:fromPickNonprofitsSegue]) {
        ItemController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = nil;
        AuctionItem *selectedItem = nil;
        
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedItem = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedItem = [self.auctionItems objectAtIndex:indexPath.row];
        }
        
        // Pass itemId off to controller
        [controller setAuctionItem:selectedItem];
        [controller setModel:self.model];
    }
}


@end
