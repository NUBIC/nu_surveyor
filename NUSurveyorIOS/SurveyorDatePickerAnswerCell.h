//
//  SurveyorDatePickerAnswerCell.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageCell.h"
#import "NUPickerVC.h"
#import "NUSectionVC.h"

@interface SurveyorDatePickerAnswerCell : PageCell <UIPopoverControllerDelegate> {
}
@property (nonatomic, retain) NUPickerVC *pickerController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NUSectionVC *delegate;
@property (nonatomic, retain) NSDateFormatter *myDateFormatter;
@end
