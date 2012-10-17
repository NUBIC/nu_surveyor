//
//  NUResponseTest.h
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "NUDatabaseTest.h"

@interface NUResponseTest : NUDatabaseTest

- (void)assertResponse:(NSDictionary*)actual uuid:(NSString*)uuid answerId:(NSString*)answerId questionId:(NSString*)questionId response_group:(NSString*)rgid value:(NSString*)value createdAt:(NSString*)createdAt modifiedAt:(NSString*)modifiedAt;

@end
