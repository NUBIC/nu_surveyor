//
//  NUResponse.m
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponse.h"
#import "SBJson.h"

@implementation NUResponse

- (NSDictionary*) toDict {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [self valueForKey:@"uuid"], @"uuid",
            [self valueForKey:@"answer"], @"answer_id",
            [self valueForKey:@"question"], @"question_id",
            [self valueForKey:@"value"], @"value", nil];
}

- (NSString*) toJson {
    SBJsonWriter* w = [[SBJsonWriter alloc] init];
    return [w stringWithObject:[self toDict]];
}

@end
