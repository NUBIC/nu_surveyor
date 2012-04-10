//
//  KIFTestStep+SectionAdditions.m
//  NUSurveyor
//
//  Created by Mark Yoon on 4/9/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "KIFTestStep+SectionAdditions.h"

@implementation KIFTestStep (SectionAdditions)


+ (id)stepToReset {
  return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
    BOOL successfulReset = YES;
    
    // Do the actual reset for your app. Set successfulReset = NO if it fails.
    
    KIFTestCondition(successfulReset, error, @"Failed to reset the application.");
    
    return KIFTestStepResultSuccess;
  }];
}

@end
