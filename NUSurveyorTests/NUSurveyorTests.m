//
//  NUSurveyorTests.m
//  NUSurveyorTests
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUSurveyorTests.h"
#import "UUID.h"
#import "NUSectionTVC.h"
#import "NUDatePickerCell.h"
#import "SBJson.h"

@implementation NUSurveyorTests
@synthesize bundle = _bundle, coord = _coord, ctx = _ctx, model = _model, store = _store;
- (void)setUp
{
    [super setUp];
	
    // Set-up code here.
	self.bundle = [NSBundle bundleWithIdentifier:@"NUBIC.NUSurveyorTests"];
	self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self.bundle URLForResource:@"NUSurveyor" withExtension:@"mom"]];
	self.coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.model];
	self.store = [self.coord addPersistentStoreWithType: NSInMemoryStoreType
															configuration: nil
																				URL: nil
																		options: nil 
																			error: NULL];
	self.ctx = [[NSManagedObjectContext alloc] init];
	[self.ctx setPersistentStoreCoordinator: self.coord];
}

- (void)tearDown
{
    // Tear-down code here.
	self.ctx = nil;
	NSError *error = nil;
	STAssertTrue([self.coord removePersistentStore: self.store error: &error], 
							 @"couldn't remove persistent store: %@", error);
	self.store = nil;
	self.coord = nil;
	self.model = nil;
  self.bundle = nil;
	
    [super tearDown];
}
- (void)testThatEnvironmentWorks
{
	STAssertNotNil(self.store, @"no persistent store");
}

- (void)testUUID{
  NSString *str = [UUID generateUuidString];
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
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];

	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];
	 
  NSArray *actual = [rs.dependencyGraph objectForKey:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
  NSArray *expect = [NSArray arrayWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", @"deef2410-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on disliked colors");
  
  actual = [rs.dependencyGraph objectForKey:@"deef7b20-e5f8-012e-9f18-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"deefaa40-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on Arthur, King of the Britons");
  
  actual = [rs.dependencyGraph objectForKey:@"deefaa40-e5f8-012e-9f18-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"deeff7b0-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on quest");
  
  actual = [rs.dependencyGraph objectForKey:@"deeff7b0-e5f8-012e-9f18-00254bc472f4"];
  expect = [NSArray arrayWithObjects:@"def04360-e5f8-012e-9f18-00254bc472f4", nil];
  STAssertTrue([expect isEqualToArray:actual], @"NUResponseSet Dependency on airspeed of a swallow");
  
}
- (void) testNilDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];
  
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
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];

  [rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deecb340-e5f8-012e-9f18-00254bc472f4"]; // disliking green
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"deef2410-e5f8-012e-9f18-00254bc472f4", nil];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on disliking green, why so many hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on disliking green shows explanation");
}
- (void) testStringDependency {
  // JSON data
	NSError *strError;
	NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];

  [rs newResponseForQuestion:@"deef7b20-e5f8-012e-9f18-00254bc472f4" Answer:@"deef9280-e5f8-012e-9f18-00254bc472f4" Value:@"It is 'Arthur', King of the Britons"]; // Arthur
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"deef7b20-e5f8-012e-9f18-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects: nil];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"deefaa40-e5f8-012e-9f18-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on Arthur, none hidden");
//  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on Arthur, asks quest");
}
- (void) testCountDependency {
  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"kitchen-sink-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];

	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deec8930-e5f8-012e-9f18-00254bc472f4"]; // disliking red
	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deec9e70-e5f8-012e-9f18-00254bc472f4"]; // disliking blue
	[rs newResponseForIndexQuestion:@"deec7160-e5f8-012e-9f18-00254bc472f4" Answer:@"deecb340-e5f8-012e-9f18-00254bc472f4"]; // disliking green
  NSDictionary *actual = [rs dependenciesTriggeredBy:@"deec7160-e5f8-012e-9f18-00254bc472f4"];
	NSArray *expectHide = [[NSArray alloc] init];
  NSArray *expectShow = [[NSArray alloc] initWithObjects:@"deecf720-e5f8-012e-9f18-00254bc472f4", @"deef2410-e5f8-012e-9f18-00254bc472f4", nil];
  
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency on disliking rgb, why so many not hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency on disliking rgb shows explanation, why so many");
}
- (void) testDependencyStartingHidden {
	  // JSON data
  NSError *strError;
  NSString *strPath = [self.bundle pathForResource:@"test-dependency-survey" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  NSDictionary *dict = [parser objectWithString:responseString];
  
	NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc] initWithEntity:entity insertIntoManagedObjectContext:self.ctx];
	[rs generateDependencyGraph:[dict objectForKey:@"survey"]];

  NSDictionary *actual = [rs dependenciesTriggeredBy:@"1f7f81d0-2380-012f-7858-482a143dc94d"];
	NSArray *expectHide = [[NSArray alloc] initWithObjects:@"1f820160-2380-012f-7858-482a143dc94d", nil];
  NSArray *expectShow = [[NSArray alloc] init];
  
//	NSLog(@"%@", rs.dependencyGraph);
//  NSLog(@"%@", actual);
  STAssertTrue([[actual valueForKey:@"hide"] isEqualToArray:expectHide], @"NUResponseSet Dependency starting hidden");
  STAssertTrue([[actual valueForKey:@"show"] isEqualToArray:expectShow], @"NUResponseSet Dependency starting hidden");
}


@end