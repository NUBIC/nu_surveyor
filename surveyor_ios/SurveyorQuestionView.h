//
//  SurveyorQuestionView.h
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "QuestionResponse.h"

@interface SurveyorQuestionView : UIView <UIPopoverControllerDelegate> {

}

@property (nonatomic, retain) QuestionResponse *questionResponse;

- (id)initWithFrame:(CGRect)frame questionResponse:(QuestionResponse *)qr controller:(DetailViewController *)dvc showNumber:(BOOL)showNumber;
- (id)initGroupWithFrame:(CGRect)frame questionResponse:(QuestionResponse *)qr controller:(DetailViewController *)dvc;
+ (void) initialize;
+ (void) resetNumber;

@end
