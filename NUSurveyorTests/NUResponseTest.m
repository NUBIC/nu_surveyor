//
//  NUResponseTest.m
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseTest.h"
#import "NUResponseSet.h"
#import "NUResponse.h"
#import "NSDateFormatter+Additions.h"

@implementation NUResponseTest

NUResponse* response;
NSDate* createdAt;
NSDate* modifiedAt;

- (void)setUp {
    [super setUp];
    
    createdAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1970-02-04T05:15:30Z"];
    modifiedAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1990-03-06T07:21:42Z"];

    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    response = [rs newResponseForQuestion:@"abc" Answer:@"123" Value:@"foo"];
    [response setValue:@"OCT" forKey:@"uuid"];
    [response setValue:createdAt forKey:@"createdAt"];
    [response setValue:modifiedAt forKey:@"modifiedAt"];
}

- (void)testSanity {
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:[NSDictionary dictionary] withModel:self.model inContext:self.ctx];
    [rs newResponseForIndexQuestion:@"abc" Answer:@"123"];
        
    STAssertEquals(1U, [[rs responsesForQuestion:@"abc" Answer:@"123"] count], @"Should have one element");
}

- (void)testToDict {
    NSDictionary* actual = [response toDict];
    STAssertEqualObjects([actual objectForKey:@"value"], @"foo", @"Wrong value");    
    STAssertEqualObjects([actual objectForKey:@"answer_id"], @"123", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"question_id"], @"abc", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"uuid"], @"OCT", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"created_at"], @"1970-02-04T05:15:30Z", @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"modified_at"], @"1990-03-06T07:21:42Z", @"Wrong value");
}

- (void)testToJson {
    NSString* actual = [response toJson];
    STAssertTrue([actual rangeOfString:@"\"value\":\"foo\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"answer_id\":\"123\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"question_id\":\"abc\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"uuid\":\"OCT\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"created_at\":\"1970-02-04T05:15:30Z\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"modified_at\":\"1990-03-06T07:21:42Z\""].location != NSNotFound, @"Should exist");
}

@end
