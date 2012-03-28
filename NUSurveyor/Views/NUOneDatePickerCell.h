//
//  NUOneDatePickerCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 3/27/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUOneCell.h"
#import "NUPickerVC.h"

@interface NUOneDatePickerCell : NUOneCell <UIPopoverControllerDelegate>

@property (nonatomic, strong) NUPickerVC *pickerVC;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *type;

- (UIDatePickerMode)datePickerModeFromType:(NSString *)type;

@end
