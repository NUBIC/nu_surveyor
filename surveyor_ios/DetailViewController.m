//
//  DetailViewController.m
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "SurveyorQuestionView.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIView *editView;
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
- (void)populateSection;
- (void)showScrollViewWidth;
- (CGFloat)widthBasedOnOrientation;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, dict, detailTextView, DetailScrollView, editView;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
  if (detailItem != newDetailItem) {
    [detailItem release];
    detailItem = [newDetailItem retain];
    
    // Update the view.
    [self configureView];
    DetailScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
  }
  
  if (self.popoverController != nil) {
    [self.popoverController dismissPopoverAnimated:YES];
  }        
}

- (void)configureView {
  // Update the user interface for the detail item.
  
  for (UIView *subview in DetailScrollView.subviews) {
    // Don't remove the scroll indicator
    if ([subview isKindOfClass:[SurveyorQuestionView class]]) {
      [subview removeFromSuperview];
    }
  }
  [self populateSection];

//  [self showScrollViewWidth];
//  UILabel *mybox = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10,  DetailScrollView.frame.size.width - 20.0 , 300)] autorelease];
//  mybox.text = @"As mentioned previously, this method gets called just before the user interface rotation takes place. Passed through as an argument to this method is the new orientation of the device in the form of the toInterfaceOrientation variable. Within the body of the method we identify if the device has rotated to a landscape or portrait orientation. Using the CGRectMake method (which takes x, y, width and height as arguments) we create a CGRect structure containing the new co-ordinates and dimensions for each button and assign them to the frame property of the button instances. When the method returns, the system will then proceed to draw the buttons using the new";
//  [mybox setUpMultiLineFrameWithStartXPosition:10.0 withStartYPosition:10.0];

//  mybox.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  mybox.backgroundColor = [UIColor greenColor];
//  mybox.lineBreakMode = UILineBreakModeWordWrap;
//  mybox.numberOfLines = 0;

//  mybox.contentMode = UIViewContentModeTopLeft;
//  mybox.frame = CGRectMake(mybox.frame.origin.x, mybox.frame.origin.y, mybox.frame.size.width, [mybox.text sizeWithFont:mybox.font constrainedToSize:CGSizeMake(DetailScrollView.frame.size.width-20, 9999) lineBreakMode:UILineBreakModeWordWrap].height);

//  [DetailScrollView addSubview:mybox];

}


- (void)showScrollViewWidth {
  self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%f", DetailScrollView.frame.size.width];
};
- (void)populateSection {
  [SurveyorQuestionView resetNumber];
  float y = 0.0;
  
  // Section title
  UILabel *section_title = [[[UILabel alloc] init] autorelease];
//  UILabel *section_title = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, DetailScrollView.frame.size.width, 5)] autorelease];

  section_title.font = [UIFont fontWithName:section_title.font.fontName size:22.0];
  section_title.lineBreakMode = UILineBreakModeWordWrap;
  section_title.numberOfLines = 0;
  section_title.text = [detailItem valueForKey:@"title"];
//  section_title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  section_title.contentMode = UIViewContentModeTopLeft;
//  section_title.backgroundColor = [UIColor greenColor];
  y = [section_title.text sizeWithFont:section_title.font constrainedToSize:CGSizeMake([self widthBasedOnOrientation], 9999) lineBreakMode:UILineBreakModeWordWrap].height;
  section_title.frame = CGRectMake(10, 10.0, [self widthBasedOnOrientation], y);
//  [section_title sizeToFit];
  [DetailScrollView addSubview:section_title];
  
  y+= 20.0;
  
  // Questions and groups  
	for(NSDictionary *qg in [detailItem objectForKey:@"questions_and_groups"]){
    if([qg objectForKey:@"questions"] == nil){
      SurveyorQuestionView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(10, y, [self widthBasedOnOrientation], 10) json:qg controller:self showNumber:true] autorelease];
//      q_view.backgroundColor = [UIColor redColor];
      [DetailScrollView addSubview:q_view];
      y += q_view.frame.size.height;
    }else{
      SurveyorQuestionView *g_view = [[[SurveyorQuestionView alloc] initGroupWithFrame:CGRectMake(10, y, [self widthBasedOnOrientation], 10) json:qg controller:self] autorelease];
//      g_view.backgroundColor = [UIColor redColor];
      [DetailScrollView addSubview:g_view];
      y += g_view.frame.size.height;
    }
    //    NSLog(@"y: %f", y);
  }
  DetailScrollView.contentSize = CGSizeMake(DetailScrollView.frame.size.width, y+5.0);
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Sections"; //@"Root List";
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items insertObject:barButtonItem atIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items removeObjectAtIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = nil;
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//  for (UIView *subview in DetailScrollView.subviews) {
//    [subview sizeToFit];
//  }
//}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//  for (UIView *subview in DetailScrollView.subviews) {
//    [subview sizeToFit];
//  }  
//  [self showScrollViewWidth];
  DetailScrollView.contentSize = CGSizeMake(DetailScrollView.frame.size.width, DetailScrollView.contentSize.height);
}
- (CGFloat)widthBasedOnOrientation {
//  NSLog(@"%d", [[UIApplication sharedApplication] statusBarOrientation]);
  if([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight){
    return DetailScrollView.frame.size.width - 20.0;
  }else{
    return DetailScrollView.frame.size.width - 65.0 - 20.0;
  }
}

#pragma mark -
#pragma mark Keyboard Notifications

- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  
  /*
   Reduce the size of the text view so that it's not obscured by the keyboard.
   Animate the resize so that it's in sync with the appearance of the keyboard.
   */
  
  NSDictionary* userInfo = [notification userInfo];
  CGSize kbSize = [self.view convertRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil].size;
  
  // Get the duration of the animation.
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];
  
  // Animate the resize of the text view's frame in sync with the keyboard's appearance.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  
  // If active text field is hidden by keyboard, scroll it so it's visible
  CGPoint editViewOrigin = [editView convertPoint:editView.frame.origin toView:self.view];
  if (self.view.frame.size.height - kbSize.height < editViewOrigin.y) {
//    NSLog(@"view height:%f kbheight: %f, tap point: %f", self.view.frame.size.height, kbSize.height, editViewOrigin.y);
    [DetailScrollView setContentOffset:CGPointMake(0.0, DetailScrollView.contentOffset.y + kbSize.height) animated:YES];
  }
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  DetailScrollView.contentInset = contentInsets;
  DetailScrollView.scrollIndicatorInsets = contentInsets;
  
  [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
  /*
   Restore the size of the text view (fill self's view).
   Animate the resize so that it's in sync with the disappearance of the keyboard.
   */
  
  NSDictionary* userInfo = [notification userInfo];
  
  // Get the duration of the animation.
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];
  
  // Animate the resize of the text view's frame in sync with the keyboard's appearance.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  DetailScrollView.contentInset = contentInsets;
  DetailScrollView.scrollIndicatorInsets = contentInsets;
  
  [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextView and UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  //  NSLog(@"top: %f", [textField convertPoint:textField.frame.origin toView:self.view].y);
  editView = textField;
  return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  //  NSLog(@"top: %f", [textView convertPoint:textView.frame.origin toView:self.view].y);
  editView = textView;
  return YES;
}

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 [super viewDidLoad];
 [self registerForKeyboardNotifications];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  self.popoverController = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

- (void)dealloc {
  [popoverController release];
  [toolbar release];
  
	[detailTextView release];
  [detailItem release];
  [detailDescriptionLabel release];
  [super dealloc];
}

@end
