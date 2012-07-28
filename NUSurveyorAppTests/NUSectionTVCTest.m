//
//  NUSectionTVCTest.m
//  NUSurveyor
//
//  Created by John Dzak on 7/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSectionTVCTest.h"

#import "NUAppDelegate.h"
#import "NUSectionTVC.h"
#import "JSONKit.h"
#import "NUSurvey.h"
#import "NUConstants.h"

@implementation NUSectionTVCTest

static NUSectionTVC* t;

- (void) setUp {
    t = [[NUSectionTVC alloc] initWithStyle:UITableViewStyleGrouped];
    
    NUAppDelegate* delegate = ((NUAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    NSEntityDescription *entity = [[[delegate managedObjectModel] entitiesByName] objectForKey:@"ResponseSet"];

    NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:[delegate managedObjectContext]];
    
    t.responseSet = rs;
}

- (void)testAppDelegate {
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

- (void)testNoRows {
    [self useQuestion:nil];
    STAssertNil(t.allSections, @"Should be nil");
    STAssertNil(t.visibleSections, @"Should be nil");
}

- (void)testOneRow {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

- (void)testOneRowIsHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 0U, @"Should have 0 rows");
}

- (void)testRowAttributesForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    STAssertEqualObjects([r objectForKey:@"uuid"], @"xyz", @"Wrong uuid");
    STAssertEqualObjects([r objectForKey:@"show"], NS_YES, @"Should show");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

- (void)testRowAttributesForHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    STAssertEqualObjects([r objectForKey:@"uuid"], @"xyz", @"Wrong uuid");
    STAssertEqualObjects([r objectForKey:@"show"], NS_NO, @"Should show");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

#pragma mark - Helper methods
     
- (void)useQuestion:(NSString*)question {
    t.detailItem = (question == nil) ? nil : [self builder:[NSArray arrayWithObject:question]];
}

- (NSDictionary*)builder:(NSArray*)questions {
    NSString* section = [self createQuestionsAndGroups:questions];
    return [section objectFromJSONStringWithParseOptions:JKParseOptionStrict];
}

- (NSString*)createQuestionsAndGroups:(NSArray*)questions {
    NSString* combined = [questions componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"questions_and_groups\":[%@]}", combined];
}

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid type:(NSString*)type {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"%@\"}", text, uuid, type];
}

/*
 
 1. generate response group id in create rows (take max id + 1)
 2. update generated ids to return response group id
 3. modify delete response to accept response group id
 4. Modify create to accept response set group id
 5. Update did endEdit text methods
 6. Update didSelect on cell classes

*/

@end
