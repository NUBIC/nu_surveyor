//
//  NUPickerVC.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NUPickerVCDelegate;

@interface NUPickerVC : UIViewController

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nowButton;

-(void)setupDelegate:(id <NUPickerVCDelegate>)delegate withTitle:(NSString *)title date:(Boolean)isDate;
@end

@protocol NUPickerVCDelegate <NSObject>

@optional
-(void)pickerViewControllerDidCancel:(NUPickerVC *)pickerViewController;
-(void)pickerViewControllerIsDone:(NUPickerVC *)pickerViewController;

@end
