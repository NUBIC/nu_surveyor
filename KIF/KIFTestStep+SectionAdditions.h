//
//  KIFTestStep+SectionAdditions.h
//  NUSurveyor
//
//  Created by Mark Yoon on 4/9/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (SectionAdditions)


+ (id)stepToReset;
// via https://github.com/square/KIF/pull/108
/*!
 @method stepToVerifyNumberOfSections:inTableViewWithAccessibilityLabel:
 @abstract A step that verifies the number of sections in a table view with a given label.
 @discussion This step will get the view with the specified accessibility label and and compare it's number of sections with the value passed in.
 @param sections The number of sections the table view should be verified to have
 @param tableViewLabel Accessibility label of the table view.
 @result A configured test step.
 */
+ (id) stepToVerifyNumberOfSections:(NSInteger)sections inTableViewWithAccessibilityLabel:(NSString *)tableViewLabel;

/*!
 @method stepToVerifyNumberOfRows:inSection:ofTableViewWithAccessibilityLabel:
 @abstract A step that verifies the number of rows in a section at the given index in a table view with a given label.
 @discussion This step will get the view with the specified accessibility label and verify if the number of rows in the given section matches the values passed in.
 @param rows The number of rows the given section of the table view should be verified to have
 @param section The index of the section to verify the row count of
 @param tableViewLabel Accessibility label of the table view.
 @result A configured test step.
 */
+ (id) stepToVerifyNumberOfRows:(NSInteger)rows inSection:(NSInteger)section ofTableViewWithAccessibilityLabel:(NSString *)tableViewLabel;


@end
