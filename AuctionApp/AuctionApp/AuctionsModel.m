#import "AuctionsModel.h"

int const BEFORE = 0;
int const IN_PROGRESS = 1;
int const COMPLETE = 2;

@implementation AuctionsModel

- (NSMutableArray *) getAuctions {
    
    NSMutableArray *auctions = [[NSMutableArray alloc] init];
    NSError *error;
    NSString *orgsUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/nonprofits";
    
    // Make synchronous request
    id urlData = [ServerConnection getJSONData:orgsUrl];
    
    // Construct collection from response
    id nonprofitListJSON = [NSJSONSerialization JSONObjectWithData:urlData
                                                           options:0
                                                             error:&error];
    
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
    else {
        NSLog(@"Error serializing JSON: %@", error);
    }
    
    return auctions;
}

- (NSMutableArray *)getAuctionItems:(NSString *)auctionID {
    NSMutableArray *auctionItems = [[NSMutableArray alloc] init];
    NSError *error;
    NSMutableString *auctionUrl = [NSMutableString stringWithString:@"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/auctions/"];
    
    [auctionUrl appendString:auctionID];
    
    // Make synchronous request
    id urlData = [ServerConnection getJSONData:auctionUrl];
    
    // Construct collection from response
    id auctionJSON = [NSJSONSerialization JSONObjectWithData:urlData
                                                           options:0
                                                             error:&error];
    
    // Add to and return NonprofitInfo array
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
                            AuctionItemBasic *add = [[AuctionItemBasic alloc] init];
                            
                            add.name = [record valueForKey:@"Name"];
                            add.itemID = [record valueForKey:@"Id"];
                            add.currentBid = [record valueForKey:@"Current_Bid__c"];
                            add.featured = [[record valueForKey:@"Featured__c"] boolValue];
                            add.imageURL = [record valueForKey:@"Image_URL__c"];
                            [auctionItems addObject:add];
                        }
                        
                    }
                }
            }
        }
    }
    else {
        NSLog(@"Error serializing JSON: %@", error);
    }
    
    return auctionItems;
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