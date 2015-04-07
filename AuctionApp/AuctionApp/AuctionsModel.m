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
                    NSDictionary *itemDictionary = [(NSDictionary *) itemJSON valueForKey:@"item"];
                    AuctionItem *item = [[AuctionItem alloc] init];
                    
                    
                    item.name = [itemDictionary valueForKey:@"Name"];
                    item.descrip = [itemDictionary valueForKey:@"Description__c"];
                    item.itemID = [itemDictionary valueForKey:@"Id"];
                    item.minBid = [itemDictionary valueForKey:@"Starting_Bid__c"];
                    item.currentBid = [itemDictionary valueForKey:@"Current_Bid__c"];
                    item.featured = [[itemDictionary valueForKey:@"Featured__c"] boolValue];
                    item.imageURL = [itemDictionary valueForKey:@"Image_URL__c"];
                    item.sponsorName = [itemDictionary valueForKey:@"Sponsor_Name"];
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
                        
                        NSString *orgId = [nonprofitJSON valueForKey:@"Id"];
                        NSString *orgName = [nonprofitJSON valueForKey:@"Name"];
                        id auctionListJSON = [nonprofitJSON valueForKey:@"auctions"];
                        
                        // Make sure json is expected type Array
                        if ([auctionListJSON isKindOfClass:[NSArray class]]) {
                            NSArray *auctionListArray = (NSArray *) auctionListJSON;
                            
                            for (id auctionJSON in auctionListArray) {
                                AuctionInfo *add = [[AuctionInfo alloc] init];
                                // Don't show auctions that have completed
                                if (![[auctionJSON valueForKey:@"Status"] isEqualToNumber:[NSNumber numberWithInt:COMPLETE]]) {
                                    add.aucId = [auctionJSON valueForKey:@"Id"];
                                    add.name = [auctionJSON valueForKey:@"Name"];
                                    add.startDate = [auctionJSON valueForKey:@"Start_Time"];
                                    add.status = [[auctionJSON valueForKey:@"Status"] integerValue];
                                    add.endDate = [auctionJSON valueForKey:@"End_Time"];
                                    add.location = [auctionJSON valueForKey:@"location"];
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
                
                    id itemsJSON = [auctionDictionary valueForKey:@"Auction_Items__r"];
                    // Make sure auction has items
                    if (itemsJSON) {
                        // Make sure auction items are in the right format Dictionary
                        if ([itemsJSON isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *itemsDictionary = (NSDictionary *) itemsJSON;
                        
                            id recordsJSON = [itemsDictionary valueForKey:@"records"];
                            if ([recordsJSON isKindOfClass:[NSArray class]]) {
                                NSArray *recordsList = (NSArray *) recordsJSON;
                                
                                for (id record in recordsList) {
                                    AuctionItem *add = [[AuctionItem alloc] init];
                                
                                    add.name = [record valueForKey:@"Name"];
                                    add.descrip = [record valueForKey:@"Description__c"];
                                    add.itemID = [record valueForKey:@"Id"];
                                    add.minBid = [record valueForKey:@"Starting_Bid__c"];
                                    add.currentBid = [record valueForKey:@"Current_Bid__c"];
                                    add.featured = [[record valueForKey:@"Featured__c"] boolValue];
                                    add.imageURL = [record valueForKey:@"Image_URL__c"];
                                    add.sponsorName = [[record valueForKey:@"Item_Sponsor__r"] valueForKey:@"Name"];
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
                    
                    BOOL success = [[retDictionary valueForKey:@"success"] boolValue];
                    callback(success, nil);
                    return;
                }
            }
            
        }
        
        callback(NO, @"Unable to send bid, please retry");
    }];
}

-(void) getCurrentBidForItem:(NSString *) itemID callback:(void (^)(NSNumber *, NSString *))callback {
     NSMutableString *bidURL = [NSMutableString stringWithString:ITEM_URL];
    
    [bidURL appendString:@"/"];
    [bidURL appendString:itemID];
    
    [ServerConnection httpGET:bidURL :^(id retJSON, NSString *error) {
        if (error == nil) {
            if (retJSON) {
                if ([retJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *retDictionary = (NSDictionary *) [retJSON valueForKey: @"item"];
                    NSNumber *currentBid = [retDictionary valueForKey:@"Current_Bid__c"];
                    NSNumber *minBid = [retDictionary valueForKey:@"Starting_Bid__c"];
                    
                    if (currentBid == nil || [minBid doubleValue] > [currentBid doubleValue]) {
                        callback(minBid, nil);
                    } else {
                        callback(currentBid, nil);
                    }
                    return;
                }
            }
        }
        
        callback(nil, @"Unable to connect to server");
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
                            bid.itemName = [record valueForKey:@"Name"];
                            bid.itemID = [record valueForKey:@"ItemId"];
                            bid.isWinning = [[record valueForKey:@"isWinning"] boolValue];
                            bid.auctionName = [record valueForKey:@"AuctionName"];
                            bid.amount = [record valueForKey:@"amount"];
                            bid.imageURL = [record valueForKey:@"ImageURL"];
                            
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
