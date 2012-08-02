//
//  NUSectionTVCTest.h
//  NUSurveyor
//
//  Created by John Dzak on 7/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface NUSectionTVCTest : SenTestCase

#pragma mark - JSON Builder Methods

- (void)useQuestion:(NSString*)question;
    
- (NSDictionary*)builder:(NSArray*)questions;

- (NSString*)createQuestionsAndGroups:(NSArray*)questions;

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid type:(NSString*)type;

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid answer:(NSString*)answer;

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid answers:(NSArray*)answers;

- (NSString*)createQuestionWithText:(NSString*)text uuid:(NSString*)uuid pick:(NSString*)pick answers:(NSArray*)answers;

- (NSString*)createQuestionRepeaterWithText:(NSString*)text uuid:(NSString*)uuid question:(NSString*)question;

- (NSString*)createQuestionRepeaterWithText:(NSString*)text uuid:(NSString*)uuid questions:(NSArray*)questions;
    
- (NSString*)createQuestionGridWithText:(NSString*)text uuid:(NSString*)uuid questions:(NSArray*)questions;

- (NSString*)createAnswerWithText:(NSString*)text uuid:(NSString*)uuid;

- (NSString*)createAnswerWithText:(NSString*)text uuid:(NSString*)uuid type:(NSString*)type;

- (NSIndexPath*)createGridIndexPathForGroup:(NSUInteger)g question:(NSUInteger)q answer:(NSUInteger)a;

- (NSDictionary*) idsForIndexPath:(NSIndexPath*)i;

#pragma mark - Assertion Helper Methods

- (void)assertRow:(NSDictionary*)r hasUUID:(NSString*)uuid show:(BOOL)show;

- (void)assertRow:(NSDictionary*)r hasUUID:(NSString*)uuid show:(BOOL)show rgid:(NSInteger)rgid;

- (void)assertId:(NSDictionary*)i qid:(NSString*)qid aid:(NSString*)aid;

- (void)assertId:(NSDictionary*)i qid:(NSString*)qid aid:(NSString*)aid rgid:(NSInteger)rgid;

@end
