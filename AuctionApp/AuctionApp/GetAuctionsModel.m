//
//  NonprofitModel.m
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "PickNonprofitModel.h"

@implementation PickNonprofitModel

- (NSMutableArray*) getNonprofits
{
    // Make synchronous request
    NSString* orgsUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/nonprofits";
    id urlData = [ServerConnection getJSONData:orgsUrl];
    
    // Construct collection from response
    NSError* error;
    id nonprofitListJSON = [NSJSONSerialization JSONObjectWithData:urlData
                                                           options:0
                                                             error:&error];
    
    // Create and return NonprofitInfo array
    NSMutableArray* nonprofitsArr = [[NSMutableArray alloc] init];
    
    if ( nonprofitListJSON ) {
        if ( [nonprofitListJSON isKindOfClass:[NSArray class]] ) {
            for ( id nonprofitJSON in nonprofitListJSON ) {
                NonprofitInfo *nonprofit = [[NonprofitInfo alloc] init];
                nonprofit.orgId = [nonprofitJSON valueForKey:@"Id"];
                nonprofit.name = [nonprofitJSON valueForKey:@"Name"];
                
                [nonprofitsArr addObject:nonprofit];
            }
        }
    }
    else {
        NSLog(@"Error serializing JSON: %@", error);
    }
    
    return nonprofitsArr;
}

- (NSMutableArray*) getAuctions:(NSString*)nonprofitId {
    
    NSMutableArray* auctions = [[NSMutableArray alloc] init];
    
    
    // Make synchronous request
    NSString* orgsUrl = @"https://schooolyardbooleans-developer-edition.na16.force.com/public/services/apexrest/nonprofits";
    id urlData = [ServerConnection getJSONData:orgsUrl];
    
    // Construct collection from response
    NSError* error;
    id nonprofitListJSON = [NSJSONSerialization JSONObjectWithData:urlData
                                                           options:0
                                                             error:&error];
    
    // Add to and return NonprofitInfo array
    
    if ( nonprofitListJSON ) {
        if ( [nonprofitListJSON isKindOfClass:[NSArray class]] ) {
            for ( id nonprofitJSON in nonprofitListJSON ) {
                
                NSString* orgId = [nonprofitJSON valueForKey:@"Id"];
                if ([orgId isEqualToString:nonprofitId]) {
                    NSArray *auctionListJSON = [nonprofitJSON valueForKey:@"auctions"];
                    
                    if ([auctionListJSON isKindOfClass:[NSArray class]]) {
                        for (id auctionJSON in auctionListJSON) {
                            AuctionInfo* add = [[AuctionInfo alloc] init];
                            add.aucId = [auctionJSON valueForKey:@"Id"];
                            add.name = [auctionJSON valueForKey:@"Name"];
                            add.orgId = [auctionJSON valueForKey:@"Hosting_Nonprofit__c"];
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

@end
