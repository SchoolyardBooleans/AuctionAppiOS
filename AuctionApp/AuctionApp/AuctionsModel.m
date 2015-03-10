#import "AuctionsModel.h"

int const BEFORE = 0;
int const IN_PROGRESS = 1;
int const COMPLETE = 2;

@implementation AuctionsModel

-(void) getAuctionItem:(NSString *)itemId :(void (^)(AuctionItem *item, NSString *error))callback {
    NSMutableString *itemURL = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/auctionitems/"];
    
    [itemURL appendString:itemId];
    
    // Make synchronous request
    [ServerConnection httpGET:itemURL :^(id itemJSON, NSString* error) {
        if (error == nil) {
            // Add to and return NonprofitInfo array
            if (itemJSON) {
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
                    item.sponsorName = [itemDictionary valueForKey:@"Sponsor_Name__c"];
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
   // NSError *error;
    NSString *nonprofitURL = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/nonprofits";
    
    // Make synchronous request
    [ServerConnection httpGET:nonprofitURL :^(id nonprofitListJSON, NSString* error) {
        if (error == nil) {
            // Add to and return NonprofitInfo array
            if (nonprofitListJSON) {
                if ([nonprofitListJSON isKindOfClass:[NSArray class]]) {
                    for (id nonprofitJSON in nonprofitListJSON) {
                        
                        NSString *orgId = [nonprofitJSON valueForKey:@"Id"];
                        NSString *orgName = [nonprofitJSON valueForKey:@"Name"];
                        id auctionListJSON = [nonprofitJSON valueForKey:@"auctions"];
                        
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

-(void) getAuctionItems:(NSString *)auctionID :(void (^)(NSMutableArray *, NSString *))callback {
    NSMutableArray *auctionItems = [[NSMutableArray alloc] init];
    NSMutableString *auctionURL = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/auctions/"];
    
    [auctionURL appendString:auctionID];
    
    // Make synchronous request
    [ServerConnection httpGET:auctionURL :^(id auctionJSON, NSString* error) {
        // Add to and return NonprofitInfo array
        if (error == nil) {
            if (auctionJSON) {
                if ([auctionJSON isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *auctionDictionary = (NSDictionary *) auctionJSON;
                
                    id itemsJSON = [auctionDictionary valueForKey:@"Auction_Items__r"];
                    if (itemsJSON) {
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
                                    add.sponsorName = [record valueForKey:@"Sponsor_Name__c"];
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

-(void) makeBid:(NSString *)itemID :(NSString *)amount :(NSString *)bidderID :(void (^)(BOOL, NSString *))callback {
    NSMutableString *bidURL = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/auctionitems/"];
    NSDictionary *body = [[NSMutableDictionary alloc] init];
    
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

-(void) getCurrentBid:(NSString *) itemID :(void (^)(NSNumber *, NSString *))callback {
     NSMutableString *bidURL = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/auctionitems/"];
    
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
    NSMutableString *bidsURL = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/bidders/"];
    NSMutableArray *bids = [[NSMutableArray alloc] init];
    
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


// Get the status message for an auction. Returns the end datetime
// if the auction is in progress or the start time if the auction
// occurs in the future
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
