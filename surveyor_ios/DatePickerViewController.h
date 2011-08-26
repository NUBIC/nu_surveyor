//
//  DatePickerViewController.h
//  surveyor_ios
//
//  Created by Mark Yoon on 7/29/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController {
  UIDatePicker *picker;
  UINavigationItem *bar;
  UIBarButtonItem *now;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UINavigationItem *bar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *now;

-(void)setupDelegate:(id)delegate withTitle:(NSString *)title;

@end
