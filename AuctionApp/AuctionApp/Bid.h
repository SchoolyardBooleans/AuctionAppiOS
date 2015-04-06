// Contains all the information for a bid object

#import <Foundation/Foundation.h>

@interface Bid : NSObject

@property (nonatomic) NSString* itemName;
@property (nonatomic) NSString* itemID;
@property (nonatomic) BOOL isWinning;
@property (nonatomic) NSString* auctionName;
@property (nonatomic) NSNumber* amount;
@property (nonatomic) NSString* imageURL;


@end
