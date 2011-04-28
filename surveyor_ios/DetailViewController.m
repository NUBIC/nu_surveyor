//
//  DetailViewController.m
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
- (void)populateSection;

@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, dict, detailTextView, DetailScrollView;

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
}

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
  y = [section_title.text sizeWithFont:section_title.font constrainedToSize:CGSizeMake(DetailScrollView.frame.size.width-40, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
  section_title.frame = CGRectMake(10, 10.0, DetailScrollView.frame.size.width-40, y);
//  [section_title sizeToFit];
  [DetailScrollView addSubview:section_title];
  
  y+= 20.0;
  
  // Questions and groups  
	for(NSDictionary *qg in [detailItem objectForKey:@"questions_and_groups"]){
    if([qg objectForKey:@"questions"] == nil){
      UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-40, 10) json:qg showNumber:true] autorelease];
//      q_view.backgroundColor = [UIColor redColor];
      [DetailScrollView addSubview:q_view];
      y += q_view.frame.size.height;
    }else{
      UIView *g_view = [[[SurveyorQuestionView alloc] initGroupWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-40, 10) json:qg] autorelease];
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
  for (UIView *subview in DetailScrollView.subviews) {
//    [subview sizeToFit];
  }  
}

#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

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
  // e.g. self.myOutlet = nil;
  self.popoverController = nil;
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
