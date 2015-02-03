//
//  AuctionMainController.m
//  AuctionApp
//
//  Created by James Fazio on 1/25/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AuctionMainController.h"

@interface AuctionMainController ()

@end

@implementation AuctionMainController{
    AuctionInfo *auctionInfo;
    NSArray *auctionItems;
    NSMutableArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.nonprofitName setText: auctionInfo.orgName];
    [self.auctionName setText: auctionInfo.name];
    [self.auctionStatusMessage setText: [self.model statusMessageForAuction:auctionInfo]];
    
    
    auctionItems = [self.model getAuctionItems:auctionInfo.aucId];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:@"apple"];
    [array addObject:@"banana"];
    [array addObject:@"kiwi"];
    [array addObject:@"orange"];
    [array addObject:@"donkey"];
    
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
    return [array count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *) [cell viewWithTag: 100];
    label.text = [array objectAtIndex:indexPath.row];
    
    UIImageView *image = (UIImageView *) [cell viewWithTag: 20];
    [image setImage: [UIImage imageNamed:[array objectAtIndex:indexPath.row]]];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    return cell;
}



@end
