//
//  PickNonprofitController.m
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "PickAuctionController.h"
#import "AuctionTableCell.h"

@interface PickAuctionController ()

@end

@implementation PickAuctionController
{
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[GetAuctionsModel alloc] init];
   [self getLatestNonprofits];
   
   
   // Initialize the refresh control.
   self.refreshControl = [[UIRefreshControl alloc] init];
   self.refreshControl.backgroundColor = [UIColor grayColor];
   self.refreshControl.tintColor = [UIColor whiteColor];
   [self.refreshControl addTarget:self
                           action:@selector(getLatestNonprofits)
                 forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // Return the number of sections.
   
   // If non-profits are available show the table
   if (self.auctions) {
      
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
        return [self.auctions count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *nonprofitCellID = @"PickNonprofitCellID";
    AuctionTableCell *cell = (AuctionTableCell *) [self.tableView dequeueReusableCellWithIdentifier:nonprofitCellID];
    
    // Create cell if it doesn't exist
    if (cell == nil) {
        cell = [[AuctionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nonprofitCellID];
    }
    
    AuctionInfo* auction = nil;
    // Grab cell from search table
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        auction = [searchResults objectAtIndex:indexPath.row];
    }
    // Grab cell from normal table
    else {
        auction = [self.auctions objectAtIndex:indexPath.row];
    }
    
    cell.auctionName.text = auction.name;
    cell.orgName.text = auction.orgName;
   
    return cell;
}

#pragma mark - Reload Data

- (void) getLatestNonprofits {
    self.auctions = [self.model getAuctions];
    // might already be on the main thread
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(orgName contains[c] %@) OR (name contains[c] %@)", searchText, searchText];
    searchResults = [self.auctions filteredArrayUsingPredicate:resultPredicate];
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

// Daniel this is where you can setup the seque to the next controller, I've filled in some example code and
// left the useful stuff
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* fromPickNonprofitsSegue = @"UserPickedAuctionSegue";
    
    if ([[segue identifier] isEqualToString:fromPickNonprofitsSegue]) {
        // The controller you are going to go to
        // ExampleController *exampleController = [seque destinationViewController];
        NSIndexPath *indexPath = nil;
        AuctionInfo *selectedAuction = nil;

        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedAuction = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            selectedAuction = [self.auctions objectAtIndex:indexPath.row];
        }
        
        // SelectedAuction is the info of the cell, which you can pass to the controller you are going to
        // exampleController.auction = selectedAuction
        // exampleController.model = self.model (If you need it)
    }
}

@end
