// Contains methods for auction and auction item related operations

#import <Foundation/Foundation.h>
#import "AuctionInfo.h"
#import "AuctionItem.h"
#import "Bid.h"
#import "ServerConnection.h"
#import "Constants.h"

@interface AuctionsModel : NSObject


// Get the auction item for the provided id. The provided callback will be
// populated with the auction item object and an optional error message.
- (void) getAuctionItemForId :(NSString *) itemId callback:(void (^)(AuctionItem *item, NSString *error)) callback;

// Get all auctions. The provided callback will be populated with the auction
// objects and an optional error message.
- (void) getAuctions :(void (^)(NSMutableArray *auctions, NSString *error)) callback;

// Get all the auction items for the provided auction id. The provided callback
// be populated by the auction item objects and an optional error message.
- (void) getAuctionItemsForId:(NSString *) auctionID callback:(void (^)(NSMutableArray *items, NSString *error)) callback;

// Place a bid for the provided item id with the provided amount for the provided
// bidder. The callback will be populated with a success value and an optional
// error message.
- (void) makeBidForItem:(NSString *) itemID withAmount: (NSString *) amount withBidderId:(NSString *) bidderID callback:(void (^)(BOOL success, NSString *error)) callback;

// Get the bids for the provided user id. The callback will be populated with
// the user's bid objects and an optional error message.
- (void) getBidsForUser:(NSString *) bidderID : (void (^)(NSMutableArray *bids, NSString *error)) callback;

// Get the status message for an auction. Returns the end datetime
// if the auction is in progress or the start time if the auction
// occurs in the future
- (NSString *) statusMessageForAuction:(AuctionInfo *)auction;

@end
