//
//  NUSurveyorTests.m
//  NUSurveyorTests
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUSurveyorTests.h"
#import "NUUUID.h"
#import "NUSectionTVC.h"
#import "NUDatePickerCell.h"
#import "JSONKit.h"

@implementation NUSurveyorTests

- (void)testUUID{
  NSString *str = [NUUUID generateUuidString];
  STAssertEquals([str length], (NSUInteger)36, @"UUID length should be 36");
}

- (void)testClassForQuestion{
  NSDictionary *questionOrGroup = [[NSDictionary alloc] init];
  NSDictionary *answer = [[NSDictionary alloc] init];
  STAssertEquals(@"NUNoneCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"The default case");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = nil;
  STAssertEquals(@"NUNoneCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUNoneCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"text", @"type", nil];
  STAssertEquals(@"NUNoneTextCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUNoneTextCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", nil];
  answer = nil;
  STAssertEquals(@"NUOneCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUOneCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"any", @"pick", nil];
  answer = nil;
  STAssertEquals(@"NUAnyCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUAnyCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"pick", @"dropdown", @"type", nil];
  answer = nil;
  STAssertEquals(@"NUPickerCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUPickerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"date", @"type", nil];
  STAssertEquals(@"NUDatePickerCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUDatePickerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"datetime", @"type", nil];
  STAssertEquals(@"NUDatePickerCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUDatePickerCell");
  
  questionOrGroup = [NSDictionary dictionaryWithObjectsAndKeys:@"none", @"pick", nil];
  answer = [NSDictionary dictionaryWithObjectsAndKeys:@"time", @"type", nil];
  STAssertEquals(@"NUDatePickerCell", [NUSectionTVC classNameForQuestion:questionOrGroup answer:answer], @"Class should be NUDatePickerCell");
}

- (void) testDatePickerModeFromType {
  NUDatePickerCell *cell = [[NUDatePickerCell alloc] init];
  STAssertEquals([cell datePickerModeFromType:@"datetime"], UIDatePickerModeDateAndTime, @"date and time");
  STAssertEquals([cell datePickerModeFromType:@"date"], UIDatePickerModeDate, @"date");
  STAssertEquals([cell datePickerModeFromType:@"time"], UIDatePickerModeTime, @"time");
  STAssertEquals([cell datePickerModeFromType:@""], UIDatePickerModeDate, @"empty string");
  STAssertEquals([cell datePickerModeFromType:nil], UIDatePickerModeDate, @"nil case");
}

- (void) testDependencyGraph {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
	 
  NSArray *actual = [rs.dependencyGraph objectForKey:@"765351b0-4540-012f-9ea4-00254bc472f4"];
  NSArray *expect = [NSArray arrayWithObjects:@"765430d0-4540-012f-9ea4-00254bc472f4", @"765812f0-4540-012f-9ea4-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on disliked colors");
  
  actual = [rs.dependencyGraph objectForKey:@"7658ad20-4540-012f-9ea4-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"7658fe10-4540-012f-9ea4-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on Arthur, King of the Britons");
  
  actual = [rs.dependencyGraph objectForKey:@"7658fe10-4540-012f-9ea4-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"76598d90-4540-012f-9ea4-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on quest");
  
  actual = [rs.dependencyGraph objectForKey:@"76598d90-4540-012f-9ea4-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"765a19a0-4540-012f-9ea4-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on airspeed of a swallow");
  
}
- (void) testNilDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
  
  NSDictionary *actual = [rs dependenciesTriggeredBy:nil];
  //  NSLog(@"%@", actual);
  NSDictionary *expect = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects: nil], @"show", [NSArray arrayWithObjects: nil], @"hide", nil];
  STAssertTrue([expect isEqual:actual] , @"nil input to dependency calculation");
  
}
- (void) testAnswerDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];

  [rs newResponseForIndexQuestion:@"765351b0-4540-012f-9ea4-00254bc472f4" Answer:@"7653c2d0-4540-012f-9ea4-00254bc472f4"]; // disliking green
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"765351b0-4540-012f-9ea4-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"765812f0-4540-012f-9ea4-00254bc472f4", nil];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"765430d0-4540-012f-9ea4-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on disliking green, why so many hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on disliking green shows explanation");
}
- (void) testStringDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];

  [rs newResponseForQuestion:@"7658ad20-4540-012f-9ea4-00254bc472f4" Answer:@"7658d830-4540-012f-9ea4-00254bc472f4" Value:@"It is 'Arthur', King of the Britons"]; // Arthur
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"7658ad20-4540-012f-9ea4-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects: nil];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"7658fe10-4540-012f-9ea4-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on Arthur, none hidden");
//  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on Arthur, asks quest");
}
- (void) testCountDependency {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];

	[rs newResponseForIndexQuestion:@"765351b0-4540-012f-9ea4-00254bc472f4" Answer:@"76537bc0-4540-012f-9ea4-00254bc472f4"]; // disliking red
	[rs newResponseForIndexQuestion:@"765351b0-4540-012f-9ea4-00254bc472f4" Answer:@"76539f60-4540-012f-9ea4-00254bc472f4"]; // disliking blue
	[rs newResponseForIndexQuestion:@"765351b0-4540-012f-9ea4-00254bc472f4" Answer:@"7653c2d0-4540-012f-9ea4-00254bc472f4"]; // disliking green
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"765351b0-4540-012f-9ea4-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] init];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"765430d0-4540-012f-9ea4-00254bc472f4", @"765812f0-4540-012f-9ea4-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on disliking rgb, why so many not hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on disliking rgb shows explanation, why so many");
}
- (void) testDependencyStartingHidden {
	  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"test-dependency-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];

  NSDictionary *actual = [rs dependenciesTriggeredBy:@"1f7f81d0-2380-012f-7858-482a143dc94d"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"1f820160-2380-012f-7858-482a143dc94d", nil];
  NSArray *expectShow = [[NSArray alloc] init];
  
//	NSLog(@"%@", rs.dependencyGraph);
//  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency starting hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency starting hidden");
}
- (void) testBirthDateDependenciesBlank {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"test-birth-date-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
  
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"504ad9a0-566d-012f-9ede-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"504e46b0-566d-012f-9ede-00254bc472f4", @"505ee040-566d-012f-9ede-00254bc472f4", nil];
  NSArray *expectShow = [[NSArray alloc] init];
  
  //	NSLog(@"%@", rs.dependencyGraph);
  //  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency birth date dependencies");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency birth date dependencies");
}
- (void) testBirthDateDependenciesNo {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"test-birth-date-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
  [rs newResponseForIndexQuestion:@"504ad9a0-566d-012f-9ede-00254bc472f4" Answer:@"504dd3a0-566d-012f-9ede-00254bc472f4"]; // no
  
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"504ad9a0-566d-012f-9ede-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"505ee040-566d-012f-9ede-00254bc472f4", nil];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"504e46b0-566d-012f-9ede-00254bc472f4", nil];
  
  //	NSLog(@"%@", rs.dependencyGraph);
  //  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency birth date dependencies");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency birth date dependencies");
}
- (void) testBirthDateDependenciesRefused {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"test-birth-date-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
  [rs newResponseForIndexQuestion:@"504ad9a0-566d-012f-9ede-00254bc472f4" Answer:@"504df680-566d-012f-9ede-00254bc472f4"]; // refused
  
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"504ad9a0-566d-012f-9ede-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] init];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"504e46b0-566d-012f-9ede-00254bc472f4", @"505ee040-566d-012f-9ede-00254bc472f4", nil];
  
  //	NSLog(@"%@", rs.dependencyGraph);
  //  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency birth date dependencies");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency birth date dependencies");
}
- (void) testDependencyOnBlankInteger {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"screener" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  NSDictionary *dict = [responseString objectFromJSONString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:dict];
  
  [rs newResponseForQuestion:@"1df73a6e-7516-4bd4-a496-16c5e7285403" Answer:@"7043aa47-a431-4b78-8a21-42f4d8d6a720" Value:@""]; // NUMBER
  
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"1df73a6e-7516-4bd4-a496-16c5e7285403"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"87ccb8a0-e5b6-4938-bd97-2c7e59589a89", nil];
  NSArray *expectShow = [[NSArray alloc] init];
  
  //	NSLog(@"%@", rs.dependencyGraph);
  //  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on blank integer");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on blank integer");
  
}

@end
