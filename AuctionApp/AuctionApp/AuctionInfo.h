//
//  AuctionInfo.h
//  Test
//
//  Created by Jon Vazquez on 11/30/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuctionInfo : NSObject

@property (nonatomic) NSString* aucId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* orgId;
@property (nonatomic) NSString* orgName;
@property (nonatomic) NSString* startDate;
@property (nonatomic) NSString* endDate;
@property (nonatomic) NSString* location;
@property (nonatomic) NSInteger status;

@end
