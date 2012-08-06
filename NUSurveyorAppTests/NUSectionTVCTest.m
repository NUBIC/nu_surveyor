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
static NUResponseSet* rs;

- (void) setUp {
    t = [[NUSectionTVC alloc] initWithStyle:UITableViewStyleGrouped];
    
    NUAppDelegate* delegate = ((NUAppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    NSEntityDescription *entity = [[[delegate managedObjectModel] entitiesByName] objectForKey:@"ResponseSet"];

    rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:[delegate managedObjectContext]];
    
    t.responseSet = rs;
}

- (void)testAppDelegate {
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

#pragma mark - #createRows (Generic)

- (void)testNoRows {
    [self useQuestion:nil];
    STAssertNil(t.allSections, @"Should be nil");
    STAssertNil(t.visibleSections, @"Should be nil");
}

- (void)testCreateRowsForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

#pragma mark - #createRows (Repeaters)

- (void)testCreateRowsForRepeaterWithNoResponse {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                        [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]]];
    STAssertEquals([t.allSections count], 2U, @"Should have 2 rows");
    STAssertEquals([t.visibleSections count], 2U, @"Should have 2 rows");    
}

- (void)testCreateRowsForRepeaterWithOneResponses {
    [rs newResponseForQuestion:@"abc" Answer:@"aaa" responseGroup:[NSNumber numberWithInteger:0] Value:@"Ford"];
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                        [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]]];
    STAssertEquals([t.allSections count], 3U, @"Should have 3 rows");
    STAssertEquals([t.visibleSections count], 3U, @"Should have 3 rows");
}

- (void)testCreateRowsForRepeaterWithTwoQuestions {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" questions:[NSArray arrayWithObjects:
                        [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                            [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]],
                        [self createQuestionWithText:@"Car" uuid:@"cbs" answer:
                            [self createAnswerWithText:@"Model" uuid:@"bbb" type:@"string"]], nil]]];
    STAssertEquals([t.allSections count], 3U, @"Should have 3 rows");
    STAssertEquals([t.visibleSections count], 3U, @"Should have 3 rows");
}

- (void)testRowAttributesForRepeater {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                        [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]]];
    NSDictionary* r0 = [t.allSections objectAtIndex:0];
    NSDictionary* r1 = [t.allSections objectAtIndex:1];
    [self assertRow:r0 hasUUID:@"xyz" show:YES];
    [self assertRow:r1 hasUUID:@"abc" show:YES rgid:0];
}

- (void)testRowAttributesForRepeaterWithTwoQuestions {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" questions:[NSArray arrayWithObjects:
                           [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                                [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]],
                           [self createQuestionWithText:@"Car" uuid:@"cbs" answer:
                                [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]], nil]]];
    NSDictionary* r0 = [t.allSections objectAtIndex:0];
    NSDictionary* r1 = [t.allSections objectAtIndex:1];
    NSDictionary* r2 = [t.allSections objectAtIndex:2];
    [self assertRow:r0 hasUUID:@"xyz" show:YES];
    [self assertRow:r1 hasUUID:@"abc" show:YES rgid:0];
    [self assertRow:r2 hasUUID:@"cbs" show:YES rgid:0];
}

- (void)testRowAttributesForRepeaterWithTwoQuestionsAndOneResponse {
    [rs newResponseForQuestion:@"abc" Answer:@"aaa" responseGroup:[NSNumber numberWithInteger:0] Value:@"Ford"];
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" questions:[NSArray arrayWithObjects:
                           [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                                [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]],
                           [self createQuestionWithText:@"Car" uuid:@"cbs" answer:
                                [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]], nil]]];
    NSDictionary* r0 = [t.allSections objectAtIndex:0];
    NSDictionary* r1 = [t.allSections objectAtIndex:1];
    NSDictionary* r2 = [t.allSections objectAtIndex:2];
    NSDictionary* r3 = [t.allSections objectAtIndex:3];
    NSDictionary* r4 = [t.allSections objectAtIndex:4];
    [self assertRow:r0 hasUUID:@"xyz" show:YES];
    [self assertRow:r1 hasUUID:@"abc" show:YES rgid:0];
    [self assertRow:r2 hasUUID:@"cbs" show:YES rgid:0];
    [self assertRow:r3 hasUUID:@"abc" show:YES rgid:1];
    [self assertRow:r4 hasUUID:@"cbs" show:YES rgid:1];
}

#pragma mark - #createRows (Pick One)

- (void)testCreateRowsForPickOne {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                            [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

#pragma mark - #createRows (Grid)

- (void)testCreateRowsForGrid {
    [self useQuestion:[self createQuestionGridWithText:@"Preferences?" uuid:@"xyz" questions:[NSArray arrayWithObjects:
                          [self createQuestionWithText:@"City?" uuid:@"abc" pick:@"one" answers:[NSArray arrayWithObjects:
                             [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                             [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]],
                          [self createQuestionWithText:@"Color?" uuid:@"cbs" pick:@"one" answers:[NSArray arrayWithObjects:
                              [self createAnswerWithText:@"Blue" uuid:@"zzz"],
                              [self createAnswerWithText:@"Red" uuid:@"yyy"], nil]], nil]]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

#pragma mark - #createRows (Hidden)

- (void)testCreateRowsForHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 0U, @"Should have 0 rows");
}

- (void)testRowAttributesForHidden {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"hidden"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    [self assertRow:r hasUUID:@"xyz" show:NO];
}

#pragma mark - #createRows (Label)

- (void)testRowAttributesForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSDictionary* r = [t.allSections objectAtIndex:0];
    [self assertRow:r hasUUID:@"xyz" show:YES];
}


#pragma mark - #indexOfQuestionOrGroupWithUUID

- (void)testIndexOfQuestionOrGroupWithUUID {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals((NSUInteger)[t performSelector:@selector(indexOfQuestionOrGroupWithUUID:) withObject:@"xyz"], 0U, @"Wrong index");
}

#pragma mark - #idsForIndexPath (Label)

- (void)testIdsForIndexPathForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSDictionary* r = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    STAssertEquals([[r allKeys] count], 0U, @"Wrong number of attributes");
}

#pragma mark - #idsForIndexPath (String)

- (void)testIdsForIndexPathForStringField {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" answer:
                            [self createAnswerWithText:@"Location" uuid:@"abc" type:@"string"]]];
    NSDictionary* r = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    STAssertEquals([[r allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([r objectForKey:@"aid"], @"abc", @"Wrong aid");
}

#pragma mark - #idsForIndexPath (Pick One)

- (void)testIdsForIndexPathForPickOne {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                            [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]]];
    NSDictionary* chi = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary* moo = [self idsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    STAssertEquals([[chi allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEquals([[moo allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([chi objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([chi objectForKey:@"aid"], @"aaa", @"Wrong aid");
    STAssertEqualObjects([moo objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([moo objectForKey:@"aid"], @"bbb", @"Wrong aid");
}

- (void)testIdsForIndexPathForGridWithPickOne {
    [self useQuestion:[self createQuestionGridWithText:@"Preferences?" uuid:@"xyz" questions:[NSArray arrayWithObjects:
                        [self createQuestionWithText:@"City?" uuid:@"abc" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                            [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]],
                        [self createQuestionWithText:@"Color?" uuid:@"cbs" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Blue" uuid:@"zzz"],
                            [self createAnswerWithText:@"Red" uuid:@"yyy"], nil]], nil]]];

    NSDictionary* chi = [self idsForIndexPath:[self createGridIndexPathForGroup:0 question:0 answer:0]];
    NSDictionary* moo = [self idsForIndexPath:[self createGridIndexPathForGroup:0 question:0 answer:1]];
    NSDictionary* blu = [self idsForIndexPath:[self createGridIndexPathForGroup:0 question:1 answer:0]];
    NSDictionary* red = [self idsForIndexPath:[self createGridIndexPathForGroup:0 question:1 answer:1]];
    
    [self assertId:chi qid:@"abc" aid:@"aaa"];
    [self assertId:moo qid:@"abc" aid:@"bbb"];
    [self assertId:blu qid:@"cbs" aid:@"zzz"];
    [self assertId:red qid:@"cbs" aid:@"yyy"];
}

#pragma mark - #idsForIndexPath (Repeater)

- (void)testIdsForIndexPathForRepeaterWithNoResponses {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                        [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]]];
    NSDictionary* r = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [self assertId:r qid:@"abc" aid:@"aaa" rgid:0];
}

- (void)testIdsForIndexPathForRepeaterWithOneResponse {
    [rs newResponseForQuestion:@"abc" Answer:@"aaa" responseGroup:[NSNumber numberWithInteger:0] Value:@"Ford"];
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                        [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]]];
    NSDictionary* r0 = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSDictionary* r1 = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [self assertId:r0 qid:@"abc" aid:@"aaa" rgid:0];
    [self assertId:r1 qid:@"abc" aid:@"aaa" rgid:1];
}

- (void)testIdsForIndexPathForRepeaterWithHiddenQuestionAndOneResponse {
    [rs newResponseForQuestion:@"abc" Answer:@"aaa" responseGroup:[NSNumber numberWithInteger:0] Value:@"Ford"];
    [self useQuestions:[NSArray arrayWithObjects:
                       [self createQuestionWithText:@"I'm Hidden" uuid:@"ooo" type:@"hidden"],
                       [self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                        [self createQuestionWithText:@"Car" uuid:@"abc" answer:
                         [self createAnswerWithText:@"Model" uuid:@"aaa" type:@"string"]]], nil]];
    NSDictionary* r0 = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSDictionary* r1 = [self idsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [self assertId:r0 qid:@"abc" aid:@"aaa" rgid:0];
    [self assertId:r1 qid:@"abc" aid:@"aaa" rgid:1];
}

#pragma mark - JSON Builder Helper Methods
     
- (void)useQuestion:(NSString*)question {
    t.detailItem = (question == nil) ? nil : [self builder:[NSArray arrayWithObject:question]];
}

- (void)useQuestions:(NSArray*)questions {
    t.detailItem = (questions == nil) ? nil : [self builder:questions];
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

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid answers:(NSArray*)answers {
    NSString* combined = [answers componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"answers\": [%@]}", text, uuid, combined];
}

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid pick:(NSString*)pick answers:(NSArray*)answers {
    NSString* combined = [answers componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"pick\": \"%@\", \"answers\": [%@]}", text, uuid, pick, combined];
}

- (NSString*)createQuestionRepeaterWithText:text uuid:uuid question:question {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"repeater\", \"questions\": [%@]}", text, uuid, question];
}

- (NSString*)createQuestionRepeaterWithText:text uuid:uuid questions:questions {
    NSString* combined = [questions componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"repeater\", \"questions\": [%@]}", text, uuid, combined];
}

- (NSString*)createQuestionGridWithText:(NSString*)text uuid:(NSString*)uuid questions:(NSArray*)questions {
    NSString* combined = [questions componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"grid\", \"questions\": [%@]}", text, uuid, combined];
}

- (NSString*)createAnswerWithText:(NSString*)text uuid:(NSString*)uuid {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\"}", text, uuid];
}

- (NSString*)createAnswerWithText:(NSString*)text uuid:(NSString*)uuid type:(NSString*)type {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"%@\"}", text, uuid, type];
}

- (NSIndexPath*)createGridIndexPathForGroup:(NSUInteger)g question:(NSUInteger)q answer:(NSUInteger)a {
    NSUInteger idx[] = {g, q, a};
    return [NSIndexPath indexPathWithIndexes:idx length:3];
}

- (NSDictionary*) idsForIndexPath:(NSIndexPath*)i {
    return (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:i];
}

#pragma mark - Assertion Helper Methods

- (void)assertRow:(NSDictionary*)r hasUUID:(NSString*)uuid show:(BOOL)show {
    STAssertEquals([[r allKeys] count], 3U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"uuid"], uuid, @"Wrong uuid");
    STAssertEqualObjects([r objectForKey:@"show"], [NSNumber numberWithBool:show], @"Wrong show");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

- (void)assertRow:(NSDictionary*)r hasUUID:(NSString*)uuid show:(BOOL)show rgid:(NSInteger)rgid {
    STAssertEquals([[r allKeys] count], 4U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"uuid"], uuid, @"Wrong uuid");
    STAssertEqualObjects([r objectForKey:@"show"], [NSNumber numberWithBool:show], @"Wrong show");
    STAssertEqualObjects([r objectForKey:@"rgid"],[NSNumber numberWithInteger:rgid], @"Wrong rgid");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

- (void)assertId:(NSDictionary*)i qid:(NSString*)qid aid:(NSString*)aid {
    STAssertEquals([[i allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([i objectForKey:@"qid"], qid, @"Wrong qid");
    STAssertEqualObjects([i objectForKey:@"aid"], aid, @"Wrong aid");
}

- (void)assertId:(NSDictionary*)i qid:(NSString*)qid aid:(NSString*)aid rgid:(NSInteger)rgid {
    STAssertEquals([[i allKeys] count], 3U, @"Wrong number of attributes");
    STAssertEqualObjects([i objectForKey:@"qid"], qid, @"Wrong qid");
    STAssertEqualObjects([i objectForKey:@"aid"], aid, @"Wrong aid");
    STAssertEqualObjects([i objectForKey:@"rgid"], [NSNumber numberWithInteger:rgid], @"Wrong rgid");
}

@end
