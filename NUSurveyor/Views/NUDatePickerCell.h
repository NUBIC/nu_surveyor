//
//  NUDatePickerCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCell.h"
#import "NUSectionTVC.h"
#import "NUPickerVC.h"

@interface NUDatePickerCell : UITableViewCell <UIPopoverControllerDelegate, NUCell>

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) NUPickerVC *pickerVC;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (UIDatePickerMode)datePickerModeFromType:(NSString *)type;

@end
