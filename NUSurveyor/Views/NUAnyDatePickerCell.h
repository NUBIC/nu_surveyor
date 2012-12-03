//
//  NUAnyDatePickerCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 3/26/2012.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUAnyCell.h"
#import "NUPickerVC.h"

@interface NUAnyDatePickerCell : NUAnyCell <UIPopoverControllerDelegate>

@property (nonatomic, strong) NUPickerVC *pickerVC;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSDateFormatter *displayDateFormatter;
@property (nonatomic, strong) NSDateFormatter *storedDateFormatter;

- (UIDatePickerMode)datePickerModeFromType:(NSString *)type;

@end
