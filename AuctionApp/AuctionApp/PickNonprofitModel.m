//
//  NonprofitModel.m
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import "PickNonprofitModel.h"

@implementation PickNonprofitModel

- (NSMutableArray*) getNonprofits {
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
                nonprofit.id = [nonprofitJSON valueForKey:@"Id"];
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

@end
