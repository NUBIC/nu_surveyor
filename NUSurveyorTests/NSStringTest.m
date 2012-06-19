#import <SenTestingKit/SenTestingKit.h>

#import "NSString+Additions.h"

@interface NSStringTest : SenTestCase 
@end

@implementation NSStringTest

- (void)testNormalizeWhitespace {
    NSString* pre = @"i said hotel  \n  motel  \r\n   holiday  \r  inn";
    STAssertEqualObjects([pre normalizeWhitespace], @"i said hotel motel holiday inn", @"Whitespace should be normalized");    
}

- (void)testNormalizeWhitespaceWitNormalizedString {
    NSString* pre = @"hello world and universe";
    STAssertEqualObjects([pre normalizeWhitespace], @"hello world and universe", @"Newline characters should be replace with spaces");
}

@end
