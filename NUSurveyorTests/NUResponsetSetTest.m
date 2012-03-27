//
//  NUResponsetSetTest.m
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUResponsetSetTest.h"
#import "NUResponseSet.h"

@implementation NUResponsetSetTest

- (void)testToJson
{
    NSURL *modelURL = NULL;
    for (NSBundle* b in [NSBundle allBundles]) {
        NSURL* found = [b URLForResource:@"NUSurveyorExample" withExtension:@"mom"];
        if (found) {
            modelURL = found;
        }
    }
    NSLog(@"modelURL: %@", modelURL);
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] init];
    managedObjectModel setEntities:<#(NSArray *)#>;
    NSEntityMapping m = [NSEntityMapping in
	NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSError *error = nil;
	NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error])
	{
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} 
    
    NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] init];
	[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    NUResponseSet* rs = [NUResponseSet newResponseSetForSurvey:[NSDictionary dictionary] withModel:managedObjectModel inContext:managedObjectContext];
    [rs newResponseForIndexQuestion:@"abc" Answer:@"123"];
    
    
    STAssertTrue([[rs responsesForQuestion:@"abc" Answer:@"123"] count] > 0, @"Should have one element");
//    STAssertEqualObjects(@"abc", [ valueForKey:@"answer"], @"Wrong Answer");
}

@end
