//
//  SurveyorNoneTextAnswerCell.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/15/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageCell.h"


@interface SurveyorNoneTextAnswerCell : PageCell {
  UITextView *textView;
  UILabel *label;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *label;

@end
