//
//  SurveyorPickerAnswerCell.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageCell.h"
#import "NUPickerVC.h"

@interface SurveyorPickerAnswerCell : PageCell <UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
}
@property (nonatomic, retain) NUPickerVC *pickerController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSDictionary *answers;
@end
