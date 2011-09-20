//
//  SurveySectionViewController.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/7/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveySectionViewController.h"
#import "TextFieldCell.h"
#import "UILabel+Resize.h"

static const double PageViewControllerTextAnimationDuration = 0.33;

@implementation SurveySectionViewController
@synthesize detailItem, toolbar, popoverController, pageControl, detailDescriptionLabel;


+ (Class) classForQuestion:(NSDictionary *)questionOrGroup answer:(NSDictionary *)answer {
  NSString *className;
  if ([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"one"]) {
    className = [(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"dropdown"] ? 
    @"SurveyorPickerAnswerCell" : @"SurveyorOneAnswerCell";
    
  } else if([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"any"]){
    className = @"SurveyorAnyAnswerCell";
  } else {
    className = @"SurveyorNoneAnswerCell";
    if ([[answer objectForKey:@"type"] isEqualToString:@"date"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"time"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"datetime"] ) {
      className = @"SurveyorDatePickerAnswerCell";
    }
    if ([[answer objectForKey:@"type"] isEqualToString:@"text"]) {
      className = @"SurveyorNoneTextAnswerCell";
    }
  }
  return [NSClassFromString(className) class];
}

//
// title
//
// returns the navigation bar text for the front screen
//
- (NSString *)title
{
	return NSLocalizedString(@"TableViewRevisited", @"");
}

- (CGFloat)widthBasedOnOrientation {
  //  NSLog(@"%d", [[UIApplication sharedApplication] statusBarOrientation]);
  if([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight){
    return self.view.frame.size.width - 20.0;
  }else{
    return self.view.frame.size.width - 65.0 - 20.0;
  }
}

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
  if (detailItem != newDetailItem) {
    [detailItem release];
    detailItem = [newDetailItem retain];
    
    // Update the view.
//    [self configureView];
//    DetailScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
  }
  
  if (self.popoverController != nil) {
    [self.popoverController dismissPopoverAnimated:YES];
  }
}

//
// createRows
//
// Constructs all the rows on the front screen and animates them in
//
- (void)createRows
{ 
  [self createHeader];
  NSInteger i = 0;
  // Questions and groups
	for(NSDictionary *questionOrGroup in [detailItem objectForKey:@"questions_and_groups"]){
    if([questionOrGroup objectForKey:@"questions"] == nil){
      // regular questions
      if (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"]) {
        [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];        
        if ([(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"dropdown"]){
          [self
           appendRowToSection:i
           cellClass: [NSClassFromString(@"SurveyorPickerAnswerCell") class]
           cellData: [questionOrGroup objectForKey:@"answers"]
           withAnimation: UITableViewRowAnimationFade];
        } else {
          for (NSDictionary *answer in [questionOrGroup objectForKey:@"answers"]){
            [self
             appendRowToSection:i
             cellClass: [[self class] classForQuestion:questionOrGroup answer:answer]
             cellData:answer
             withAnimation: UITableViewRowAnimationFade];
          }
        }
        i++;
      }
    } else{
      
    }
  }
	[self hideLoadingIndicator];
}



//
// refresh
//
// Removes all existing rows and starts a reload (on a 0.5 second timer)
//
- (void)refresh:(id)sender
{
	[self removeAllSectionsWithAnimation:UITableViewRowAnimationFade];
	[self performSelector:@selector(createRows) withObject:nil afterDelay:0.5];
	[self showLoadingIndicator];
}

//
// viewDidLoad
//
// (previous behavior) On load, refreshes the view (to load the rows)
// The RootViewController now handles refreshing the child
//
- (void)viewDidLoad
{
  [super viewDidLoad];
	self.useCustomHeaders = YES;
  
  UISwipeGestureRecognizer *r = [[UISwipeGestureRecognizer alloc] initWithTarget:UIAppDelegate.rootViewController action:@selector(prevSection)];
  r.direction = UISwipeGestureRecognizerDirectionRight;
  
  UISwipeGestureRecognizer *l = [[UISwipeGestureRecognizer alloc] initWithTarget:UIAppDelegate.rootViewController action:@selector(nextSection)];
  l.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:r];
  [self.view addGestureRecognizer:l];
//	[self refresh:nil];
}

//
// loadView
//
// 
//
- (void)loadView
{
  [super loadView];
//  UITableView * aTableView = 
//  [[[UITableView alloc] 
//    initWithFrame:CGRectZero 
//    style:UITableViewStyleGrouped] 
//   autorelease];
//	self.view = aTableView;
//	self.tableView = aTableView;
}
- (void) dealloc {
  [super dealloc];
  
  [detailItem release];
  [popoverController release];
  [toolbar release];
  [pageControl release];
  [detailDescriptionLabel release];
  
}


//
// textFieldDidEndEditing:
//
// Update the rowData for the text field rows to match the edited value of the
// text field.
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	UIView *parentOfParent = textField.superview.superview;
	if ([parentOfParent isKindOfClass:[TextFieldCell class]])
	{
		TextFieldCell *cell = (TextFieldCell *)parentOfParent;
		NSIndexPath *indexPathForCell = [self.tableView indexPathForCell:cell];
		NSMutableDictionary *rowData =
    [self dataForRow:indexPathForCell.row inSection:indexPathForCell.section];
		[rowData setObject:textField.text forKey:@"value"];
	}
}

#pragma mark - Table and section headers

//
// createHeader
//
// Constructs the tableview header from the section title
//
- (void)createHeader{
  // Section title
  BOOL isGrouped = tableView.style == UITableViewStyleGrouped;
  const CGFloat HorizontalMargin = isGrouped ? 20.0 : 5.0;
  const CGFloat VerticalMargin = 10.0;

  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  UILabel *section_title = [[UILabel alloc] initWithFrame:CGRectMake(HorizontalMargin, VerticalMargin, tableView.bounds.size.width - (2 * HorizontalMargin), 22.0)];
  section_title.text = [detailItem valueForKey:@"title"];
  [section_title setUpMultiLineVerticalResizeWithFontSize:22.0];
  section_title.backgroundColor = isGrouped ?
  [UIColor clearColor] :
  [UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
  headerView.frame = CGRectMake(0.0, 0.0, tableView.bounds.size.width, section_title.frame.size.height + (2 * VerticalMargin));
  [headerView addSubview:section_title];
  [section_title release];
  self.tableView.tableHeaderView = headerView;  
}

//
// tableView:titleForHeaderInSection:
//
// Header text for the three sections
//
// Parameters:
//    aTableView - the table
//    section - the section for which header text should be returned
//
// returns the header text for the appropriate section
//
- (NSString *)tableView:(UITableView *)aTableView
titleForHeaderInSection:(NSInteger)section
{
  if (section > [[detailItem valueForKey:@"questions_and_groups"] count] - 1 ) {
    return nil;
  }
  return [[[detailItem valueForKey:@"questions_and_groups"] objectAtIndex:section] objectForKey:@"text"];
}

//
// tableView:subTitleForHeaderInSection:
//
// Parameters:
//    aTableView - the table
//    section - the section for which header text should be returned
//
// returns the header subTitle text for the appropriate section
//
- (NSString *)tableView:(UITableView *)aTableView
subTitleForHeaderInSection:(NSInteger)section
{
  if (section > [[detailItem valueForKey:@"questions_and_groups"] count] - 1 ) {
    return nil;
  }
  return [[[detailItem valueForKey:@"questions_and_groups"] objectAtIndex:section] objectForKey:@"help_text"];
}

#pragma mark - UITableViewDelegate

//
// tableView:didSelectRowAtIndexPath:
//
// Handle row selection
//
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
	PageCell *cell = (PageCell *)[aTableView cellForRowAtIndexPath:anIndexPath];
	if ([cell isKindOfClass:NSClassFromString(@"SurveyorAnyAnswerCell")])
	{
    UIImage *img = [aTableView cellForRowAtIndexPath:anIndexPath].imageView.image;
    [aTableView cellForRowAtIndexPath:anIndexPath].imageView.image = 
      img == [UIImage imageNamed:@"unchecked"] ? [UIImage imageNamed:@"checked"] : [UIImage imageNamed:@"unchecked"]; 
	} else if ([cell isKindOfClass:NSClassFromString(@"SurveyorOneAnswerCell")]) {
    for (int i = 0; i < [aTableView numberOfRowsInSection:anIndexPath.section]; i++) {
      [aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:anIndexPath.section]].imageView.image = 
        i == anIndexPath.row ? [UIImage imageNamed:@"dotted"] : [UIImage imageNamed:@"undotted"];
    }
  }
	
	[cell handleSelectionInTableView:aTableView];
}

#pragma mark - Keyboard support

//
// keyboardWillHideNotification:
//
// Slides the view back when done editing.
//
- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
	if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.tableView.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}

//
// keyboardWillShowNotification:
//
// Slides the view to avoid the keyboard.
//
- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
  //
	// Remove any previous view offset.
	//
	[self keyboardWillHideNotification:nil];
  
  //
	// Only animate if the text field is part of the hierarchy that we manage.
	//
	UIView *parentView = [currentTextField superview];
	while (parentView != nil && ![parentView isEqual:self.tableView])
	{
		parentView = [parentView superview];
	}
	if (parentView == nil)
	{
		//
		// Not our hierarchy... ignore.
		//
		return;
	}
  
  //
  // https://github.com/futuretap/InAppSettingsKit/blob/master/InAppSettingsKit/Controllers/IASKAppSettingsViewController.m
  //
  
  NSDictionary* userInfo = [aNotification userInfo];
  // we don't use SDK constants here to be universally compatible with all SDKs ≥ 3.0
  NSValue* keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
  if (!keyboardFrameValue) {
    keyboardFrameValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
  }
  
  textFieldAnimatedDistance = 0;
  textFieldAnimatedDistance = [keyboardFrameValue CGRectValue].size.height;
  CGRect newframe = self.tableView.frame;
  newframe.size.height -= textFieldAnimatedDistance;
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
  [self.tableView setFrame:newframe];
  [UIView commitAnimations];
	
	const CGFloat PageViewControllerTextFieldScrollSpacing = 40;
  
	CGRect textFieldRect =
  [self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];
}

#pragma mark - Split view support

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

@end