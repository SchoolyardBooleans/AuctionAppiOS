#import <XCTest/XCTest.h>
#import "AccountUtility.h"

@interface AccountUtilityTest : XCTestCase

@end

@implementation AccountUtilityTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Remove user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    [super tearDown];
}

- (void) login {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Bill",@"first",@"Nye",@"last",@"123",@"Id", nil];
    
    [AccountUtility login:dict];
}

-(void) setCode {
    [AccountUtility setCode:@"blah"];
}

- (void)testLogin {
    [self login];
    
    XCTAssertEqualObjects(@"Bill", [[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"]);
    XCTAssertEqualObjects(@"Nye", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"]);
    XCTAssertEqualObjects(@"123", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
}

-(void) testSetCode {
    [self setCode];
    
    XCTAssertEqualObjects(@"blah", [[NSUserDefaults standardUserDefaults] objectForKey:@"code"]);
}

-(void) testLogout {
    [self login];
    
    [AccountUtility logout];
    
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"]);
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"]);
}

-(void) testRemoveCode {
    [self setCode];
    
    [AccountUtility removeCode];
    
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"code"]);
}

-(void) testGetId {
    [self login];
    
    XCTAssertEqualObjects(@"123", [AccountUtility getId]);
    
}

-(void) testGetName {
    [self login];
    
    XCTAssertEqualObjects(@"Bill Nye", [AccountUtility getName]);
}

-(void) testLoggedIn {
    XCTAssertFalse([AccountUtility loggedIn]);
    
    [self login];
    
    XCTAssertTrue([AccountUtility loggedIn]);
}

@end
