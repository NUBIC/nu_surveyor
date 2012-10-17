//
//  NUResponse.h
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NUResponse : NSManagedObject

+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate managedObjectContext:(NSManagedObjectContext*)ctx;

#pragma mark - Serialization/Deserialization
    
- (NSDictionary*) toDict;

- (NSString*) toJson;

@end
