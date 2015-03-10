//
//  AuctionItemBasic.m
//  AuctionApp
//
//  Created by James Fazio on 2/2/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import "AuctionItem.h"

@implementation AuctionItem

@synthesize currentBid = _currentBid;  //Must do this

-(NSNumber *)currentBid {
    if (_currentBid == nil || [self.minBid doubleValue] > [_currentBid doubleValue]) {
        return self.minBid;
    } else {
        return _currentBid;
    }
}

@end
