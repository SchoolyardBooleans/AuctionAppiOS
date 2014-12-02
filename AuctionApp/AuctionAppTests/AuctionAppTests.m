//
//  AuctionAppTests.m
//  AuctionAppTests
//
//  Created by Jon Vazquez on 11/9/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PickNonprofitModel.h"

@interface AuctionAppTests : XCTestCase

@end

@implementation AuctionAppTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetNonprofits {
    PickNonprofitModel* nonprofitModel = [[PickNonprofitModel alloc] init];
    NSMutableArray* nonprofits = [nonprofitModel getNonprofits];
    NonprofitInfo* LARedCross = [nonprofits objectAtIndex:0];
    
    XCTAssert([LARedCross.name isEqualToString:@"Los Angeles Red Cross"], @"Pass");
}

- (void)testGetAuctions {
    PickNonprofitModel* nonprofitModel = [[PickNonprofitModel alloc] init];
    NSMutableArray* nonprofits = [nonprofitModel getNonprofits];
    NonprofitInfo* nonprofit = [nonprofits objectAtIndex:0];
    NSMutableArray* auctions = [nonprofitModel getAuctions:nonprofit.orgId];
    AuctionInfo* auction = [auctions objectAtIndex:0];
    
    XCTAssert([auction.name isEqualToString:@"Breast Cancer Awareness Rodeo"], @"Pass");
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
