//
//  NUSurveyTVC.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUSectionTVC.h"
#import "NUSurvey.h"
#import "NUResponseSet.h"

@class NUSurveyTVC;

@protocol NUSurveyTVCDelegate
- (void)surveyDone;
@end

@interface NUSurveyTVC : UITableViewController <NUSectionTVCDelegate>
@property (nonatomic, strong) NSDictionary *surveyNSD;
@property (nonatomic, strong) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) NUSurvey *survey;
@property (nonatomic, weak) id <NUSurveyTVCDelegate> delegate;

- (id)initWithSurvey:(NUSurvey *)survey responseSet:(NUResponseSet *)responseSet;
- (id)initWithSurvey:(NUSurvey *)survey responseSet:(NUResponseSet *)responseSet renderContext:(id)renderContext;
- (void) nextSection;
- (void) prevSection;
- (void) surveyDone;
-(void) surveySelectedLanguage:(NSString *)localeString;
@end
