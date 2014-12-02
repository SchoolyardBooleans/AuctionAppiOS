//
//  NonprofitInfo.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#ifndef Test_NonprofitInfo_h
#define Test_NonprofitInfo_h

#include <Foundation/Foundation.h>

@interface NonprofitInfo : NSObject

@property (nonatomic) NSString* orgId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSMutableArray* auctions;

@end

#endif
