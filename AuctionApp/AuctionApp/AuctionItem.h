//
//  AuctionItemBasic.h
//  AuctionApp
//
//  Created by James Fazio on 2/2/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

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


@end
