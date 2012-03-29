//
//  NUResponse.m
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponse.h"
//#import "SBJson.h"
#import "JSONKit.h"
#import "NSDateFormatter+Additions.h"

@implementation NUResponse

- (NSDictionary*) toDict {
    NSString* createdAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"createdAt"]];
    NSString* modifiedAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"modifiedAt"]];
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [self valueForKey:@"uuid"], @"uuid",
            [self valueForKey:@"answer"], @"answer_id",
            [self valueForKey:@"question"], @"question_id",
            [self valueForKey:@"value"], @"value",
            createdAt, @"created_at",
            modifiedAt, @"modified_at", nil];
}

- (NSString*) toJson {
//    SBJsonWriter* w = [[SBJsonWriter alloc] init];
//    return [w stringWithObject:[self toDict]];
  return [self.toDict JSONString];
}

@end
