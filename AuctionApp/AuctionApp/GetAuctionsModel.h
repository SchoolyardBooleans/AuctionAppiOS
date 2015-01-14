//
//  NonprofitModel.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionInfo.h"
#import "ServerConnection.h"

@interface GetAuctionsModel : NSObject

/**
 Returns an AuctionInfo NSMutableArray, each containing an id and name
 */
- (NSMutableArray*) getAuctions;
@end
