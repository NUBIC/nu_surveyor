//
//  NUSectionVC.m
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import "NUSectionVC.h"
#import "NUSurveyVC.h"
#import "PageCell.h"
#import "UILabel+Resize.h"
#import "UUID.h"

static const double PageViewControllerTextAnimationDuration = 0.33;

@interface NUSectionVC()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
- (NSDictionary *)idsForIndexPath:(NSIndexPath *)i;
- (void) createQuestionWithIndex:(NSInteger)i dictionary:(NSDictionary *)question;
@end

@implementation NUSectionVC
@synthesize bar, pageControl, popoverController, detailItem, responseSet, visibleSections, allSections;
// sectionTitles, sectionSubTitles, sections, 

#pragma mark - Utility class methods
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

#pragma mark - Memory management
- (void)dealloc
{
  [super dealloc];
  [bar release];
  [pageControl release];
  [popoverController release];
  [detailItem release];
//  [sectionTitles release];
//  [sectionSubTitles release];
//  [sections release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//
// viewDidLoad
//
// (previous behavior) On load, refreshes the view (to load the rows)
// The NUSurveyVC now handles refreshing the child
//
- (void)viewDidLoad
{
  [super viewDidLoad];
	self.useCustomHeaders = YES;
  
  UISwipeGestureRecognizer *r = [[UISwipeGestureRecognizer alloc] initWithTarget:UIAppDelegate.surveyController action:@selector(prevSection)];
  r.direction = UISwipeGestureRecognizerDirectionRight;
  
  UISwipeGestureRecognizer *l = [[UISwipeGestureRecognizer alloc] initWithTarget:UIAppDelegate.surveyController action:@selector(nextSection)];
  l.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:r];
  [self.view addGestureRecognizer:l];
  //	[self refresh:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
	return YES;
}

#pragma mark - Core Data
- (NSDictionary *)idsForIndexPath:(NSIndexPath *)i{
  if (i.section < [visibleSections count] && i.row < [[[self questionOrGroupWithUUID:[visibleSections objectAtIndex:i.section]] objectForKey:@"answers"] count]) {
    NSString *qid = [[allSections objectAtIndex:i.section] objectForKey:@"uuid"];
    NSString *aid = [[[[self questionOrGroupWithUUID:[visibleSections objectAtIndex:i.section]] objectForKey:@"answers"] objectAtIndex:i.row] objectForKey:@"uuid"];
    //  DLog(@"i: %@ section: %d row: %d qid: %@ aid: %@", i, i.section, i.row, qid, aid);
    return [NSDictionary dictionaryWithObjectsAndKeys:qid, @"qid", aid, @"aid", nil];
  }else{
    // this happens when the tableview is refreshed
    // and self.tableView deleteSections is called
    return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"qid", nil, @"aid", nil];
  }
}

- (NSArray *) responsesForIndexPath:(NSIndexPath *)i{
  NSDictionary *ids = [self idsForIndexPath:i];
  return [self.responseSet responsesForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"]];
}
- (NSManagedObject *) newResponseForIndexPath:(NSIndexPath *)i Value:(NSString *)value{
  NSDictionary *ids = [self idsForIndexPath:i];
  return [self.responseSet newResponseForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"] Value:value];
}
- (NSManagedObject *) newResponseForIndexPath:i {
  return [self newResponseForIndexPath:i Value:nil];
}
- (void) deleteResponseForIndexPath:(NSIndexPath *)i {
  NSDictionary *ids = [self idsForIndexPath:i];
  [self.responseSet deleteResponseForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"]];
}

#pragma mark - PageViewController subclass
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
//  self.sectionTitles = [[NSMutableArray alloc] init];
//  self.sectionSubTitles = [[NSMutableArray alloc] init];
//  self.sections = [[NSMutableArray alloc] init];
  
  [self createHeader];
  
  // generate a full listing of all questions, including labels, 
  //   hidden questions, dependent questions, as well as separate 
  //   sections for group titles and their grouped questions, etc.
  self.allSections = [[NSMutableArray alloc] init];
  for(NSDictionary *questionOrGroup in [detailItem objectForKey:@"questions_and_groups"]){
    // regular questions, grids
    [allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [questionOrGroup objectForKey:@"uuid"] == nil ? [UUID generateUuidString] : [questionOrGroup objectForKey:@"uuid"], @"uuid",
                            questionOrGroup, @"question",
                            (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] ) ? NS_YES : NS_NO, @"show", nil ]];
    DLog(@"uuid: %@ questionOrGroup: %@", [questionOrGroup objectForKey:@"uuid"], questionOrGroup);
    
    if (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
      // inline, repeaters
      for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
        [allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [question objectForKey:@"uuid"], @"uuid",
                                question, @"question",
                                (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"]) ? NS_YES : NS_NO, @"show", nil ]];
      }
    }
  }
//  DLog(@"all sections: %@", allSections);
  self.visibleSections = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *questionOrGroup in allSections) {
    DLog(@"show: %@, question: %@, uuid: %@", [questionOrGroup objectForKey:@"show"], [[questionOrGroup objectForKey:@"question"] objectForKey:@"text"], [questionOrGroup objectForKey:@"uuid"] );
    if ([questionOrGroup objectForKey:@"show"] == NS_YES) {
      [self createQuestionWithIndex:visibleSections.count dictionary:[questionOrGroup objectForKey:@"question"]];
      [visibleSections addObject:[questionOrGroup objectForKey:@"uuid"]];
    }
  }
//  DLog(@"visible sections: %@", visibleSections);
  
//  NSInteger i = 0;
//  // Questions and groups
//	for(NSDictionary *questionOrGroup in [detailItem objectForKey:@"questions_and_groups"]){
//    if([questionOrGroup objectForKey:@"questions"] == nil){
//      // regular questions
//      if (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"]) {
//        [self createQuestionWithIndex:i dictionary:questionOrGroup];
//        i++;
//      }
//    } else{
//      // question groups
//      // grid
//      // repeater
//      if ([[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
//        [self createQuestionWithIndex:i dictionary:questionOrGroup];
//        i++;
//      } else {
//        // inline
//        [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];  
//        [sections insertObject:questionOrGroup atIndex:i];
//        if ([questionOrGroup objectForKey:@"text"] != nil) {
//          [sectionTitles insertObject:[questionOrGroup objectForKey:@"text"] atIndex:i];
//        } else {
//          [sectionTitles insertObject:@"" atIndex:i];
//        }
//        if ([questionOrGroup objectForKey:@"help_text"]) {
//          [sectionSubTitles insertObject:[questionOrGroup objectForKey:@"help_text"] atIndex:i];
//        } else {
//          [sectionSubTitles insertObject:@"" atIndex:i];
//        }
//        i++;
//        for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
//          [self createQuestionWithIndex:i dictionary:question];
//          [sections insertObject:question atIndex:i];
//          i++;
//        }
//      }
//      
//    }
//  }
	[self hideLoadingIndicator];
}
- (void) createQuestionWithIndex:(NSInteger)i dictionary:(NSDictionary *)question {
  [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
//  [sections insertObject:question atIndex:i];
//  if ([question objectForKey:@"text"] != nil) {
//    [sectionTitles insertObject:[question objectForKey:@"text"] atIndex:i];
//  } else {
//    [sectionTitles insertObject:@"" atIndex:i];
//  }
//  if ([question objectForKey:@"help_text"]) {
//    [sectionSubTitles insertObject:[question objectForKey:@"help_text"] atIndex:i];
//  } else {
//    [sectionSubTitles insertObject:@"" atIndex:i];
//  }
  
  if ([(NSString *)[question objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[question objectForKey:@"type"] isEqualToString:@"slider"]){
    [self
     appendRowToSection:i
     cellClass: [NSClassFromString(@"SurveyorPickerAnswerCell") class]
     cellData: [question objectForKey:@"answers"]
     withAnimation: UITableViewRowAnimationFade];
  } else {
    for (NSDictionary *answer in [question objectForKey:@"answers"]){
      DLog(@"answer");
      [self
       appendRowToSection:i
       cellClass: [[self class] classForQuestion:question answer:answer]
       cellData:answer
       withAnimation: UITableViewRowAnimationFade];
    }
  }
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

- (NSMutableDictionary *)questionOrGroupWithUUID:(NSString *)uuid{
//  ^int (int x) { return x*3; }
  NSUInteger i = [allSections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ 
    if ([[obj objectForKey:@"uuid"] isEqualToString:uuid]) {
      return YES;
    }
    return NO;
  }];
  return [[allSections objectAtIndex:i] objectForKey:@"question"];
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
  if (section >= visibleSections.count) {
    return nil;
  } else {
    return [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"text"];
  }
  
//  if(section > ((NSInteger)[sectionTitles count] -1)) {
//    return nil;
//  } else {
//    return [sectionTitles objectAtIndex:section];
//  }

  //  if (section > [[detailItem valueForKey:@"questions_and_groups"] count] - 1 ) {
  //    return nil;
  //  }
  //  return [[[detailItem valueForKey:@"questions_and_groups"] objectAtIndex:section] objectForKey:@"text"];
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
  if (section >= visibleSections.count) {
    return nil;
  } else {
    return [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"help_text"];
  }

  
  //  if (section > [[detailItem valueForKey:@"questions_and_groups"] count] - 1 ) {
  //    return nil;
  //  }
  //  return [[[detailItem valueForKey:@"questions_and_groups"] objectAtIndex:section] objectForKey:@"help_text"];
//  if(section > ((NSInteger)[sectionSubTitles count] -1)) {
//    return nil;
//  } else {
//    return [sectionSubTitles objectAtIndex:section];
//  }
  
}
#pragma mark - Calculate dependencies


#pragma mark - Show and hide dependencies


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
    if ([[self responsesForIndexPath:anIndexPath] lastObject]) {
      [self deleteResponseForIndexPath:anIndexPath];
      [aTableView cellForRowAtIndexPath:anIndexPath].imageView.image = [UIImage imageNamed:@"unchecked"];
    } else {
      [self newResponseForIndexPath:anIndexPath];
      [aTableView cellForRowAtIndexPath:anIndexPath].imageView.image = [UIImage imageNamed:@"checked"];
    }
//    [aTableView cellForRowAtIndexPath:anIndexPath].imageView.image = 
//      img == [UIImage imageNamed:@"unchecked"] ? [UIImage imageNamed:@"checked"] : [UIImage imageNamed:@"unchecked"]; 
	} else if ([cell isKindOfClass:NSClassFromString(@"SurveyorOneAnswerCell")]) {
    for (int i = 0; i < [aTableView numberOfRowsInSection:anIndexPath.section]; i++) {
      NSIndexPath *j = [NSIndexPath indexPathForRow:i inSection:anIndexPath.section];
      j == anIndexPath ? [self newResponseForIndexPath:j] : [self deleteResponseForIndexPath:j];
      [aTableView cellForRowAtIndexPath:j].imageView.image = 
        j == anIndexPath ? [UIImage imageNamed:@"dotted"] : [UIImage imageNamed:@"undotted"];
    }
  }
	
	[cell handleSelectionInTableView:aTableView];
}

#pragma mark - UITextFieldDelegate

//
// textFieldDidEndEditing:
//
// Update the rowData for the text field rows to match the edited value of the
// text field.
//
- (void)textFieldDidEndEditing:(UITextField *)aTextField {
  NSIndexPath *idx = [self.tableView indexPathForCell:(UITableViewCell *)aTextField.superview.superview];
  [self deleteResponseForIndexPath:idx];
  if (aTextField.text != nil && ![aTextField.text isEqualToString:@""]) {
    [self newResponseForIndexPath:idx Value:aTextField.text];
  }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)aTextView {
  NSIndexPath *idx = [self.tableView indexPathForCell:(UITableViewCell *)aTextView.superview.superview];
  [self deleteResponseForIndexPath:idx];
  if (aTextView.text != nil && ![aTextView.text isEqualToString:@""]) {
    [self newResponseForIndexPath:idx Value:aTextView.text];
  }
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
  bar.leftBarButtonItem = barButtonItem;
  self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  bar.leftBarButtonItem = nil;
  self.popoverController = nil;
}

@end
