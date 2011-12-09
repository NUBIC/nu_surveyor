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
- (NSUInteger) indexForInsert:(NSString *)uuid;
- (NSUInteger) indexOfQuestionOrGroupWithUUID:(NSString *)uuid;
- (NSMutableDictionary *)questionOrGroupWithUUID:(NSString *)uuid;
- (UIView  *)headerViewWithTitle:(NSString *)title SubTitle:(NSString *)subTitle;
@end

@implementation NUSectionVC
@synthesize bar, pageControl, popoverController, detailItem, responseSet, visibleSections, allSections, visibleHeaders;

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
  [visibleSections release];
  [allSections release];
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
    NSString *qid = [visibleSections objectAtIndex:i.section];
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
  
  [self createHeader];
  [visibleHeaders release];
  visibleHeaders = nil;
  [allSections release];
  allSections = nil;
  [visibleSections release];
  visibleSections = nil;
  
  // generate a full listing of all questions, including labels, 
  //   hidden questions, dependent questions, as well as separate 
  //   sections for group titles and their grouped questions, etc.
  self.allSections = [[NSMutableArray alloc] init];
  for(NSDictionary *questionOrGroup in [detailItem objectForKey:@"questions_and_groups"]){
    // regular questions, grids
    [allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [questionOrGroup objectForKey:@"uuid"] == nil ? [UUID generateUuidString] : [questionOrGroup objectForKey:@"uuid"], @"uuid",
                            questionOrGroup, @"question",
                            (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && [responseSet showDependency:[questionOrGroup objectForKey:@"dependency"]]) ? NS_YES : NS_NO, @"show", nil ]];
//    DLog(@"uuid: %@ questionOrGroup: %@", [questionOrGroup objectForKey:@"uuid"], questionOrGroup);
    
    if (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
      // inline, repeaters
      for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
        [allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [question objectForKey:@"uuid"], @"uuid",
                                question, @"question",
                                (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && [responseSet showDependency:[question objectForKey:@"dependency"]]) ? NS_YES : NS_NO, @"show", nil ]];
      }
    }
  }
//  DLog(@"all sections: %@", allSections);

  // generate a listing of the visible questions
  self.visibleSections = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *questionOrGroup in allSections) {
//    DLog(@"show: %@, question: %@, uuid: %@", [questionOrGroup objectForKey:@"show"], [[questionOrGroup objectForKey:@"question"] objectForKey:@"text"], [questionOrGroup objectForKey:@"uuid"] );
    if ([questionOrGroup objectForKey:@"show"] == NS_YES) {
      [visibleSections addObject:[questionOrGroup objectForKey:@"uuid"]];
      [self createQuestionWithIndex:visibleSections.count dictionary:[questionOrGroup objectForKey:@"question"]];
    }
  }
//  DLog(@"visible sections: %@", visibleSections);

	[self hideLoadingIndicator];
}
- (void) createQuestionWithIndex:(NSInteger)i dictionary:(NSDictionary *)question {
//  DLog(@"createQuestionWithIndex: %d dictionary: %@", i, question);
  [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];

  if ([(NSString *)[question objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[question objectForKey:@"type"] isEqualToString:@"slider"]){
    [self
     appendRowToSection:i
     cellClass: [NSClassFromString(@"SurveyorPickerAnswerCell") class]
     cellData: [question objectForKey:@"answers"]
     withAnimation: UITableViewRowAnimationFade];
  } else {
    for (NSDictionary *answer in [question objectForKey:@"answers"]){
//      DLog(@"answer");
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
  return [[allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:uuid]] objectForKey:@"question"];
}
- (NSUInteger)indexOfQuestionOrGroupWithUUID:(NSString *)uuid{
  // block syntax
  // ^int (int x) { return x*3; }
  NSUInteger i = [allSections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ 
    if ([[obj objectForKey:@"uuid"] isEqualToString:uuid]) {
      return YES;
    }
    return NO;
  }];
  return i;
}

//
// tableView:viewForHeaderInSection:
//
// Sets the heading for a section
//
// Parameters:
//    aTableView - the table view
//    aSection - the section
//
// returns the heading text
//
- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
	NSString *title = [self tableView:aTableView titleForHeaderInSection:section];
  NSString *subTitle = [self tableView:aTableView subTitleForHeaderInSection:section];
	if ([title length] == 0 && [subTitle length] == 0)
	{
		return nil;
	}
  
	if ([visibleHeaders count] != [tableSections count])
	{
		if (!visibleHeaders)
		{
			visibleHeaders = [[NSMutableArray alloc] initWithCapacity:[tableSections count]];
		}
		
		while ([visibleHeaders count] <= section){
      [visibleHeaders addObject:[self headerViewWithTitle:title SubTitle:subTitle]];
    }
  }
	return [visibleHeaders objectAtIndex:section];
}
//
// tableView:heightForHeaderInSection:
//
// Sets the height of the section
//
// Parameters:
//    tableView - the tableView
//    section - the section
//
// returns STMTableSectionHeaderHeight
//
- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section
{
	NSString *title = [self tableView:aTableView titleForHeaderInSection:section];
  NSString *subTitle = [self tableView:aTableView subTitleForHeaderInSection:section];
	if ([title length] == 0 && [subTitle length] == 0)
	{
		return 0;
	}
	
	return
  [[self tableView:aTableView viewForHeaderInSection:section] bounds].size.height;
}
- (UIView  *)headerViewWithTitle:(NSString *)title SubTitle:(NSString *)subTitle {
  
  BOOL isGrouped = tableView.style == UITableViewStyleGrouped;
  
  const CGFloat PageViewSectionGroupHeaderHeight = 36;
  const CGFloat PageViewSectionPlainHeaderHeight = 22;
  const CGFloat PageViewSectionGroupHeaderMargin = 20;
  const CGFloat PageViewSectionPlainHeaderMargin = 5;
  const CGFloat BottomMargin = 5;
  CGFloat y = 0.0;
  
  CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width,
                            isGrouped ? PageViewSectionGroupHeaderHeight : PageViewSectionPlainHeaderHeight);
  
  UIView *headerView = [[[UIView alloc] initWithFrame:frame] autorelease];
  headerView.backgroundColor =
  isGrouped ?
  [UIColor clearColor] :
  [UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
  
  frame.origin.x = isGrouped ?
  PageViewSectionGroupHeaderMargin : PageViewSectionPlainHeaderMargin;
  frame.size.width -= 2.0 * frame.origin.x;
  
  if ([title length] > 0) {
    // Title label wraps and expands height to fit
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, y, frame.size.width, 10.0)] autorelease];
    label.text = title;
    [label setUpMultiLineVerticalResizeWithFontSize:[UIFont labelFontSize] + (isGrouped ? 0 : 1)];
    label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + (isGrouped ? 0 : 1)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = isGrouped ?
    [UIColor colorWithRed:0.3 green:0.33 blue:0.43 alpha:1.0] :
    [UIColor whiteColor];
    label.shadowColor = isGrouped ? [UIColor whiteColor] : [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0, 1.0);
    
    //        label.lineBreakMode = UILineBreakModeMiddleTruncation;
    //        label.adjustsFontSizeToFitWidth = YES;
    //        label.minimumFontSize = 12.0;
    [headerView addSubview:label];
    y += label.frame.size.height + BottomMargin;
  }
  if ([subTitle length] > 0) {
    // Subtitle label wraps and expands height to fit
    UILabel *subTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, y, frame.size.width, 10.0)] autorelease];
    subTitleLabel.text = subTitle;
    [subTitleLabel setUpMultiLineVerticalResizeWithFontSize:[UIFont labelFontSize] - (isGrouped ? 3 : 2)];
    subTitleLabel.font = [UIFont italicSystemFontOfSize:[UIFont labelFontSize] - (isGrouped ? 3 : 2)];
    
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = isGrouped ?
    [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0] :
    [UIColor whiteColor];
    subTitleLabel.shadowColor = isGrouped ? [UIColor whiteColor] : [UIColor darkGrayColor];
    subTitleLabel.shadowOffset = CGSizeMake(0, 1.0);
    
    //        subTitleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    //        subTitleLabel.adjustsFontSizeToFitWidth = YES;
    //        subTitleLabel.minimumFontSize = 12.0;
    [headerView addSubview:subTitleLabel];
    y += subTitleLabel.frame.size.height + BottomMargin;
  }
  frame.size.height = y;
  headerView.frame = frame;
//  DLog(@"height: %f", y);
  return headerView;
}

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
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{ 
  if (section >= visibleSections.count) {
    return nil;
  } else {
//    DLog(@"%@", [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"text"]);
    return [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"text"];
  }
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
//    DLog(@"%@", [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"help_text"]);
    return [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"help_text"];
  }
}
#pragma mark - Show and hide dependencies
- (void) showAndHideDependenciesTriggeredBy:(NSIndexPath *)idx {
//  DLog(@"showAndHideDependenciesTriggeredBy: %@", idx);
  NSDictionary *showHide = [responseSet dependenciesTriggeredBy:[[self idsForIndexPath:idx] objectForKey:@"qid"]];
//  DLog(@"showHide: %@", showHide);
  for (NSString *question in [showHide objectForKey:@"show"]) {
    // show the question and insert it in the right place
    if ([visibleSections indexOfObject:question] == NSNotFound) {
      NSUInteger i = [self indexForInsert:question];
      [[allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:question]] setObject:NS_YES forKey:@"show"];
      // insert into visibleSections before createQuestionWithIndex to get title right
      [visibleSections insertObject:[[self questionOrGroupWithUUID:question] objectForKey:@"uuid"] atIndex:i];

      [visibleHeaders insertObject:[self headerViewWithTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"text"] SubTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"help_text"]] atIndex:i];
      [self createQuestionWithIndex:i dictionary:[self questionOrGroupWithUUID:question]];
    }
  } 
  for (NSString *question in [showHide objectForKey:@"hide"]) {
    // hide the question
    NSUInteger i = [visibleSections indexOfObject:question];
    if (i != NSNotFound) {
      [visibleHeaders removeObjectAtIndex:i];
      [self removeSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
      [visibleSections removeObjectAtIndex:i];
//      [self headerSectionsReordered];
    }
  } 

}
- (NSUInteger) indexForInsert:(NSString *)uuid {
  NSUInteger i = [self indexOfQuestionOrGroupWithUUID:uuid];
//  DLog(@"i: %d", i);
  for (int n = i-1; n >= 0; n--) {
//    DLog(@"n: %d", n);
    if ([[allSections objectAtIndex:n] objectForKey:@"show"] == NS_YES) {
      return [visibleSections indexOfObject:[[allSections objectAtIndex:n] objectForKey:@"uuid"]] + 1;
    }
  }
  return 0;
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
    if ([[self responsesForIndexPath:anIndexPath] lastObject]) {
      [self deleteResponseForIndexPath:anIndexPath];
      [[aTableView cellForRowAtIndexPath:anIndexPath] performSelector:@selector(uncheck)];
    } else {
      [self newResponseForIndexPath:anIndexPath];
      [[aTableView cellForRowAtIndexPath:anIndexPath] performSelector:@selector(check)];
    }
    [self showAndHideDependenciesTriggeredBy:anIndexPath];
	} else if ([cell isKindOfClass:NSClassFromString(@"SurveyorOneAnswerCell")]) {
    for (int i = 0; i < [aTableView numberOfRowsInSection:anIndexPath.section]; i++) {
      NSIndexPath *j = [NSIndexPath indexPathForRow:i inSection:anIndexPath.section];
      [j isEqual:anIndexPath] ? [self newResponseForIndexPath:j] : [self deleteResponseForIndexPath:j];
      [[aTableView cellForRowAtIndexPath:j] performSelector: [j isEqual:anIndexPath] ? @selector(dot) : @selector(undot)];
    }
    [self showAndHideDependenciesTriggeredBy:anIndexPath];
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
  [self showAndHideDependenciesTriggeredBy:idx];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)aTextView {
  NSIndexPath *idx = [self.tableView indexPathForCell:(UITableViewCell *)aTextView.superview.superview];
  [self deleteResponseForIndexPath:idx];
  if (aTextView.text != nil && ![aTextView.text isEqualToString:@""]) {
    [self newResponseForIndexPath:idx Value:aTextView.text];
  }
  [self showAndHideDependenciesTriggeredBy:idx];
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
