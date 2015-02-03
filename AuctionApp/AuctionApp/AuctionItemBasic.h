//
//  AuctionItemBasic.h
//  AuctionApp
//
//  Created by James Fazio on 2/2/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuctionItemBasic : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* itemID;
@property (nonatomic) NSNumber* currentBid;
@property (nonatomic) BOOL featured;
@property (nonatomic) NSURL* imageURL;


@end
