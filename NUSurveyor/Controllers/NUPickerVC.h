//
//  NUPickerVC.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NUPickerVC : UIViewController

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *nowButton;

-(void)setupDelegate:(id)delegate withTitle:(NSString *)title date:(Boolean)isDate;

@end
