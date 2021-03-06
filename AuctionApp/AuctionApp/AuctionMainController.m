#import "AuctionMainController.h"
#import "PickItemController.h"
#import "ItemController.h"
#import "Constants.h"
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
    
    self.viewAllButton.backgroundColor = UIColorFromRGB(0x067AB5);
    self.viewAllButton.layer.cornerRadius = 5;
    [self.viewAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.model getAuctionItemsForId:auctionInfo.aucId callback:^(NSMutableArray *items, NSString *error) {
        if (error == nil) {
            auctionItems = items;
            featuredItems = [self getFeaturedItems:auctionItems];
            // Reload on main thread when info is ready
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.featuredCollection reloadData];
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
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
    AuctionItem *item = [featuredItems objectAtIndex:indexPath.row];
    
    label.text = item.name;
    
    [image setImageWithURL:[NSURL URLWithString: item.imageURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //[image setImage: [UIImage imageNamed:[array objectAtIndex:indexPath.row]]];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:UIColorFromRGB(0x067AB5).CGColor];
    
    return cell;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString* viewItemsSegue = @"ViewItems";
    NSString* viewItemSeque = @"ViewItem";
    
    if ([[segue identifier] isEqualToString:viewItemsSegue]) {
        PickItemController *controller = [segue destinationViewController];
        
        // Pass model and auctionId off to controller
        [controller setAuctionItems:auctionItems];
        [controller setModel:self.model];
        [controller setAuctionId:auctionInfo.aucId];
    } else if ([[segue identifier] isEqualToString:viewItemSeque]) {
        //Problem here
        ItemController *controller = [segue destinationViewController];
        NSArray *indexPaths = [self.featuredCollection indexPathsForSelectedItems];
        NSIndexPath *selected = [indexPaths objectAtIndex:0];
        AuctionItem *item = [featuredItems objectAtIndex:selected.row];
        
        [controller setAuctionItem:item];
        [controller setModel:self.model];
    }
    
}

#pragma mark - Utility

- (NSArray *)getFeaturedItems:(NSArray *) items {
    
    NSPredicate *featuredPredicate = [NSPredicate predicateWithBlock:^BOOL(AuctionItem *item, NSDictionary *bindings) {
        return item.featured == YES;
    }];
    
    return [items filteredArrayUsingPredicate:featuredPredicate];
}

@end
