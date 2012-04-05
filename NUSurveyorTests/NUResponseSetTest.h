//
//  NUResponsetSetTest.h
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NUDatabaseTest.h"

@interface NUResponseSetTest : NUDatabaseTest

- (void)assertResponseSet:(NSDictionary *)actual uuid:(NSString*)uuid surveyId:(NSString*)surveyId createdAt:(NSString*)createdAt completedAt:(NSString*)completedAt responses:(NSInteger)responses;

    
@end
