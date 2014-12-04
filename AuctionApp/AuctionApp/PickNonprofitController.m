//
//  PickNonprofitController.m
//  AuctionApp
//
//  Created by Jon Vazquez on 12/2/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "PickNonprofitController.h"
#import "PickAuctionController.h"

@interface PickNonprofitController ()

@end

@implementation PickNonprofitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[PickNonprofitModel alloc] init];
    self.nonprofits = [self.model getNonprofits];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nonprofits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *nonprofitCellID = @"PickNonprofitCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nonprofitCellID forIndexPath:indexPath];
    
    NonprofitInfo* org = [self.nonprofits objectAtIndex:indexPath.row];
    
    cell.textLabel.text = org.name;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* fromPickNonprofitsSegue = @"UserPickedNonprofitSegue";
    
    if ([[segue identifier] isEqualToString:fromPickNonprofitsSegue]) {
        PickAuctionController* auctionController = [segue destinationViewController];
        
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NonprofitInfo* selectedAuction = [self.nonprofits objectAtIndex:[selectedIndexPath row]];
        
        auctionController.orgId = [self.nonprofits objectAtIndex:[selectedIndexPath row]];
        auctionController.auctions = [self.model getAuctions:selectedAuction.orgId];
        auctionController.model = self.model;
    }
}

@end
