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

@synthesize dependencyGraph, dependencies;

// initializer
+ (NUResponseSet *) newResponseSetForSurvey:(NSDictionary *)survey {
//  DLog(@"survey: %@", survey);
//  DLog(@"uuid: %@", [survey objectForKey:@"uuid"]);
  NSEntityDescription *entity =
  [[[UIAppDelegate managedObjectModel] entitiesByName] objectForKey:@"ResponseSet"];
  NUResponseSet *rs = [[NUResponseSet alloc]
                          initWithEntity:entity insertIntoManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [rs setValue:[NSDate date] forKey:@"CreatedAt"];
  [rs setValue:[survey objectForKey:@"uuid"] forKey:@"Survey"];
  [rs setValue:[UUID generateUuidString] forKey:@"UUID"];
  [UIAppDelegate saveContext:@"NUResponseSet newResponseSetForSurvey"];
  
  [rs generateDependencyGraph:survey];
  return [rs autorelease];
}

#pragma mark - CRUD
//
// Look up responses
//
- (NSArray *) responsesForQuestion:(NSString *)qid {
  //  DLog(@"responsesForQuestion %@ answer %@", qid);
  // setup fetch request
	NSError *error = nil;
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [request setEntity:entity];
  
  // Set predicate
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"(responseSet == %@) AND (Question == %@)", 
                            self, qid];
  [request setPredicate:predicate];
  
  NSArray *results = [[UIAppDelegate managedObjectContext] executeFetchRequest:request error:&error];
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
//
// Look up responses
//
- (NSArray *) responsesForQuestion:(NSString *)qid Answer:(NSString *)aid {
  //  DLog(@"responsesForQuestion %@ answer %@", qid, aid);
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

#pragma mark - Dependencies

- (void) generateDependencyGraph:(NSDictionary *)survey {
  self.dependencyGraph = [[NSMutableDictionary alloc] init];
  self.dependencies = [[NSMutableDictionary alloc] init];
  for (NSDictionary *section in [survey objectForKey:@"sections"]) {
    for (NSDictionary *questionOrGroup in [section objectForKey:@"questions_and_groups"]) {
      if ([questionOrGroup objectForKey:@"dependency"] && [questionOrGroup objectForKey:@"uuid"] && [[questionOrGroup objectForKey:@"dependency"] objectForKey:@"conditions"]) {
        [dependencies setObject:[questionOrGroup objectForKey:@"dependency"] forKey:[questionOrGroup objectForKey:@"uuid"]];
        for (NSDictionary *condition in [[questionOrGroup objectForKey:@"dependency"] objectForKey:@"conditions"]) {
          if ([dependencyGraph objectForKey:[condition objectForKey:@"question"]] && ![(NSMutableArray *)[dependencyGraph objectForKey:[condition objectForKey:@"question"]] containsObject:[questionOrGroup objectForKey:@"uuid"]]) {
            [(NSMutableArray *)[dependencyGraph objectForKey:[condition objectForKey:@"question"]] addObject:[questionOrGroup objectForKey:@"uuid"]];
          } else {
            [dependencyGraph setObject:[NSMutableArray arrayWithObject:[questionOrGroup objectForKey:@"uuid"]] forKey:[condition objectForKey:@"question"]];
          }
        }
      }
    }
  }
//  DLog(@"dg: %@", dependencyGraph);
}
- (NSDictionary *) dependenciesTriggeredBy:(NSString *)qid {
  NSMutableArray *show = [[NSMutableArray alloc] init];
  NSMutableArray *hide = [[NSMutableArray alloc] init];
  for (NSString *q in [dependencyGraph objectForKey:qid]) {
    [self showDependency:[dependencies objectForKey:q]] ? [show addObject:q] : [hide addObject:q];
  }
  NSDictionary *triggered = [NSDictionary dictionaryWithObjectsAndKeys:show, @"show", hide, @"hide", nil];
  return triggered;
}
- (BOOL) showDependency:(NSDictionary *)dependency {
  if (dependency == nil) {
    return NS_YES;
  }
  // thanks to hyperjeff for code below
  
  // * in the expression you need 1=1 and 1=0 for the true / false values
  // * you can't use NSPredicate's predicateWithFormat: with the variable number of arguments when 
  //   passing in just an NSString, you have to use -predicateWithFormat:arguments: instead
  
  NSMutableString *rule = [NSMutableString stringWithString:[dependency objectForKey:@"rule"]];
  [rule replaceOccurrencesOfString:@"AND"
                        withString:@"&&"
                           options:NSLiteralSearch
                             range:NSMakeRange( 0, [rule length] )];
  [rule replaceOccurrencesOfString:@"OR"
                        withString:@"||"
                           options:NSLiteralSearch
                             range:NSMakeRange( 0, [rule length] )];
  
  NSMutableDictionary *values = [self evaluateConditions:[dependency objectForKey:@"conditions"]];
  
  for (NSString *key in values) {
    BOOL value = [[values valueForKey:key] boolValue];
    [rule replaceOccurrencesOfString:key
                          withString:value ? @"1=1" : @"0=1"
                             options:NSLiteralSearch
                               range:NSMakeRange( 0, [rule length] )];
  }
  
  NSPredicate *proposition = [NSPredicate predicateWithFormat:rule arguments:nil];
  BOOL evaluation = [proposition evaluateWithObject:nil];
  return evaluation;

}
- (NSMutableDictionary *) evaluateConditions:(NSArray *)conditions {
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init];

	for (NSDictionary *condition in conditions) {
		NSArray *responsesToQuestion = [self responsesForQuestion:[condition objectForKey:@"question"]];
		NSArray *responsesToAnswer = [self responsesForQuestion:[condition objectForKey:@"question"] Answer:[condition objectForKey:@"answer"]];
		id operator = [condition objectForKey:@"operator"];
		id value = [condition objectForKey:@"value"];
		
		NSError *error = NULL;
		NSRegularExpression *countsRegexp = [NSRegularExpression regularExpressionWithPattern:@"^count([<>=]{1,2})(\\d+)$" options:0 error:&error];
		NSTextCheckingResult *countsMatch = [countsRegexp firstMatchInString:operator options:0 range:NSMakeRange(0, [operator length])];
		
//		NSUInteger numberOfCountMatches = [countsRegexp numberOfMatchesInString:operator
//																												options:0
//																													range:NSMakeRange(0, [operator length])];	
//		DLog(@"count matches: %d", numberOfCountMatches);
		
		NSRegularExpression *countNotRegexp = [NSRegularExpression regularExpressionWithPattern:@"^count!=(\\d+)$" options:0 error:&error];
		NSTextCheckingResult *countNotMatch = [countNotRegexp firstMatchInString:operator options:0 range:NSMakeRange(0, [operator length])];

//		NSUInteger numberOfCountNotMatches = [countNotRegexp numberOfMatchesInString:operator
//																																		options:0
//																																			range:NSMakeRange(0, [operator length])];
//		DLog(@"count not matches: %d", numberOfCountNotMatches);
		
		if (countsMatch && [countsMatch numberOfRanges] > 2) {
			// count==1, count>=2, count<4
			NSPredicate *proposition = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%d %@ %d", responsesToQuestion.count, [operator substringWithRange:[countsMatch rangeAtIndex:1]], [[operator substringWithRange:[countsMatch rangeAtIndex:2]] intValue]]
																												arguments:nil];
			[values setObject:[proposition evaluateWithObject:nil] ? NS_YES : NS_NO
								 forKey:[condition objectForKey:@"rule_key"]];
		} else if (countNotMatch && [countNotMatch numberOfRanges] > 1){
			// count!=2
			[values setObject:[[operator substringWithRange:[countNotMatch rangeAtIndex:1]] intValue] == responsesToQuestion.count ? NS_NO : NS_YES
								 forKey:[condition objectForKey:@"rule_key"]];
		}	else if ([operator isEqualToString:@"=="]) {
			// ==
			if (value == kCFNull) { // http://www.enavigo.com/2011/02/08/sbjson-testing-for-nil-null-value/
				[values setObject:responsesToAnswer.count > 0 ? NS_YES : NS_NO
									 forKey:[condition objectForKey:@"rule_key"]];
			} else {
				[values setObject:responsesToAnswer.count > 0 && [[responsesToAnswer objectAtIndex:0] valueForKey:@"value"] == value ? NS_YES : NS_NO
									 forKey:[condition objectForKey:@"rule_key"]];
			}
		} else if ([operator isEqualToString:@">"] || [operator isEqualToString:@"<"] || [operator isEqualToString:@">="] || [operator isEqualToString:@"<="]) {
			// >, <, >=, <=
			NSPredicate *proposition = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ %@ %@", [[responsesToAnswer objectAtIndex:0] valueForKey:@"value"], operator, value]
																												arguments:nil];
			[values setObject:[proposition evaluateWithObject:nil] ? NS_YES : NS_NO
								 forKey:[condition objectForKey:@"rule_key"]];

		} else if ([operator isEqualToString:@"!="]) {
			// !=
			if (value == kCFNull) {
				[values setObject:responsesToAnswer.count > 0 ? NS_NO : NS_YES
									 forKey:[condition objectForKey:@"rule_key"]];
			} else {
				[values setObject:[[responsesToAnswer objectAtIndex:0] valueForKey:@"value"] == value ? NS_NO : NS_YES
									 forKey:[condition objectForKey:@"rule_key"]];
			}
		} else {
			// otherwise
			[values setObject:NS_NO forKey:[condition objectForKey:@"rule_key"]];
		}
			
//			def is_met?(responses)
//			# response to associated answer if available, or first response
//			response = if self.answer_id
//				responses.detect do |r| 
//					r.answer == self.answer
//				end 
//			end || responses.first
//			klass = response.answer.response_class
//			klass = "answer" if self.as(klass).nil?
//			return case self.operator
//			when "==", "<", ">", "<=", ">="
//				response.as(klass).send(self.operator, self.as(klass))
//			when "!="
//				!(response.as(klass) == self.as(klass))
//			when /^count[<>=]{1,2}\d+$/
//				op, i = self.operator.scan(/^count([<>!=]{1,2})(\d+)$/).flatten
//				responses.count.send(op, i.to_i)
//			when /^count!=\d+$/
//				!(responses.count == self.operator.scan(/\d+/).first.to_i)
//			else
//				false
//			end
//		end
	}
//	DLog(@"values: %@", values);
	return [values autorelease];
}
@end
