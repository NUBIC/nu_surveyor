//
//  NSDateFormatter+NUAdditions.m
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSDateFormatter+NUAdditions.h"

static NSDateFormatter* rfc3339DateFormatter;
static NSDateFormatter* dateTimeResponseFormatter;
static NSDateFormatter* dateResponseFormatter;
static NSDateFormatter* timeResponseFormatter;

@implementation NSDateFormatter (NUAdditions)

+ (NSDateFormatter*) rfc3339DateFormatter {
    if (!rfc3339DateFormatter) {
        rfc3339DateFormatter = [[NSDateFormatter alloc] init];
        [rfc3339DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"];
        [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return rfc3339DateFormatter;
}

+ (NSDateFormatter*) dateTimeResponseFormatter {
    if (!dateTimeResponseFormatter) {
        dateTimeResponseFormatter = [[NSDateFormatter alloc] init];
        [dateTimeResponseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateTimeResponseFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mmZZZZZ"];
        [dateTimeResponseFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return dateTimeResponseFormatter;
}

+ (NSDateFormatter*) dateResponseFormatter {
    if (!dateResponseFormatter) {
        dateResponseFormatter = [[NSDateFormatter alloc] init];
        [dateResponseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateResponseFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return dateResponseFormatter;
}

+ (NSDateFormatter*) timeResponseFormatter {
    if (!timeResponseFormatter) {
        timeResponseFormatter = [[NSDateFormatter alloc] init];
        [timeResponseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [timeResponseFormatter setDateFormat:@"HH:mm"];
    }
    return timeResponseFormatter;
}

@end
