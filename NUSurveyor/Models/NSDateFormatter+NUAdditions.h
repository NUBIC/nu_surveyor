//
//  NSDateFormatter+NUAdditions.h
//  NUSurveyor
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (NUAdditions)

+ (NSDateFormatter*) rfc3339DateFormatter;

+ (NSDateFormatter*) dateTimeResponseFormatter;

+ (NSDateFormatter*) dateResponseFormatter;

+ (NSDateFormatter*) timeResponseFormatter;

@end
