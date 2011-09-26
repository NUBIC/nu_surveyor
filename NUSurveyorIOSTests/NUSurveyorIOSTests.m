//
//  NUSurveyorIOSTests.m
//  NUSurveyorIOSTests
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NUSurveyorIOSTests.h"
#import "UUID.h"
#import "NUSectionVC.h"
#import "SurveyorDatePickerAnswerCell.h"

@implementation NUSurveyorIOSTests

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

- (void)testClassForQuestion{
  NSDictionary *questionOrGroup = [[NSDictionary alloc] init];
  NSDictionary *answer = [[NSDictionary alloc] init];
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"The default case");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorNoneTextAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneTextAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorOneAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorOneAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"any", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorAnyAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorAnyAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", @"dropdown", @"type", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorPickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorPickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"date", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"datetime", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"time", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [NUSectionVC classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
}

- (void) testDatePickerModeFromType {
  SurveyorDatePickerAnswerCell *cell = [[SurveyorDatePickerAnswerCell alloc] init];
  STAssertEquals([cell datePickerModeFromType:@"datetime"], UIDatePickerModeDateAndTime, @"date and time");
  STAssertEquals([cell datePickerModeFromType:@"date"], UIDatePickerModeDate, @"date");
  STAssertEquals([cell datePickerModeFromType:@"time"], UIDatePickerModeTime, @"time");
  STAssertEquals([cell datePickerModeFromType:@""], UIDatePickerModeDate, @"empty string");
  STAssertEquals([cell datePickerModeFromType:nil], UIDatePickerModeDate, @"nil case");
}

@end
