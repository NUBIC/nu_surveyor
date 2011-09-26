//
//  NUPickerVC.h
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NUPickerVC : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UINavigationItem *bar;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nowButton;

-(void)setupDelegate:(id)delegate withTitle:(NSString *)title date:(Boolean)isDate;

@end
