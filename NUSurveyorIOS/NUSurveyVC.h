//
//  NUSurveyVC.h
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUSectionVC.h"
#import "NUResponseSet.h"

@interface NUSurveyVC : UITableViewController {
    
}

@property (nonatomic, retain) IBOutlet NUSectionVC *sectionController;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NUResponseSet *responseSet;
@property (nonatomic, assign) NSUInteger currentSection;

- (void) nextSection;
- (void) prevSection;
- (NSInteger) numberOfSections;
- (void) showSection:(NSUInteger) index;

@end
