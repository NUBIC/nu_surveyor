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

- (void)testRowForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

- (void)testRowsForRepeater {
    NSString* q = [self createQuestionWithText:@"Car" uuid:@"abc" type:@"text"];
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"" question:q]];
    STAssertEquals([t.allSections count], 2U, @"Should have 2 rows");
    STAssertEquals([t.visibleSections count], 2U, @"Should have 2 rows");
}

- (void)testOneRowIsHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 0U, @"Should have 0 rows");
}

- (void)testRowAttributesForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    [self assertRow:r hasUUID:@"xyz" show:YES];
}

- (void)testRowAttributesForHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    [self assertRow:r hasUUID:@"xyz" show:NO];
}

- (void)testRowAttributesForRepeater {
    NSString* q = [self createQuestionWithText:@"Car" uuid:@"abc" type:@"text"];
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:q]];
    NSDictionary* r = [t.allSections objectAtIndex:1];
    [self assertRow:r hasUUID:@"abc" show:YES];
}

- (void)testIndexOfQuestionOrGroupWithUUID {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals((NSUInteger)[t performSelector:@selector(indexOfQuestionOrGroupWithUUID:) withObject:@"xyz"], 0U, @"Wrong index");
}

- (void)testIdsForIndexPathForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSUInteger indexArr[] = {0,0};
    NSDictionary* r = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathWithIndexes:indexArr length:2]];
    STAssertEquals([[r allKeys] count], 0U, @"Wrong number of attributes");
}

- (void)testIdsForIndexPathForStringAnswer {
    NSString* q = [self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" answer:
                   [self createAnswerWithText:@"Location" uuid:@"abc" type:@"string"]];
    [self useQuestion:q];
    NSDictionary* r = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    STAssertEquals([[r allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([r objectForKey:@"aid"], @"abc", @"Wrong aid");
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

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid answer:(NSString*)answer {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"answers\": [%@]}", text, uuid, answer];
}

- (NSString*)createQuestionRepeaterWithText:text uuid:uuid question:question {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"repeater\", \"questions\": [%@]}", text, uuid, question];
}

- (NSString*)createAnswerWithText:(NSString*)text uuid:(NSString*)uuid type:(NSString*)type {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"%@\"}", text, uuid, type];
}

- (void)assertRow:(NSDictionary*)r hasUUID:(NSString*)uuid show:(BOOL)show {
    STAssertEquals([[r allKeys] count], 3U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"uuid"], uuid, @"Wrong uuid");
    STAssertEqualObjects([r objectForKey:@"show"], [NSNumber numberWithBool:show], @"Should show");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

/*
 
 1. generate response group id in create rows (take max id + 1)
 2. update generated ids to return response group id
 3. modify delete response to accept response group id
 4. Modify create to accept response set group id
 5. Update did endEdit text methods
 6. Update didSelect on cell classes
 7. Interactive rebase and add issue # these are a part of
*/

@end
