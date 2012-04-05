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

- (NSDictionary*) toDict {
    NSString* createdAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"createdAt"]];
    NSString* modifiedAt = [[NSDateFormatter rfc3339DateFormatter] stringFromDate:[self valueForKey:@"modifiedAt"]];
    
    NSMutableDictionary* d = [NSMutableDictionary new];
    [d setValue:[self valueForKey:@"uuid"] forKey:@"uuid"];
    [d setValue:[self valueForKey:@"answer"] forKey:@"answer_id"];
    [d setValue:[self valueForKey:@"question"] forKey:@"question_id"];
    [d setValue:[self valueForKey:@"value"] forKey:@"value"];
    [d setValue:createdAt forKey:@"created_at"];
    [d setValue:modifiedAt forKey:@"modified_at"];
    
    return d;
}

- (NSString*) toJson {
  return [self.toDict JSONString];
}

@end
