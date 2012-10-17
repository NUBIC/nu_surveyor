//
//  NUResponsetSetTest.m
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseSetTest.h"
#import "NUResponseSet.h"
#import "NUSurvey.h"
#import "NSDateFormatter+Additions.h"
#import "NUResponse.h"

@implementation NUResponseSetTest

NUResponseSet* rs;
NSDate* createdAt;
NSDate* completedAt;

- (void)setUp {
    [super setUp];
    createdAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1970-02-04T05:15:30Z"];
    completedAt = [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1990-03-06T07:21:42Z"];
    
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs setValue:@"OVAL" forKey:@"uuid"];
    [rs setValue:createdAt forKey:@"createdAt"];
    [rs setValue:completedAt forKey:@"completedAt"];
    
    [rs newResponseForQuestion:@"abc" Answer:@"123" Value:@"foo"];
    [rs newResponseForQuestion:@"xyz" Answer:@"456" Value:@"bar"];
}

- (void)testSanity {
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:[NSDictionary dictionary] withModel:self.model inContext:self.ctx];
    [rs newResponseForIndexQuestion:@"abc" Answer:@"123"];
    
    STAssertEquals(1U, [[rs responsesForQuestion:@"abc" Answer:@"123"] count], @"Should have one element");
}

- (void)testToDict {
    NSDictionary* actual = [rs toDict];
    [self assertResponseSet:actual uuid:@"OVAL"  surveyId:@"RECT" createdAt:@"1970-02-04T05:15:30Z" completedAt:@"1990-03-06T07:21:42Z" responses:2];
}

- (void)testToDictWithNullUUID {
    rs.uuid = NULL;
    NSDictionary* actual = [rs toDict];
    [self assertResponseSet:actual uuid:NULL  surveyId:@"RECT" createdAt:@"1970-02-04T05:15:30Z" completedAt:@"1990-03-06T07:21:42Z" responses:2];
}

- (void) testToJson {
    NSString* actual = [rs toJson];
    STAssertTrue([actual rangeOfString:@"\"uuid\":\"OVAL\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"survey_id\":\"RECT\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"created_at\":\"1970-02-04T05:15:30Z\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"completed_at\":\"1990-03-06T07:21:42Z\""].location != NSNotFound, @"Should exist");
    STAssertTrue([actual rangeOfString:@"\"responses\":["].location != NSNotFound, @"Should exist");
}
- (void) testFromJson {
  NSString* jsonString = @"{\"uuid\":\"9af6d142-7fac-4ccb-9bca-58a05308a5a7\",\"survey_id\":\"94b3d750-fb63-4540-a1e2-dd7f88be9b4f\",\"created_at\":\"1970-02-04T05:15:30Z\",\"completed_at\":\"1990-03-06T07:21:42Z\",\"responses\":[{\"uuid\":\"07d72796-ebb2-4be2-91b9-68f5a30a0054\",\"answer_id\":\"9c788711-8373-44d7-b44b-754c31e596a9\",\"question_id\":\"376a501b-c32f-49de-b4d7-e28030a2ea94\",\"value\":\"Chimpanzee\",\"created_at\":\"1970-02-04T05:15:30Z\",\"modified_at\":\"1990-03-06T07:21:42Z\"},{\"uuid\":\"d0467180-e126-44c0-b112-63bb87f0d869\",\"answer_id\":\"86a85d44-9f39-4df9-ae90-da7ff5dbaaf5\",\"question_id\":\"6146c103-4a8b-4869-836b-415b8666babe\",\"created_at\":\"1970-02-04T05:16:30Z\",\"modified_at\":\"1990-03-06T07:22:42Z\"}]}";
  
  NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
  [rs fromJson:jsonString];
  
  STAssertEquals([rs responseCount], 2U, @"Number of responses");
  STAssertEqualObjects([rs valueForKey:@"uuid"], @"9af6d142-7fac-4ccb-9bca-58a05308a5a7", @"uuid");
  STAssertEqualObjects([rs valueForKey:@"survey"], @"94b3d750-fb63-4540-a1e2-dd7f88be9b4f", @"survey id");
  STAssertEqualObjects([rs valueForKey:@"createdAt"], [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1970-02-04T05:15:30Z"], @"created at");
  STAssertEqualObjects([rs valueForKey:@"completedAt"], [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1990-03-06T07:21:42Z"], @"completed at");
  STAssertEquals([[rs valueForKey:@"responses"] count], 2U, @"2 responses");
    
  
  NUResponse *one = [self responseWithUUID:@"07d72796-ebb2-4be2-91b9-68f5a30a0054" fromResponseSet:rs];
  STAssertEqualObjects([one valueForKey:@"value"], @"Chimpanzee", @"value");
  NUResponse *two = [self responseWithUUID:@"d0467180-e126-44c0-b112-63bb87f0d869" fromResponseSet:rs];
  STAssertNil([two valueForKey:@"value"], @"value");
}

- (void) testFromJsonWithNullResponseValue {
    NSString* jsonString = @"{\"uuid\":\"9af6d142-7fac-4ccb-9bca-58a05308a5a7\",\"survey_id\":\"94b3d750-fb63-4540-a1e2-dd7f88be9b4f\",\"created_at\":\"1970-02-04T05:15:30Z\",\"completed_at\":\"1990-03-06T07:21:42Z\",\"responses\":[{\"uuid\":\"07d72796-ebb2-4be2-91b9-68f5a30a0054\",\"answer_id\":\"9c788711-8373-44d7-b44b-754c31e596a9\",\"question_id\":\"376a501b-c32f-49de-b4d7-e28030a2ea94\",\"value\":null,\"created_at\":\"1970-02-04T05:15:30Z\",\"modified_at\":\"1990-03-06T07:21:42Z\"},{\"uuid\":\"d0467180-e126-44c0-b112-63bb87f0d869\",\"answer_id\":\"86a85d44-9f39-4df9-ae90-da7ff5dbaaf5\",\"question_id\":\"6146c103-4a8b-4869-836b-415b8666babe\",\"created_at\":\"1970-02-04T05:16:30Z\",\"modified_at\":\"1990-03-06T07:22:42Z\"}]}";
    
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
    [rs fromJson:jsonString];
    
    STAssertEquals([rs responseCount], 2U, @"Number of responses");
    STAssertEqualObjects([rs valueForKey:@"uuid"], @"9af6d142-7fac-4ccb-9bca-58a05308a5a7", @"uuid");
    STAssertEqualObjects([rs valueForKey:@"survey"], @"94b3d750-fb63-4540-a1e2-dd7f88be9b4f", @"survey id");
    STAssertEqualObjects([rs valueForKey:@"createdAt"], [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1970-02-04T05:15:30Z"], @"created at");
    STAssertEqualObjects([rs valueForKey:@"completedAt"], [[NSDateFormatter rfc3339DateFormatter] dateFromString:@"1990-03-06T07:21:42Z"], @"completed at");
    STAssertEquals([[rs valueForKey:@"responses"] count], 2U, @"2 responses");
    STAssertNil([[[[rs valueForKey:@"responses"] objectEnumerator] nextObject] valueForKey:@"value"], @"Should be nil");
    
}

- (void) testFromJsonWithIntegerResponseValue {
    NSString* jsonString = @"{\"uuid\":\"9af6d142-7fac-4ccb-9bca-58a05308a5a7\",\"survey_id\":\"94b3d750-fb63-4540-a1e2-dd7f88be9b4f\",\"created_at\":\"1970-02-04T05:15:30Z\",\"completed_at\":\"1990-03-06T07:21:42Z\",\"responses\":[{\"uuid\":\"07d72796-ebb2-4be2-91b9-68f5a30a0054\",\"answer_id\":\"9c788711-8373-44d7-b44b-754c31e596a9\",\"question_id\":\"376a501b-c32f-49de-b4d7-e28030a2ea94\",\"value\":7,\"created_at\":\"1970-02-04T05:15:30Z\",\"modified_at\":\"1990-03-06T07:21:42Z\"}]}";
    
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
    [rs fromJson:jsonString];
    
    STAssertEqualObjects([[[[rs valueForKey:@"responses"] objectEnumerator] nextObject] valueForKey:@"value"], @"7", @"Should be 7");
}

- (void) testFromJsonWithResponseGroup {
    NSString* jsonString = @"{\"uuid\":\"9af6d142-7fac-4ccb-9bca-58a05308a5a7\",\"survey_id\":\"94b3d750-fb63-4540-a1e2-dd7f88be9b4f\",\"created_at\":\"1970-02-04T05:15:30Z\",\"completed_at\":\"1990-03-06T07:21:42Z\",\"responses\":[{\"uuid\":\"07d72796-ebb2-4be2-91b9-68f5a30a0054\",\"answer_id\":\"9c788711-8373-44d7-b44b-754c31e596a9\",\"question_id\":\"376a501b-c32f-49de-b4d7-e28030a2ea94\",\"response_group\":\"1\",\"created_at\":\"1970-02-04T05:15:30Z\",\"modified_at\":\"1990-03-06T07:21:42Z\"}]}";
    
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
    [rs fromJson:jsonString];
    
    STAssertEqualObjects([[[[rs valueForKey:@"responses"] objectEnumerator] nextObject] valueForKey:@"responseGroup"], [NSNumber numberWithInt:1], @"Should be 1");
}

- (void) testFromJsonWithNullCompletedAt {
    NSString* jsonString = @"{\"uuid\":\"9af6d142-7fac-4ccb-9bca-58a05308a5a7\",\"survey_id\":\"94b3d750-fb63-4540-a1e2-dd7f88be9b4f\",\"created_at\":\"1970-02-04T05:15:30Z\",\"completed_at\":null,\"responses\":[]}";
    
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
    [rs fromJson:jsonString];

    STAssertNil([rs valueForKey:@"completedAt"], @"completed at");    
}

- (void)testCountGroupResponsesForQuestionIdsWithNoResponses {
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    NSUInteger count = [rs countGroupResponsesForQuestionIds:[NSArray arrayWithObject:@"abc"]];
    STAssertEquals(count, 0U, @"Wrong response group count");
}

- (void)testCountGroupResponsesForQuestionIdsWithNoUsefulResponses {
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs newResponseForQuestion:@"xyz" Answer:@"456" responseGroup:[NSNumber numberWithInteger:0] Value:@"bar"];
    NSUInteger count = [rs countGroupResponsesForQuestionIds:[NSArray arrayWithObject:@"abc"]];
    STAssertEquals(count, 0U, @"Wrong response group count");
}

- (void)testCountGroupResponsesForQuestionIdsWithOneResponses {
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs newResponseForQuestion:@"xyz" Answer:@"456" responseGroup:[NSNumber numberWithInteger:0] Value:@"bar"];
    NSUInteger count = [rs countGroupResponsesForQuestionIds:[NSArray arrayWithObject:@"xyz"]];
    STAssertEquals(count, 1U, @"Wrong response group count");
}

- (void)testCountGroupResponsesForQuestionIdsWithTwoResponses {
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs newResponseForQuestion:@"xyz" Answer:@"456" responseGroup:[NSNumber numberWithInteger:0] Value:@"bar"];
    [rs newResponseForQuestion:@"abc" Answer:@"789" responseGroup:[NSNumber numberWithInteger:1] Value:@"foo"];
    NSUInteger count = [rs countGroupResponsesForQuestionIds:[NSArray arrayWithObjects:@"xyz", @"abc", nil]];
    STAssertEquals(count, 2U, @"Wrong response group count");
}

#pragma mark Helper Methods

- (void)assertResponseSet:(NSDictionary *)actual uuid:(NSString*)uuid surveyId:(NSString*)surveyId createdAt:(NSString*)createdAt completedAt:(NSString*)completedAt responses:(NSInteger)responses {
    STAssertEqualObjects([actual objectForKey:@"uuid"], uuid, @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"survey_id"], surveyId, @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"created_at"], createdAt, @"Wrong value");
    STAssertEqualObjects([actual objectForKey:@"completed_at"], completedAt, @"Wrong value");
    STAssertEquals(((NSInteger)[[actual objectForKey:@"responses"] count]), responses, @"Wrong size");
}

- (NUResponse*)responseWithUUID:(NSString*)uuid fromResponseSet:(NUResponseSet*)rs {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"uuid == %@", uuid];
    return [[[[rs valueForKey:@"responses"] allObjects] filteredArrayUsingPredicate:p] objectAtIndex:0];
}

@end
