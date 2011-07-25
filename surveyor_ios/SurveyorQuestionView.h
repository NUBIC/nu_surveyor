//
//  SurveyorQuestionView.h
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface SurveyorQuestionView : UIView <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
  NSMutableArray* responses;
  NSManagedObjectID *responseSetId;
}

@property (nonatomic, retain) NSMutableArray* responses;
@property (nonatomic, retain) NSManagedObjectID *responseSetId;

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc showNumber:(BOOL)showNumber;
- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc;
+ (void) initialize;
+ (void) resetNumber;

@end
