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
    NSString *validFirst = @"Toby", *invalidFirst = @"_bill";
    NSString *validLast = @"Keith", *invalidLast = @"45john";
    NSString *validEmail = @"james@thefazios.com", *validEmail2 = @"bob4@cox.net", *invalidEmail = @"joe_rickdog.com";
    
    XCTAssertEqual(YES, [model validate:validFirst :validLast :validEmail]);
    XCTAssertEqual(YES, [model validate:validFirst :validLast :validEmail2]);
    XCTAssertEqual(NO, [model validate:invalidFirst :validLast :validEmail]);
    XCTAssertEqual(NO, [model validate:validFirst :invalidLast :validEmail]);
    XCTAssertEqual(NO, [model validate:validFirst :validLast :invalidEmail]);
}

-(void)testLogin {
    [model login:@"james@thefazios.com" :^(NSDictionary* json, NSString *error) {
        XCTAssertNotNil(json);
        XCTAssertNil(error);
    }];
    
    [model login:@"dude@duely.co.uk" :^(NSDictionary* json, NSString *error) {
        XCTAssertEqual(0, [json count]);
        XCTAssertNotNil(error);
    }];
}

@end
