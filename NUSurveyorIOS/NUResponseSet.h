//
//  NUResponseSet.h
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 10/18/2011.
//  Copyright (c) 2011 NUBIC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NUResponseSet : NSManagedObject

@property (nonatomic, retain) NSMutableDictionary *dependencyGraph;
@property (nonatomic, retain) NSMutableDictionary *dependencies;
@property (nonatomic, retain) NSString* uuid;


+ (NUResponseSet *) newResponseSetForSurvey:(NSDictionary *)survey;
- (NSArray *) responsesForQuestion:(NSString *)qid;
- (NSArray *) responsesForQuestion:(NSString *)qid Answer:(NSString *)aid;
- (NSManagedObject *) newResponseForQuestion:(NSString *)qid Answer:(NSString *)aid Value:(NSString *)value;
- (NSManagedObject *) newResponseForIndexQuestion:(NSString *)qid Answer:(NSString *)aid;
- (void) deleteResponseForQuestion:(NSString *)qid Answer:(NSString *)aid;

- (void) generateDependencyGraph:(NSDictionary *)survey;
- (NSDictionary *) dependenciesTriggeredBy:(NSString *)qid;
- (BOOL) showDependency:(NSDictionary *)q;
- (NSMutableDictionary *) evaluateConditions:(NSArray *)conditions;

@end
