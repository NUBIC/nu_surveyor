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

@implementation NUResponseTest

NUResponse* response;

- (void)setUp {
    [super setUp];

    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    response = [rs newResponseForQuestion:@"abc" Answer:@"123" Value:@"foo"];
    [response setValue:@"OCT" forKey:@"uuid"];
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
}

- (void)testToJson {
    NSString* actual = [response toJson];
    STAssertTrue([actual rangeOfString:@"\"value\":\"foo\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"answer_id\":\"123\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"question_id\":\"abc\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"uuid\":\"OCT\""].location != NSNotFound, @"Should exist");
}

@end
