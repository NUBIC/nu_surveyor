//
//  UUID.m
//  surveyor_ios
//
//  Created by Mark Yoon on 7/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UUID.h"


@implementation UUID


// return a new autoreleased UUID string
// http://blog.ablepear.com/2010/09/creating-guid-or-uuid-in-objective-c.html
+ (NSString *)generateUuidString{
  // create a new UUID which you own
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  
  // create a new CFStringRef (toll-free bridged to NSString)
  // that you own
  NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
  
  // transfer ownership of the string
  // to the autorelease pool
  [uuidString autorelease];
  
  // release the UUID
  CFRelease(uuid);
  
  return uuidString;
}

@end
