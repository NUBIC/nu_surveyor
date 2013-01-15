//
//  NSDateFormatter+NUAdditions.m
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSDateFormatter+NUAdditions.h"

@implementation NSDateFormatter (NUAdditions)

+ (NSDateFormatter*) rfc3339DateFormatter {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [f setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [f setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return f;
}

@end
