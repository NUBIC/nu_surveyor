//
//  NUSectionTVC.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NUResponseSet.h"
#import "NUCell.h"
#import "GRMustache.h"


@class NUSectionTVC;

@protocol NUSectionTVCDelegate
- (void)prevSection;
- (void)nextSection;
- (void)surveyDone;
@end

@interface NUSectionTVC : UITableViewController <UIPopoverControllerDelegate, 
                                                  UISplitViewControllerDelegate, 
                                                  UITableViewDelegate, 
                                                  UITextFieldDelegate, 
                                                  UITextViewDelegate, 
                                                  GRMustacheTemplateDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) id detailItem;
@property (nonatomic, strong) NUResponseSet *responseSet;
@property (nonatomic, strong) NSMutableArray *visibleSections;
@property (nonatomic, strong) NSMutableArray *allSections;
@property (nonatomic, strong) NSMutableArray *visibleHeaders;
@property (nonatomic, strong) NSString *prevSectionTitle;
@property (nonatomic, strong) NSString *nextSectionTitle;
@property (nonatomic, weak) id <NUSectionTVCDelegate> delegate;
@property (nonatomic, strong) id renderContext;

// Utility class methods
+ (NSString *) classNameForQuestion:(NSDictionary *)questionOrGroup answer:(NSDictionary *)answer;

// Core data
- (NSArray *) responsesForIndexPath:(NSIndexPath *)i;
- (NSManagedObject *) newResponseForIndexPath:(NSIndexPath *)i;
- (NSManagedObject *) newResponseForIndexPath:(NSIndexPath *)i Value:(NSString *)value;
- (void) deleteResponseForIndexPath:(NSIndexPath *)i;

// Dependencies
- (void) showAndHideDependenciesTriggeredBy:(NSIndexPath *)i;

// Mustache
- (NSString *) renderMustacheFromString:(NSString *)string;
@end
