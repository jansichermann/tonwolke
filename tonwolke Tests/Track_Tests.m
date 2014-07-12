#import <XCTest/XCTest.h>
#import "Track.h"



@interface Track_Tests : XCTestCase

@end



@implementation Track_Tests

- (void)testTrackTitle {
    NSString *title = @"foo";
    Track *t = [Track withDictionary:@{@"title" : title}];
    XCTAssertEqualObjects(title, t.title, @"Expected %@ to equal %@", title, t.title);
}

@end
