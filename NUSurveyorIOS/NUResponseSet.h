//
//  NUResponseSet.h
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 10/18/2011.
//  Copyright (c) 2011 NUBIC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NUResponseSet : NSManagedObject

@property (nonatomic, retain) NSDictionary *dependencyGraph;

+ (NUResponseSet *) newResponseSetForSurvey:(NSString *)survey;
- (NSArray *) responsesForQuestion:(NSString *)qid Answer:(NSString *)aid;
- (NSManagedObject *) newResponseForQuestion:(NSString *)qid Answer:(NSString *)aid Value:(NSString *)value;
- (NSManagedObject *) newResponseForIndexQuestion:(NSString *)qid Answer:(NSString *)aid;
- (void) deleteResponseForQuestion:(NSString *)qid Answer:(NSString *)aid;

- (void) generateDependencyGraph:(NSDictionary *)survey;
- (NSDictionary *) dependenciesTriggeredBy:(NSString *)qid;

@end
