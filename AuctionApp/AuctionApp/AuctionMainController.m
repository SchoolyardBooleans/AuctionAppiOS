//
//  AuctionMainController.m
//  AuctionApp
//
//  Created by James Fazio on 1/25/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AuctionMainController.h"
#import "PickItemController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AuctionMainController ()

@end

@implementation AuctionMainController{
    AuctionInfo *auctionInfo;
    NSArray *auctionItems;
    NSArray *featuredItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.nonprofitName setText: auctionInfo.orgName];
    [self.auctionName setText: auctionInfo.name];
    [self.auctionStatusMessage setText: [self.model statusMessageForAuction:auctionInfo]];
    
    
    auctionItems = [self.model getAuctionItems:auctionInfo.aucId];
    featuredItems = [self getFeaturedItems:auctionItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAuctionInfo:(AuctionInfo *)auction {
    auctionInfo = auction;
}


#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [featuredItems count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *) [cell viewWithTag: 100];
    UIImageView *image = (UIImageView *) [cell viewWithTag: 20];
    AuctionItemBasic *item = [featuredItems objectAtIndex:indexPath.row];
    
    label.text = item.name;
    
    [image setImageWithURL:[NSURL URLWithString: item.imageURL]
                   placeholderImage:[UIImage imageNamed:@"apple"]];
    //[image setImage: [UIImage imageNamed:[array objectAtIndex:indexPath.row]]];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:UIColorFromRGB(0xEBBF93).CGColor];
    
    return cell;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* fromPickNonprofitsSegue = @"ViewItems";
    
    if ([[segue identifier] isEqualToString:fromPickNonprofitsSegue]) {
        PickItemController *controller = [segue destinationViewController];
        
        // Pass model and auctionId off to controller
        [controller setAuctionItems:auctionItems];
        [controller setModel:self.model];
        [controller setAuctionId:auctionInfo.aucId];
    }
}

#pragma mark - Utility

- (NSArray *)getFeaturedItems:(NSArray *) items {
    
    NSPredicate *featuredPredicate = [NSPredicate predicateWithBlock:^BOOL(AuctionItemBasic *item, NSDictionary *bindings) {
        return item.featured == YES;
    }];
    
    return [items filteredArrayUsingPredicate:featuredPredicate];
}





@end
