//
//  SurveyorNoneAnswerCell.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageCell.h"
#import "NUSectionVC.h"

@interface SurveyorNoneAnswerCell : PageCell {
  UITextField *textField;
  UILabel *label;
  UILabel *postLabel;
}
  
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *postLabel;
@property (nonatomic, retain) NUSectionVC *delegate;

@end
