//
//  NonprofitModel.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonprofitInfo.h"
#import "ServerConnection.h"

@interface PickNonprofitModel : NSObject

/**
 Returns a NonprofitInfo NSMutableArray, each entry containing an id and a name
 */
- (NSMutableArray*) getNonprofits;

@end
