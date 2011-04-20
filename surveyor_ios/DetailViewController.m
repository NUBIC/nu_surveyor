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
- (UIView *)addGroupView:(NSDictionary *)q atHeight:(float)y;

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
  }
  
  if (self.popoverController != nil) {
    [self.popoverController dismissPopoverAnimated:YES];
  }        
}


- (void)configureView {
  // Update the user interface for the detail item.
  for (UIView *subview in DetailScrollView.subviews) {
    [subview removeFromSuperview];
  }
  [self populateSection];
}

- (void)populateSection {
  float y = 0.0;
	for(NSDictionary *qg in [detailItem objectForKey:@"questions_and_groups"]){
    if([qg objectForKey:@"questions"] == nil){
      UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-(40), 10) json:qg] autorelease];
      //    UIView *q_view = [[[UIView alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-(40), 10)] autorelease];
      //    q_view.backgroundColor = [UIColor redColor];
      [DetailScrollView addSubview:q_view];
      y += q_view.frame.size.height+2;
    }else{
      UIView *g_view = [self addGroupView:qg atHeight:y];
      [DetailScrollView addSubview:g_view];
      y += g_view.frame.size.height;
    }
    //    NSLog(@"y: %f", y);
  }
  DetailScrollView.contentSize = CGSizeMake(DetailScrollView.frame.size.width, y+5.0);
}

- (UIView *)addGroupView:(NSDictionary *)q atHeight:(float)y {
  UILabel *qg_text = [[[UILabel alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-10, 65)] autorelease];
  qg_text.text = [q valueForKey:@"text"];
  if([q objectForKey:@"questions"]){
    for (NSDictionary *question in [q objectForKey:@"questions"]) {
      UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-(40), 10) json:question] autorelease];
      //    UIView *q_view = [[[UIView alloc] initWithFrame:CGRectMake(10, y, DetailScrollView.frame.size.width-(40), 10)] autorelease];
      //    q_view.backgroundColor = [UIColor redColor];
      [DetailScrollView addSubview:q_view];
      y += q_view.frame.size.height+2;
    }
  }
  return qg_text;
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
