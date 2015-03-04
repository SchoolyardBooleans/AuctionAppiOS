//
//  Bid.h
//  AuctionApp
//
//  Created by James Fazio on 3/3/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bid : NSObject

@property (nonatomic) NSString* itemName;
@property (nonatomic) NSString* itemID;
@property (nonatomic) BOOL isWinning;
@property (nonatomic) NSString* auctionName;
@property (nonatomic) NSNumber* amount;
@property (nonatomic) NSString* imageURL;


@end
