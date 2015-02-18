//
//  NonprofitModel.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionInfo.h"
#import "AuctionItemBasic.h"
#import "ServerConnection.h"

@interface AuctionsModel : NSObject

// 0 - before
// 1 - in progress
// 2 - finished

extern int const BEFORE;
extern int const IN_PROGRESS;
extern int const COMPLETE;

/**
 Returns an AuctionInfo NSMutableArray, each containing an id and name
 */
- (void) getAuctions :(void (^)(NSMutableArray*, NSString *)) callback;
- (void) getAuctionItems:(NSString *) auctionID :(void (^)(NSMutableArray*, NSString *)) callback;
- (NSString *) statusMessageForAuction:(AuctionInfo *)auction;

@end
