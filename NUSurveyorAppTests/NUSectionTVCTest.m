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

#pragma mark - #createRows

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

- (void)testRowsForRepeaterWithTextArea {
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                       [self createQuestionWithText:@"Car" uuid:@"abc" type:@"text"]]];
    STAssertEquals([t.allSections count], 2U, @"Should have 2 rows");
    STAssertEquals([t.visibleSections count], 2U, @"Should have 2 rows");
}

- (void)testRowsForStringField {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                            [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]]];
    STAssertEquals([t.allSections count], 1U, @"Should have 1 row");
    STAssertEquals([t.visibleSections count], 1U, @"Should have 1 row");
}

- (void)testRowsForGrid {
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
    [self useQuestion:[self createQuestionRepeaterWithText:@"Favorite Car?" uuid:@"xyz" question:
                        [self createQuestionWithText:@"Car" uuid:@"abc" type:@"text"]]];
    NSDictionary* r0 = [t.allSections objectAtIndex:0];
    NSDictionary* r1 = [t.allSections objectAtIndex:1];
    [self assertRow:r0 hasUUID:@"xyz" show:YES];
    [self assertRow:r1 hasUUID:@"abc" show:YES];
}

#pragma mark - #indexOfQuestionOrGroupWithUUID

- (void)testIndexOfQuestionOrGroupWithUUID {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    STAssertEquals((NSUInteger)[t performSelector:@selector(indexOfQuestionOrGroupWithUUID:) withObject:@"xyz"], 0U, @"Wrong index");
}

- (void)testIdsForIndexPathForLabel {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" type:@"label"]];
    NSDictionary* r = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    STAssertEquals([[r allKeys] count], 0U, @"Wrong number of attributes");
}

- (void)testIdsForIndexPathForStringField {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" answer:
                            [self createAnswerWithText:@"Location" uuid:@"abc" type:@"string"]]];
    NSDictionary* r = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    STAssertEquals([[r allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([r objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([r objectForKey:@"aid"], @"abc", @"Wrong aid");
}

- (void)testIdsForIndexPathForPickOne {
    [self useQuestion:[self createQuestionWithText:@"Where is Waldo?" uuid:@"xyz" pick:@"one" answers:[NSArray arrayWithObjects:
                            [self createAnswerWithText:@"Chicago" uuid:@"aaa"],
                            [self createAnswerWithText:@"Mooooon" uuid:@"bbb"], nil]]];
    NSDictionary* r0 = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary* r1 = (NSDictionary*)[t performSelector:@selector(idsForIndexPath:) withObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    STAssertEquals([[r0 allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEquals([[r1 allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([r0 objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([r0 objectForKey:@"aid"], @"aaa", @"Wrong aid");
    STAssertEqualObjects([r1 objectForKey:@"qid"], @"xyz", @"Wrong qid");
    STAssertEqualObjects([r1 objectForKey:@"aid"], @"bbb", @"Wrong aid");
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

#pragma mark - JSON Builder Methods
     
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

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid pick:(NSString*)pick answers:(NSArray*)answers {
    NSString* combined = [answers componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"pick\": \"%@\", \"answers\": [%@]}", text, uuid, pick, combined];
}

- (NSString*)createQuestionRepeaterWithText:text uuid:uuid question:question {
    return [NSString stringWithFormat:@"{\"text\": \"%@\", \"uuid\": \"%@\", \"type\": \"repeater\", \"questions\": [%@]}", text, uuid, question];
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
    STAssertEqualObjects([r objectForKey:@"show"], [NSNumber numberWithBool:show], @"Should show");
    STAssertNotNil([r objectForKey:@"question"], @"Should have question");
}

- (void)assertId:(NSDictionary*)i qid:(NSString*)qid aid:(NSString*)aid {
    STAssertEquals([[i allKeys] count], 2U, @"Wrong number of attributes");
    STAssertEqualObjects([i objectForKey:@"qid"], qid, @"Wrong qid");
    STAssertEqualObjects([i objectForKey:@"aid"], aid, @"Wrong aid");
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
