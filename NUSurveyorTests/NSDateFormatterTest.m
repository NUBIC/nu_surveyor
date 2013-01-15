//
//  NSDateFormatterTest.m
//  NUSurveyor
//
//  Created by John Dzak on 1/15/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NSDateFormatterTest.h"
#import "NSDateFormatter+NUAdditions.h"
@implementation NSDateFormatterTest

- (void)testRFC3339Formatter {
    
    // date-fullyear   = 4DIGIT
    // date-month      = 2DIGIT  ; 01-12
    // date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    //                           ; month/year
    // time-hour       = 2DIGIT  ; 00-23
    // time-minute     = 2DIGIT  ; 00-59
    // time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap second
    //                           ; rules
    // time-secfrac    = "." 1*DIGIT
    // time-numoffset  = ("+" / "-") time-hour ":" time-minute
    // time-offset     = "Z" / time-numoffset
    // partial-time    = time-hour ":" time-minute ":" time-second
    //                   [time-secfrac]
    // full-date       = date-fullyear "-" date-month "-" date-mday
    // full-time       = partial-time time-offset
    // date-time       = full-date "T" full-time
    
    NSDateFormatter* f = [NSDateFormatter rfc3339DateFormatter];
    STAssertNotNil([f dateFromString:@"2012-08-06T05:18:00Z"], nil);
    
    STAssertNotNil([f dateFromString:@"2012-08-06T05:18:00+02:00"], nil);
    
    STAssertNotNil([f dateFromString:@"2012-08-06T05:18:00-02:00"], nil);
}

- (void)testDateTimeResponseFormatter {
    NSDateFormatter* f = [NSDateFormatter dateTimeResponseFormatter];

    STAssertNotNil([f dateFromString:@"2012-08-06T05:18Z"], nil);
    
    STAssertNotNil([f dateFromString:@"2012-08-06T05:18+02:00"], nil);
    
    STAssertNotNil([f dateFromString:@"2012-08-06T05:18-02:00"], nil);
}

- (void)testDateResponseFormatter {
    NSDateFormatter* f = [NSDateFormatter dateResponseFormatter];
    
    STAssertNotNil([f dateFromString:@"2012-08-06"], nil);
}

- (void)testTimeResponseFormatter {
    NSDateFormatter* f = [NSDateFormatter timeResponseFormatter];
    
    STAssertNotNil([f dateFromString:@"05:18"], nil);
}

@end
