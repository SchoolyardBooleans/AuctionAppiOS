// Contains all the inforamtion for an auction item

#import <Foundation/Foundation.h>

@interface AuctionItem : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* itemID;
@property (nonatomic) NSString* sponsorName;
@property (nonatomic) NSNumber* currentBid;
@property (nonatomic) NSNumber* estimatedValue;
@property (nonatomic) BOOL featured;
@property (nonatomic) NSString* imageURL;
@property (nonatomic) NSString* descrip;
@property (nonatomic) NSNumber* minBid;
@property (nonatomic) NSInteger status;


@end
