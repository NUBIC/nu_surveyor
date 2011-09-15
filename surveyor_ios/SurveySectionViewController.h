//
//  SurveySectionViewController.h
//  surveyor_ios
//
//  Created by Mark Yoon on 9/7/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageViewController.h"

@interface SurveySectionViewController : PageViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITextViewDelegate> {
  id detailItem;
  UIPopoverController *popoverController;
  UIToolbar *toolbar;
  UIPageControl *pageControl;
  UILabel *detailDescriptionLabel;
}
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

- (void)createHeader;
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath;
+ (Class) classForQuestion:(NSDictionary *)questionOrGroup answer:(NSDictionary *)answer;

@end

