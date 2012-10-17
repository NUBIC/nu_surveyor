//
//  NUResponse.m
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponse.h"
#import "JSONKit.h"
#import "NSDateFormatter+Additions.h"

@implementation NUResponse

+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate managedObjectContext:(NSManagedObjectContext*)ctx {
    //  DLog(@"responsesForQuestion %@ answer %@", qid);
    // setup fetch request
	NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:ctx];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSArray *results = [ctx executeFetchRequest:request error:&error];
    if (results == nil)
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved ResponseSet responsesForQuestion fetch error %@, %@", error, [error userInfo]);
        abort();
    }
    return results;
}

#pragma mark - Serialization/Deserialization

- (NSDictionary*) toDict {
    NSString* createdAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"createdAt"]];
    NSString* modifiedAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"modifiedAt"]];
    
    NSMutableDictionary* d = [NSMutableDictionary new];
    [d setValue:[self valueForKey:@"uuid"] forKey:@"uuid"];
    [d setValue:[self valueForKey:@"answer"] forKey:@"answer_id"];
    [d setValue:[self valueForKey:@"question"] forKey:@"question_id"];
    [d setValue:([self valueForKey:@"responseGroup"] ? [[self valueForKey:@"responseGroup"] description] : NULL) forKey:@"response_group"];
    [d setValue:[self valueForKey:@"value"] forKey:@"value"];
    [d setValue:createdAt forKey:@"created_at"];
    [d setValue:modifiedAt forKey:@"modified_at"];
    
    return d;
}

- (NSString*) toJson {
  return [self.toDict JSONString];
}

@end
