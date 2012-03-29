//
//  NUSpyVC.h
//  NUSurveyor
//
//  Created by Mark Yoon on 3/26/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUSurveyTVC.h"
#import "NUSectionTVC.h"


@protocol NUSpyVCDelegate
- (void) loadSurvey:(NSString *)pathforResource;
- (void) loadSurvey:(NSString *)pathforResource renderContext:(id)renderContext;
@end

@interface NUSpyVC : UIViewController

@property (nonatomic, weak) id <NUSpyVCDelegate> delegate;
@property (nonatomic, strong) NUSurveyTVC *surveyTVC;
@property (nonatomic, strong) NUSectionTVC *sectionTVC;

@end
