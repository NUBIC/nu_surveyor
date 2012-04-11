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

+ (id)stepToVerifyNumberOfSections:(NSInteger)sections inTableViewWithAccessibilityLabel:(NSString *)tableViewLabel
{
  NSString *description = [NSString stringWithFormat:@"Step to verify there are %D sections in tableView with label '%@'", sections, tableViewLabel];
  
  return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel];
    
    KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
    UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
    
    KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
    
    KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
    
    NSInteger numberOfSections = [tableView.dataSource numberOfSectionsInTableView:tableView];
    KIFTestWaitCondition(numberOfSections == sections, error, @"Specified table view does not contain %D section%@", sections, sections == 1 ? @"" : @"s");
    
    return KIFTestStepResultSuccess;
  }];
}

+ (id)stepToVerifyNumberOfRows:(NSInteger)rows inSection:(NSInteger)section ofTableViewWithAccessibilityLabel:(NSString *)tableViewLabel
{
  NSString *description = [NSString stringWithFormat:@"Step to verify number of rows in section %D of tableView is %D", section, rows];
  
  return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel];
    
    KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
    UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
    
    KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
    
    KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
    
    NSInteger numberOfRows = [tableView.dataSource tableView:tableView numberOfRowsInSection:section];
    KIFTestWaitCondition(numberOfRows == rows, error, @"Specified section (%D) does not contain %D row%@", section, rows, rows == 1 ? @"" : @"s");
    
    return KIFTestStepResultSuccess;
  }];
}
@end
