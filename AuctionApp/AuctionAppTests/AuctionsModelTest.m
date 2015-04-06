//
//  AuctionsModelTest.m
//  AuctionApp
//
//  Created by James Fazio on 4/5/15.
//  Copyright (c) 2015 Schoolyard Booleans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AuctionsModel.h"

@interface AuctionsModelTest : XCTestCase

@end

@implementation AuctionsModelTest {
    AuctionsModel *model;
}

- (void)setUp {
    [super setUp];
    model = [[AuctionsModel alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAuctionItem {
    // Make sure an error occurs when an auction id does not exist
    [model getAuctionItemForId:@"000" callback:^(AuctionItem *item, NSString *error) {
        XCTAssertNotNil(error);
    }];
    
    //Figure out a way to test getting an actual auction
}

-(void)testGetAuctions {
    [model getAuctions:^(NSMutableArray *auctions, NSString *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(auctions);
    }];
}



@end
