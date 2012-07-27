//
//  NUSectionTVCTest.m
//  NUSurveyor
//
//  Created by John Dzak on 7/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSectionTVCTest.h"

#import "NUSectionTVC.h"
#import "JSONKit.h"
#import "NUSurvey.h"

@implementation NUSectionTVCTest

// All code under test is in the iOS Application
- (void)testAppDelegate {
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testNoRows {
    NUSectionTVC* t = [NUSectionTVC new];
    t.detailItem = nil;
    STAssertNil(t.allSections, @"Should be nil");
    STAssertNil(t.visibleSections, @"Should be nil");
}

- (void)testOneRow {
    NUSectionTVC* t = [[NUSectionTVC alloc] initWithStyle:UITableViewStyleGrouped];
    NSString* q = @"{\"questions_and_groups\":[{\"text\":\"These questions are examples of the basic supported input types\",\"uuid\":\"764f9400-4540-012f-9ea4-00254bc472f4\",\"type\":\"label\"}]}";
    t.detailItem = [q objectFromJSONStringWithParseOptions:JKParseOptionStrict];
    STAssertEquals(1U, [t.allSections count], @"Should have one row");
    STAssertEquals(1U, [t.visibleSections count], @"Should have one row");
}

@end
