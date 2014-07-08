#import <XCTest/XCTest.h>
#import "KeychainManager.h"



@interface Keychain_Tests : XCTestCase

@end



@implementation Keychain_Tests

- (void)testUpdate {
    NSString *testValue = @"12321";
    NSString *testKey = @"testKey";
    
    [KeychainManager setString:testValue
                        forKey:testKey];
    NSString *returnedValue = [KeychainManager stringForKey:testKey];
    XCTAssertEqualObjects(testValue, returnedValue, @"Expected %@ to equal %@", testValue, returnedValue);
}

- (void)testDelete {
    NSString *v = @"bar";
    NSString *k = @"bar";
    [KeychainManager setString:v
                        forKey:k];
    XCTAssertNotNil([KeychainManager stringForKey:k], @"Expected %@ to not be nil", k);
    [KeychainManager deleteItemForKey:k];
    XCTAssertNil([KeychainManager stringForKey:k], @"Expected %@ to be nil", k);
}

@end
