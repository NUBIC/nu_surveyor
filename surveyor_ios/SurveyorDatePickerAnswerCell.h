//
//  SurveyorDatePickerAnswerCell.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageCell.h"
#import "DatePickerViewController.h"

@interface SurveyorDatePickerAnswerCell : PageCell <UIPopoverControllerDelegate> {
  DatePickerViewController *datePickerViewController;
  UIPopoverController *popoverController;
}
@property (nonatomic, retain) DatePickerViewController *datePickerViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@end
