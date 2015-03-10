//
//  AuctionAppTests.m
//  AuctionAppTests
//
//  Created by Jon Vazquez on 11/9/14.
//  Copyright (c) 2014 Schoolyard Booleans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ServerConnection.h"
#import "RegisterModel.h"

@interface RegisterModelTest : XCTestCase

@end

@implementation RegisterModelTest {
    RegisterModel *model;
}

- (void)setUp {
    [super setUp];
    model = [[RegisterModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidation {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    [model validate:<#(NSString *)#> :<#(NSString *)#> :<#(NSString *)#>]
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
