//
//  SurveyorQuestionView.h
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface SurveyorQuestionView : UIView <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
  @private
  NSArray *tableViewItems;
}

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc showNumber:(BOOL)showNumber;
- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc;
+ (void) initialize;
+ (int) nextNumber;
+ (void) resetNumber;

@end
