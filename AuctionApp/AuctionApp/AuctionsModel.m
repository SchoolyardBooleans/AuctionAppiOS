#import "AuctionsModel.h"

@implementation AuctionsModel

-(void) getAuctionItemForId:(NSString *)itemId callback:(void (^)(AuctionItem *item, NSString *error))callback {
    NSMutableString *itemURL = [NSMutableString stringWithString:ITEM_URL];
    
    [itemURL appendString:@"/"];
    [itemURL appendString:itemId];
    
    // Make synchronous request
    [ServerConnection httpGET:itemURL :^(id itemJSON, NSString* error) {
        if (error == nil) {
            // JSON exists
            if (itemJSON) {
                // JSON is expected type
                if ([itemJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *itemDictionary = [(NSDictionary *) itemJSON valueForKey:ITEM_KEY];
                    AuctionItem *item = [[AuctionItem alloc] init];
                    
                    
                    item.name = [itemDictionary valueForKey:NAME_KEY];
                    item.descrip = [itemDictionary valueForKey:AUCTION_ITEM_DESC_KEY];
                    item.itemID = [itemDictionary valueForKey:ID_KEY];
                    item.minBid = [itemDictionary valueForKey:AUCTION_ITEM_START_BID_KEY];
                    item.currentBid = [itemDictionary valueForKey:AUCTION_ITEM_CUR_BID_KEY];
                    item.featured = [[itemDictionary valueForKey:AUCTION_ITEM_FEATURED_KEY] boolValue];
                    item.imageURL = [itemDictionary valueForKey:AUCTION_ITEM_IMAGE_KEY];
                    item.sponsorName = [[itemDictionary valueForKey:AUCTION_ITEM_SPONSOR_KEY] valueForKey:NAME_KEY];
                    item.status = [[[itemDictionary valueForKey:AUCTION_ITEM_AUCTION_KEY] valueForKey:AUCTION_ITEM_STATUS_KEY] integerValue];
                    callback(item, nil);
                    return;
                }
            }
        }
        callback(nil, error);
        NSLog(@"Error making auction item request %@", error);
    }];
    
}

- (void) getAuctions:(void (^)(NSMutableArray *, NSString *)) callback {
    
    NSMutableArray *auctions = [[NSMutableArray alloc] init];
    NSString *nonprofitURL = NONPROFIT_URL;
    
    // Make synchronous request
    [ServerConnection httpGET:nonprofitURL :^(id nonprofitListJSON, NSString* error) {
        if (error == nil) {
            // Make sure JSON exists
            if (nonprofitListJSON) {
                // Make sure JSON is expected type Array
                if ([nonprofitListJSON isKindOfClass:[NSArray class]]) {
                    for (id nonprofitJSON in nonprofitListJSON) {
                        
                        NSString *orgId = [nonprofitJSON valueForKey:ID_KEY];
                        NSString *orgName = [nonprofitJSON valueForKey:NAME_KEY];
                        id auctionListJSON = [nonprofitJSON valueForKey:AUCTIONS_KEY];
                        
                        // Make sure json is expected type Array
                        if ([auctionListJSON isKindOfClass:[NSArray class]]) {
                            NSArray *auctionListArray = (NSArray *) auctionListJSON;
                            
                            for (id auctionJSON in auctionListArray) {
                                AuctionInfo *add = [[AuctionInfo alloc] init];
                                // Don't show auctions that have completed
                                if (![[auctionJSON valueForKey:AUCTION_STATUS_KEY] isEqualToNumber:[NSNumber numberWithInt:COMPLETE]]) {
                                    add.aucId = [auctionJSON valueForKey:ID_KEY];
                                    add.name = [auctionJSON valueForKey:NAME_KEY];
                                    add.startDate = [auctionJSON valueForKey:AUCTION_START_KEY];
                                    add.status = [[auctionJSON valueForKey:AUCTION_STATUS_KEY] integerValue];
                                    add.endDate = [auctionJSON valueForKey:AUCTION_END_KEY];
                                    add.location = [auctionJSON valueForKey:AUCTION_LOCATION_KEY];
                                    add.orgId = orgId;
                                    add.orgName = orgName;
                                    [auctions addObject:add];
                                }
                            }
                        }
                    }
                }
            }
            
            callback(auctions, nil);
        }
        else {
            callback(auctions, error);
            NSLog(@"Error making nonprofits request %@", error);
        }
    }];
}

-(void) getAuctionItemsForId:(NSString *)auctionID callback:(void (^)(NSMutableArray *, NSString *))callback {
    NSMutableArray *auctionItems = [[NSMutableArray alloc] init];
    NSMutableString *auctionURL = [NSMutableString stringWithString:AUCTION_URL];
    
    [auctionURL appendString:@"/"];
    [auctionURL appendString:auctionID];
    
    // Make synchronous request
    [ServerConnection httpGET:auctionURL :^(id auctionJSON, NSString* error) {
        if (error == nil) {
            // Make sure JSON exists
            if (auctionJSON) {
                // Make sure JSON is expected type Dictionary
                if ([auctionJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *auctionDictionary = (NSDictionary *) auctionJSON;
                
                    id itemsJSON = [auctionDictionary valueForKey:AUCTION_ITEMS_KEY];
                    // Make sure auction has items
                    if (itemsJSON) {
                        // Make sure auction items are in the right format Dictionary
                        if ([itemsJSON isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *itemsDictionary = (NSDictionary *) itemsJSON;
                        
                            id recordsJSON = [itemsDictionary valueForKey:RECORDS_KEY];
                            if ([recordsJSON isKindOfClass:[NSArray class]]) {
                                NSArray *recordsList = (NSArray *) recordsJSON;
                                
                                for (id record in recordsList) {
                                    AuctionItem *add = [[AuctionItem alloc] init];
                                
                                    add.status = [[auctionDictionary valueForKey:AUCTION_ITEM_STATUS_KEY] integerValue];
                                    add.name = [record valueForKey:NAME_KEY];
                                    add.descrip = [record valueForKey:AUCTION_ITEM_DESC_KEY];
                                    add.itemID = [record valueForKey:ID_KEY];
                                    add.minBid = [record valueForKey:AUCTION_ITEM_START_BID_KEY];
                                    add.currentBid = [record valueForKey:AUCTION_ITEM_CUR_BID_KEY];
                                    add.featured = [[record valueForKey:AUCTION_ITEM_FEATURED_KEY] boolValue];
                                    add.imageURL = [record valueForKey:AUCTION_ITEM_IMAGE_KEY];
                                    add.sponsorName = [[record valueForKey:AUCTION_ITEM_SPONSOR_KEY] valueForKey:NAME_KEY];
                                    [auctionItems addObject:add];
                                }
                            }
                        }
                    }
                }
            }
            
            callback(auctionItems, nil);
        }
        else {
            callback(auctionItems, error);
        }
    }];
}

-(void) makeBidForItem:(NSString *)itemID withAmount:(NSString *)amount withBidderId:(NSString *)bidderID callback:(void (^)(BOOL, NSString *))callback {
    NSMutableString *bidURL = [NSMutableString stringWithString:ITEM_URL];
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
    [bidURL appendString:@"/"];
    [bidURL appendString:itemID];
    [bidURL appendString: @"/bid"];
    
    [body setValue:amount forKey:@"Amount"];
    [body setValue:bidderID forKey:@"BidderId"];
    
    [ServerConnection httpPOST:bidURL :body :^(id retJSON, NSString *error) {
        if (error == nil) {
            if (retJSON) {
                if ([retJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *retDictionary = (NSDictionary *) retJSON;
                    
                    BOOL success = [[retDictionary valueForKey:SUCCESS_KEY] boolValue];
                    callback(success, nil);
                    return;
                }
            }
            
        }
        
        callback(NO, @"Unable to send bid, please retry");
    }];
}

-(void)getBidsForUser:(NSString *)bidderID :(void (^)(NSMutableArray *, NSString *))callback {
    NSMutableString *bidsURL = [NSMutableString stringWithString:BIDDER_URL];
    NSMutableArray *bids = [[NSMutableArray alloc] init];
    
    [bidsURL appendString:@"/"];
    [bidsURL appendString:bidderID];
    
    [ServerConnection httpGET:bidsURL :^(id retJSON, NSString *error) {
        if (error == nil) {
            if (retJSON) {
                if ([retJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *retDictionary = (NSDictionary *) retJSON;
                    id bidsJSON = [retDictionary valueForKey:@"bids"];
                    
                    if ([bidsJSON isKindOfClass:[NSArray class]]) {
                        NSArray *bidsArray = (NSArray *) bidsJSON;
                        
                        for (id record in bidsArray) {
                            Bid *bid = [[Bid alloc] init];
                            bid.itemName = [record valueForKey:NAME_KEY];
                            bid.itemID = [record valueForKey:BID_ID_KEY];
                            bid.isWinning = [[record valueForKey:BID_WINNING_KEY] boolValue];
                            bid.auctionName = [record valueForKey:BID_AUCTION_NAME_KEY];
                            bid.amount = [record valueForKey:BID_AMOUNT_KEY];
                            bid.imageURL = [record valueForKey:BID_IMAGE_KEY];
                            
                            [bids addObject:bid];
                        }
                        
                        callback(bids, nil);
                        return;
                    }
                }
            }
        }
        
        callback(nil, @"Unable to connect to server");
    }];
    
}

- (NSString *) statusMessageForAuction:(AuctionInfo *)auction {
    NSMutableString *retVal;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc] init];
    // ISO format
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    if (auction.status == BEFORE) {
        retVal = [NSMutableString stringWithString:@"Auction begins on "];
        date = [df dateFromString:auction.startDate];
    } else {
        retVal = [NSMutableString stringWithString:@"Auction ends on "];
        date = [df dateFromString:auction.endDate];
    }
    
    [df setDateFormat: @"eeee, MMM dd @ hh:mm a"];
    [retVal appendString: [df stringFromDate:date]];
    
    return retVal;
}

@end
