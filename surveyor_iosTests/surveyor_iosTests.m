//
//  surveyor_iosTests.m
//  surveyor_iosTests
//
//  Created by Mark Yoon on 4/19/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "surveyor_iosTests.h"
#import "UUID.h"

@implementation surveyor_iosTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testUUID{
  NSString *str = [UUID generateUuidString];
  STAssertEquals([str length], (NSUInteger)36, @"UUID length should be 36");
}


@end
