//
//  KIFTestScenario+SectionAdditions.m
//  NUSurveyor
//
//  Created by Mark Yoon on 4/9/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "KIFTestScenario+SectionAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+SectionAdditions.h"

@implementation KIFTestScenario (SectionAdditions)

+ (id)scenarioToLogIn {
  
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
  [scenario addStep:[KIFTestStep stepToReset]];
  [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];
  
  return scenario;
}

@end
