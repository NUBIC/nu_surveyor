//
//  NUResponseSet.m
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 10/18/2011.
//  Copyright (c) 2011 NUBIC. All rights reserved.
//

#import "NUResponseSet.h"
#import "UUID.h"

@implementation NUResponseSet

@synthesize dependencyGraph;

// initializer
+ (NUResponseSet *) newResponseSetForSurvey:(NSString *)survey {
  NSEntityDescription *entity =
  [[[UIAppDelegate managedObjectModel] entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc]
                          initWithEntity:entity insertIntoManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [rs setValue:[NSDate date] forKey:@"CreatedAt"];
  [rs setValue:survey forKey:@"Survey"];
  [rs setValue:[UUID generateUuidString] forKey:@"UUID"];
  [UIAppDelegate saveContext:@"NUResponseSet newResponseSetForSurvey"];
  return [rs autorelease];
}

#pragma mark - CRUD
//
// Look up responses
//
- (NSArray *) responsesForQuestion:(NSString *)qid Answer:(NSString *)aid {
  //  DLog(@"responseForQuestion %@ answer %@", qid, aid);
  // setup fetch request
	NSError *error = nil;
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [request setEntity:entity];
  
  // Set predicate
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"(responseSet == %@) AND (Question == %@) AND (Answer == %@)", 
                            self, qid, aid];
  [request setPredicate:predicate];
  
  NSArray *results = [[UIAppDelegate managedObjectContext] executeFetchRequest:request error:&error];
  if (results == nil)
  {
    /*
     Replace this implementation with code to handle the error appropriately.
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */
    NSLog(@"Unresolved ResponseSet responsesForQuestionAnswer fetch error %@, %@", error, [error userInfo]);
    abort();
  }
  //  DLog(@"responseForAnswer: %@ result: %@", aid, [results lastObject]);
  //  DLog(@"responseForAnswer #:%d", [results count]);
  return results;
}
//
// Create a response with value
//
- (NSManagedObject *) newResponseForQuestion:(NSString *)qid Answer:(NSString *)aid Value:(NSString *)value{

  NSManagedObject *newResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [newResponse setValue:self forKey:@"responseSet"];
  [newResponse setValue:qid forKey:@"Question"];
  [newResponse setValue:aid forKey:@"Answer"];
  [newResponse setValue:value forKey:@"Value"];
  
  [newResponse setValue:[NSDate date] forKey:@"CreatedAt"];
  [newResponse setValue:[UUID generateUuidString] forKey:@"UUID"];
  
  // Save the context.
  [UIAppDelegate saveContext:@"ResponseSet newResponseForQuestionAnswerValue"];
  
  return newResponse;
}
//
// Create an answer
//
- (NSManagedObject *) newResponseForIndexQuestion:(NSString *)qid Answer:(NSString *)aid {
  return [self newResponseForQuestion:qid Answer:aid Value:nil];
}
//
// Delete responses
//

- (void) deleteResponseForQuestion:(NSString *)qid Answer:(NSString *)aid {
  NSArray *existingResponses = [self responsesForQuestion:qid Answer:aid];
  for (NSManagedObject *existingResponse in existingResponses) {
    [[UIAppDelegate managedObjectContext] deleteObject:existingResponse];
  }
  
  // Save the context
  [UIAppDelegate saveContext:@"ResponseSet deleteResponseForQuestionAnswer"];  
}

#pragma mark - Dependency Graph
- (void) generateDependencyGraph:(NSDictionary *)survey {
  
}
- (NSDictionary *) dependenciesTriggeredBy:(NSString *)qid {
  NSMutableArray *show = [[NSMutableArray alloc] init];
  NSMutableArray *hide = [[NSMutableArray alloc] init];
  NSDictionary *triggered = [[NSDictionary alloc] initWithObjectsAndKeys:show, @"show", hide, @"hide", nil]; 
  return [triggered autorelease];
}
@end
