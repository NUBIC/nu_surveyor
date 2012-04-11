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

+ (id)scenarioDuplicateDependencies {
  
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test group dependencies for showing more than once"];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Inspect"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"loadPbj"]];
  [scenario addStep:[KIFTestStep stepToVerifyNumberOfSections:1 inTableViewWithAccessibilityLabel:@"sectionTableView"]];
  [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"sectionTableView" atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
  [scenario addStep:[KIFTestStep stepToVerifyNumberOfSections:3 inTableViewWithAccessibilityLabel:@"sectionTableView"]];
  [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1 description:@"wait for dependenices to show"]];
  [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"sectionTableView" atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
  [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1 description:@"wait for dependenices to show"]];
  [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"sectionTableView" atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
  [scenario addStep:[KIFTestStep stepToVerifyNumberOfSections:3 inTableViewWithAccessibilityLabel:@"sectionTableView"]];
  return scenario;
}

@end
