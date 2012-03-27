//
//  NUResponsetSetTest.m
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseSetTest.h"
#import "NUResponseSet.h"
#import "NUSurvey.h"
#import "NSDateFormatter+Additions.h"

@implementation NUResponseSetTest

NUResponseSet* rs;
NSDate* createdAt;
NSDate* completedAt;

- (void)setUp {
    [super setUp];
    createdAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1970-02-04T05:15:30Z"];
    completedAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1990-03-06T07:21:42Z"];
    
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs setValue:@"OVAL" forKey:@"uuid"];
    [rs setValue:createdAt forKey:@"createdAt"];
    [rs setValue:completedAt forKey:@"completedAt"];
    
    [rs newResponseForQuestion:@"abc" Answer:@"123" Value:@"foo"];
    [rs newResponseForQuestion:@"xyz" Answer:@"456" Value:@"bar"];
}

- (void)testSanity {
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:[NSDictionary dictionary] withModel:self.model inContext:self.ctx];
    [rs newResponseForIndexQuestion:@"abc" Answer:@"123"];
    
    STAssertEquals(1U, [[rs responsesForQuestion:@"abc" Answer:@"123"] count], @"Should have one element");
}

- (void)testToDict {
    NSDictionary* actual = [rs toDict];
    STAssertEqualObjects([actual objectForKey:@"uuid"], @"OVAL", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"survey_id"], @"RECT", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"created_at"], @"1970-02-04T05:15:30Z", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"completed_at"], @"1990-03-06T07:21:42Z", @"Wrong value");
    STAssertEquals([[actual objectForKey:@"responses"] count], 2U, @"Wrong size");
}

- (void) testToJson {
    NSString* actual = [rs toJson];
    STAssertTrue([actual rangeOfString:@"\"uuid\":\"OVAL\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"survey_id\":\"RECT\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"created_at\":\"1970-02-04T05:15:30Z\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"completed_at\":\"1990-03-06T07:21:42Z\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"responses\":["].location != NSNotFound, @"Should exist");
}

@end
