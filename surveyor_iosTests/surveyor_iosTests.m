//
//  surveyor_iosTests.m
//  surveyor_iosTests
//
//  Created by Mark Yoon on 4/19/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "surveyor_iosTests.h"
#import "UUID.h"
#import "SurveySectionViewController.h"

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

- (void)testClassForQuestion{
  NSDictionary *questionOrGroup = [[NSDictionary alloc] init];
  NSDictionary *answer = [[NSDictionary alloc] init];
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"The default case");

  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorNoneAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneAnswerCell");

  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorNoneTextAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorNoneTextAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorOneAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorOneAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"any", @"pick", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorAnyAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorAnyAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", @"dropdown", @"type", nil];
  answer = nil;
  STAssertEquals(NSClassFromString(@"SurveyorPickerAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorPickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"date", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"datetime", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"time", @"type", nil];
  STAssertEquals(NSClassFromString(@"SurveyorDatePickerAnswerCell"), [SurveySectionViewController classForQuestion:questionOrGroup answer:answer], @"Class should be SurveyorDatePickerAnswerCell");
}

@end
