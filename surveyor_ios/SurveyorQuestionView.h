//
//  SurveyorQuestionView.h
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static int qCount; // http://jongampark.wordpress.com/2009/04/25/class-variable-for-objective-c-and-c/

@interface SurveyorQuestionView : UIView {
    
}

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json showNumber:(BOOL)showNumber;
- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json;
+ (void) initialize;
+ (int) nextNumber;
+ (void) resetNumber;

@end
