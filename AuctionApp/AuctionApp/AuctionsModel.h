//
//  NonprofitModel.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionInfo.h"
#import "AuctionItem.h"
#import "Bid.h"
#import "ServerConnection.h"

@interface AuctionsModel : NSObject

// 0 - before
// 1 - in progress
// 2 - finished

extern int const BEFORE;
extern int const IN_PROGRESS;
extern int const COMPLETE;

- (void) getAuctionItem :(NSString *) itemId :(void (^)(AuctionItem *item, NSString *error)) callback;
- (void) getAuctions :(void (^)(NSMutableArray *auctions, NSString *error)) callback;
- (void) getAuctionItems:(NSString *) auctionID :(void (^)(NSMutableArray *items, NSString *error)) callback;
- (void) makeBid:(NSString *) itemID : (NSString *) amount :(NSString *) bidderID :(void (^)(BOOL success, NSString *error)) callback;
- (void) getCurrentBid:(NSString *) itemID :(void (^)(NSNumber *currentBid, NSString *error))callback;
- (void) getBidsForUser:(NSString *) bidderID : (void (^)(NSMutableArray *bids, NSString *error)) callback;
- (NSString *) statusMessageForAuction:(AuctionInfo *)auction;

@end
