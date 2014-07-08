#import <XCTest/XCTest.h>
#import "AuthTokenParser.h"



/**
 Created by jan on 7/8/14. Copyright (c) 2014 Jan Sichermann. All rights reserved.
 */


@interface AuthTokenParser()
+ (NSString *)_parseUrlString:(NSString *)urlString
              forValueFromKey:(NSString *)key;
@end



@interface AuthTokenParser_Tests : XCTestCase

@end



@implementation AuthTokenParser_Tests

+ (NSDictionary *)_testUrls {
    return @{@"abc?code=123" : @"123",
             @"abc?code=&foo=bar" : [NSNull null], //empty value
             @"abc?code=123&foo=bar" : @"123",
             @"?code=123" : @"123",
             @"?code=&foo=bar" : [NSNull null],
             @"code=123&foo=bar" : @"123",
             @"http://some.url.com/?foo=bar&code=123&fruit=bat" : @"123",
             @"foocodebar=123" : [NSNull null],
             @(123) : [NSNull null],
             @[] : [NSNull null],
             @{@"code":@"1234"} : [NSNull null]
             };
}

- (void)testParse {
    NSDictionary *testUrls = [self.class _testUrls];
    
    for (NSString *key in testUrls) {
        NSObject *expectedValue = testUrls[key];
        NSObject *returnedValue = [AuthTokenParser _parseUrlString:key
                                                   forValueFromKey:@"code"];
        if (expectedValue.class == [NSNull class]) {
            XCTAssertNil(returnedValue, @"Expected %@ to return nil", key);
        }
        else {
            XCTAssertEqualObjects(expectedValue, returnedValue, @"Expected %@ to equal %@", expectedValue, returnedValue);
        }
    }
}

@end
