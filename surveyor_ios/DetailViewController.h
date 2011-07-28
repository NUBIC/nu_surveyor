//
//  DetailViewController.h
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
  
  UIPopoverController *popoverController;
  UIToolbar *toolbar;
  
  id detailItem;
  UILabel *detailDescriptionLabel;
	UITextView *detailTextView;
  UIScrollView *DetailScrollView;
	
	NSDictionary *dict;
  NSMutableArray *editViews;
  
  NSManagedObjectID *responseSetId;

}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UITextView *detailTextView;
@property (nonatomic, retain) IBOutlet UIScrollView *DetailScrollView;

@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NSMutableArray *editViews;

@property (nonatomic, retain) NSManagedObject *responseSet;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void) editViewResignFirstResponder;
- (void) prevField;
- (void) nextField;

@end
