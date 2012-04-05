//
//  NUResponseSet.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@class NUResponse;

@interface NUResponseSet : NSManagedObject

@property (nonatomic, retain) NSMutableDictionary *dependencyGraph;
@property (nonatomic, retain) NSMutableDictionary *dependencies;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, retain) NSSet* responses;

+ (NUResponseSet *) newResponseSetForSurvey:(NSDictionary *)survey withModel:(NSManagedObjectModel *)mom inContext:(NSManagedObjectContext *)moc;
+ (void) saveContext:(NSManagedObjectContext *)moc withMessage:(NSString *)message;
- (NSUInteger) responseCount;
- (NSArray *) responsesForQuestion:(NSString *)qid;
- (NSArray *) responsesForQuestion:(NSString *)qid Answer:(NSString *)aid;
- (NUResponse *) newResponseForQuestion:(NSString *)qid Answer:(NSString *)aid Value:(NSString *)value;
- (NUResponse *) newResponseForIndexQuestion:(NSString *)qid Answer:(NSString *)aid;
- (void) deleteResponseForQuestion:(NSString *)qid Answer:(NSString *)aid;

- (void) generateDependencyGraph:(NSDictionary *)survey;
- (NSDictionary *) dependenciesTriggeredBy:(NSString *)qid;
- (BOOL) showDependency:(NSDictionary *)q;
- (NSMutableDictionary *) evaluateConditions:(NSArray *)conditions;
- (NSDictionary*) toDict;
- (NSString*) toJson;
- (void) fromJson:(NSString *)jsonString;
@end
