//
//  NUResponseTest.m
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseTest.h"
#import "NUResponseSet.h"
#import "NUResponse.h"

@implementation NUResponseTest

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


- (void)testSanity {
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:[NSDictionary dictionary] withModel:self.model inContext:self.ctx];
    [rs newResponseForIndexQuestion:@"abc" Answer:@"123"];
    
    
    STAssertEquals(1U, [[rs responsesForQuestion:@"abc" Answer:@"123"] count], @"Should have one element");
}

- (void)testToDict {
    NSDictionary* s = [[NSDictionary alloc] initWithObjectsAndKeys:@"RECT", @"uuid", nil];
    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:s withModel:self.model inContext:self.ctx];
    [rs newResponseForQuestion:@"abc" Answer:@"123" Value:@"foo"];
    NUResponse* one = [[[rs responses] objectEnumerator] nextObject];
    
    NSDictionary* actual = [one toDict];
    
    STAssertNotNil(actual, @"Should not be nil");
//    STAssertEqualObjects([actual objectForKey:@"survey_id"], @"RECT", @"Wrong value");
//    STAssertEquals([[actual objectForKey:@"responses"] count], 2U, @"Wrong size");
}

@end
