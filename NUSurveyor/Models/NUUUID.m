//
//  UUID.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUUUID.h"

@implementation NUUUID

// http://blog.ablepear.com/2010/09/creating-guid-or-uuid-in-objective-c.html
// with modifications for ARC
+ (NSString *)generateUuidString{
  // create a new UUID which you own
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  
  // create a new CFStringRef (toll-free bridged to NSString) owned by ARC
  return (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
}
@end
