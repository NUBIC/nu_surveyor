//
//  NUSectionTVC.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUSectionTVC.h"
#import "UUID.h"
#import "UILabel+NUResize.h"

@interface NUSectionTVC()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
// Table and section headers
- (void)createHeader;
- (UIView  *)headerViewWithTitle:(NSString *)title SubTitle:(NSString *)subTitle;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView subTitleForHeaderInSection:(NSInteger)section;
// Lookup functions
- (NSMutableDictionary *)questionOrGroupWithUUID:(NSString *)uuid;
- (NSUInteger) indexOfQuestionOrGroupWithUUID:(NSString *)uuid;
- (NSDictionary *)idsForIndexPath:(NSIndexPath *)i;
- (NSUInteger) indexForInsert:(NSString *)uuid;
// Detail item
- (void)createRows;- (void)createRows;
@end

@implementation NUSectionTVC
@synthesize pageControl = _pageControl, popController = _popController, detailItem = _detailItem, responseSet = _responseSet, visibleSections = _visibleSections, allSections = _allSections, visibleHeaders = _visibleHeaders, delegate = _delegate;

#pragma mark - Utility class methods
+ (NSString *) classNameForQuestion:(NSDictionary *)questionOrGroup answer:(NSDictionary *)answer {
  NSString *className;
  if ([(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
    className = [(NSString *)[answer objectForKey:@"pick"] isEqualToString:@"one"] ? 
    @"NUGridOneCell" : @"NUGridAnyCell";
  }else if ([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"one"]) {
    className = [(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"slider"] ? 
    @"NUPickerCell" : @"NUOneCell";
    
  } else if([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"any"]){
    className = @"NUAnyCell";
  } else {
    className = @"NUNoneCell";
    if ([[answer objectForKey:@"type"] isEqualToString:@"date"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"time"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"datetime"] ) {
      className = @"NUDatePickerCell";
    }
    if ([[answer objectForKey:@"type"] isEqualToString:@"text"]) {
      className = @"NUNoneTextCell";
    }
  }
	return className;
//  return [NSClassFromString(className) class];
}

#pragma mark - Memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(130.0, 0.0, 442.0, 36.0)];
  [self.navigationController.view addSubview:self.pageControl];

  // Swipe gesture recognizers
  UISwipeGestureRecognizer *r = [[UISwipeGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(prevSection)];
  r.direction = UISwipeGestureRecognizerDirectionRight;      
  UISwipeGestureRecognizer *l = [[UISwipeGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(nextSection)];
  l.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:r];
  [self.view addGestureRecognizer:l];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES; // Any orientation
}

#pragma mark - Detail item
- (void)setDetailItem:(id)detailItem {
  if (detailItem != _detailItem) {
    _detailItem = detailItem;
    [self createRows];
  }
  if (self.popController != nil) {
    [self.popController dismissPopoverAnimated:YES];
  }
}

- (void)createRows
{ 
  
  [self createHeader];
  self.visibleHeaders = nil;
  self.allSections = nil;
  self.visibleSections = nil;
	
  
  // generate a full listing of all questions, including labels, 
  //   hidden questions, dependent questions, as well as separate 
  //   sections for group titles and their grouped questions, etc.
  self.allSections = [[NSMutableArray alloc] init];
  for(NSDictionary *questionOrGroup in [self.detailItem objectForKey:@"questions_and_groups"]){
    // regular questions, grids
    [self.allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
																 [questionOrGroup objectForKey:@"uuid"] == nil ? [UUID generateUuidString] : [questionOrGroup objectForKey:@"uuid"], @"uuid",
																 questionOrGroup, @"question",
																 (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[questionOrGroup objectForKey:@"dependency"]]) ? NS_YES : NS_NO, @"show", nil ]];
		//    DLog(@"uuid: %@ questionOrGroup: %@", [questionOrGroup objectForKey:@"uuid"], questionOrGroup);
    
    if (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
      // inline, repeaters
      for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
        [self.allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
																		 [question objectForKey:@"uuid"], @"uuid",
																		 question, @"question",
																		 (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[question objectForKey:@"dependency"]]) ? NS_YES : NS_NO, @"show", nil ]];
      }
    }
  }
	//  DLog(@"all sections: %@", allSections);
	
  // generate a listing of the visible questions
  self.visibleSections = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *questionOrGroup in self.allSections) {
		//    DLog(@"show: %@, question: %@, uuid: %@", [questionOrGroup objectForKey:@"show"], [[questionOrGroup objectForKey:@"question"] objectForKey:@"text"], [questionOrGroup objectForKey:@"uuid"] );
    if ([questionOrGroup objectForKey:@"show"] == NS_YES) {
      [self.visibleSections addObject:[questionOrGroup objectForKey:@"uuid"]];
      //      [self createQuestionWithIndex:self.visibleSections.count dictionary:[questionOrGroup objectForKey:@"question"]];
    }
  }
	//  DLog(@"visible sections: %@", visibleSections);
	
	//	[self hideLoadingIndicator];
	[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return self.visibleSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	NSDictionary *question = [self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:section]];
	if ([(NSString *)[question objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[question objectForKey:@"type"] isEqualToString:@"slider"]) {
		return 1;
	} else if([(NSString *)[question objectForKey:@"type"] isEqualToString:@"grid"]) { 
    return [(NSArray *)[question objectForKey:@"questions"] count];
  } else {
		return [(NSArray *)[question objectForKey:@"answers"] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *question = [self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:indexPath.section]];
  NSString *CellIdentifier = [self.class classNameForQuestion:question answer:[[question objectForKey:([(NSString *)[question objectForKey:@"type"] isEqualToString:@"grid"] ? @"questions" : @"answers")] objectAtIndex:indexPath.row]];
    
	UITableViewCell<NUCell> *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
			cell = [(UITableViewCell<NUCell> *)[NSClassFromString(CellIdentifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if ([(NSString *)[question objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[question objectForKey:@"type"] isEqualToString:@"slider"]) {
		[cell configureForData:[question objectForKey:@"answers"] tableView:tableView indexPath:indexPath];
	} else if([(NSString *)[question objectForKey:@"type"] isEqualToString:@"grid"]) {
    [cell configureForData:[[question objectForKey:@"questions"] objectAtIndex:indexPath.row] tableView:tableView indexPath:indexPath];
  } else {
		[cell configureForData:[(NSArray *)[question objectForKey:@"answers"] objectAtIndex:indexPath.row] tableView:tableView indexPath:indexPath];
	}
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell<NUCell> *cell = (UITableViewCell<NUCell> *)[tableView cellForRowAtIndexPath:indexPath];
	[cell selectedinTableView:tableView indexPath:indexPath];
	[self showAndHideDependenciesTriggeredBy:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSString *title = [self tableView:tableView titleForHeaderInSection:section];
  NSString *subTitle = [self tableView:tableView subTitleForHeaderInSection:section];
	if ([title length] == 0 && [subTitle length] == 0){
		return nil;
	}else {
		return [self headerViewWithTitle:title SubTitle:subTitle];
	}
//  
//	if ([self.visibleHeaders count] != [tableSections count])
//	{
//		if (!self.visibleHeaders)
//		{
//			self.visibleHeaders = [[NSMutableArray alloc] initWithCapacity:[tableSections count]];
//		}
//		
//		while ([visibleHeaders count] <= section){
//      [self.visibleHeaders addObject:[self headerViewWithTitle:title SubTitle:subTitle]];
//    }
//  }
//	return [self.visibleHeaders objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	NSString *title = [self tableView:tableView titleForHeaderInSection:section];
  NSString *subTitle = [self tableView:tableView subTitleForHeaderInSection:section];
	if ([title length] == 0 && [subTitle length] == 0)
	{
		return 0;
	}
	
	return
  [[self tableView:tableView viewForHeaderInSection:section] bounds].size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//  NSDictionary *question = [self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:indexPath.section]];
//	NSString *CellIdentifier = [self.class classNameForQuestion:question answer:[[question objectForKey:@"answers"] objectAtIndex:indexPath.row]];
//  return [CellIdentifier isEqualToString:@"NUNoneTextCell"] ? 220.0 : 44.0;
  return 44.0;
}

#pragma mark - Table and section headers (private)
- (void)createHeader{
  // Section title
  BOOL isGrouped = self.tableView.style == UITableViewStyleGrouped;
  const CGFloat HorizontalMargin = isGrouped ? 20.0 : 5.0;
  const CGFloat VerticalMargin = 10.0;
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
  UILabel *section_title = [[UILabel alloc] initWithFrame:CGRectMake(HorizontalMargin, VerticalMargin, self.tableView.bounds.size.width - (2 * HorizontalMargin), 22.0)];
  section_title.text = [self.detailItem valueForKey:@"title"];
  [section_title setUpMultiLineVerticalResizeWithFontSize:22.0];
  section_title.backgroundColor = isGrouped ?
  [UIColor clearColor] :
  [UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
  headerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, section_title.frame.size.height + (2 * VerticalMargin));
  [headerView addSubview:section_title];
  self.tableView.tableHeaderView = headerView;  
}
- (UIView  *)headerViewWithTitle:(NSString *)title SubTitle:(NSString *)subTitle {
  
  BOOL isGrouped = self.tableView.style == UITableViewStyleGrouped;
  
  const CGFloat PageViewSectionGroupHeaderHeight = 36;
  const CGFloat PageViewSectionPlainHeaderHeight = 22;
  const CGFloat PageViewSectionGroupHeaderMargin = 20;
  const CGFloat PageViewSectionPlainHeaderMargin = 5;
  const CGFloat BottomMargin = 5;
  CGFloat y = 0.0;
  
  CGRect frame = CGRectMake(0, 0, self.tableView.bounds.size.width,
                            isGrouped ? PageViewSectionGroupHeaderHeight : PageViewSectionPlainHeaderHeight);
  
  UIView *headerView = [[UIView alloc] initWithFrame:frame];
  headerView.backgroundColor =
  isGrouped ?
  [UIColor clearColor] :
  [UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
  
  frame.origin.x = isGrouped ?
  PageViewSectionGroupHeaderMargin : PageViewSectionPlainHeaderMargin;
  frame.size.width -= 2.0 * frame.origin.x;
  
  if ([title length] > 0) {
    // Title label wraps and expands height to fit
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, y, frame.size.width, 10.0)];
    label.text = title;
    [label setUpMultiLineVerticalResizeWithFontSize:([UIFont labelFontSize] + (isGrouped ? 0 : 1))];
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
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, y, frame.size.width, 10.0)];
    subTitleLabel.text = subTitle;
    [subTitleLabel setUpMultiLineVerticalResizeWithFontSize:([UIFont labelFontSize] - (isGrouped ? 3 : 2))];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{ 
  if (section >= self.visibleSections.count) {
    return nil;
  } else {
		//    DLog(@"%@", [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"text"]);
    return [[self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:section]] objectForKey:@"text"];
  }
}
- (NSString *)tableView:(UITableView *)tableView subTitleForHeaderInSection:(NSInteger)section{ 
  if (section >= self.visibleSections.count) {
    return nil;
  } else {
		//    DLog(@"%@", [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"help_text"]);
    return [[self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:section]] objectForKey:@"help_text"];
  }
}

#pragma mark - Lookup functions (private)
- (NSMutableDictionary *)questionOrGroupWithUUID:(NSString *)uuid{
  return [[self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:uuid]] objectForKey:@"question"];
}
- (NSUInteger)indexOfQuestionOrGroupWithUUID:(NSString *)uuid{
  // block syntax
  // ^int (int x) { return x*3; }
  NSUInteger i = [self.allSections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ 
    if ([[obj objectForKey:@"uuid"] isEqualToString:uuid]) {
      return YES;
    }
    return NO;
  }];
  return i;
}
- (NSDictionary *)idsForIndexPath:(NSIndexPath *)i{
  if ([i indexAtPosition:0] > self.visibleSections.count) {
    return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"qid", nil, @"aid", nil];
  }
  NSDictionary *qOrG = [self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:[i indexAtPosition:0]]];
  if ([[qOrG objectForKey:@"type"] isEqualToString:@"grid"]) {
    if ([i indexAtPosition:0] < [self.visibleSections count] && [i indexAtPosition:1] < [[qOrG objectForKey:@"questions"] count] && [i indexAtPosition:2] < [[[[qOrG objectForKey:@"questions"] objectAtIndex:[i indexAtPosition:1]] objectForKey:@"answers"] count]) {
      NSDictionary *q = [[qOrG objectForKey:@"questions"] objectAtIndex:[i indexAtPosition:1]];
      NSString *qid = [q objectForKey:@"uuid"];
      NSString *aid = [[[q objectForKey:@"answers"] objectAtIndex:[i indexAtPosition:2]] objectForKey:@"uuid"];
      //  DLog(@"i: %@ section: %d row: %d qid: %@ aid: %@", i, i.section, i.row, qid, aid);
      return [NSDictionary dictionaryWithObjectsAndKeys:qid, @"qid", aid, @"aid", nil];
    }else{
      // this happens when the tableview is refreshed
      // and self.tableView deleteSections is called
      return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"qid", nil, @"aid", nil];
    }
  } else {
    if (i.section < [self.visibleSections count] && i.row < [[qOrG objectForKey:@"answers"] count]) {
      NSString *qid = [self.visibleSections objectAtIndex:i.section];
      NSString *aid = [[[qOrG objectForKey:@"answers"] objectAtIndex:i.row] objectForKey:@"uuid"];
      //  DLog(@"i: %@ section: %d row: %d qid: %@ aid: %@", i, i.section, i.row, qid, aid);
      return [NSDictionary dictionaryWithObjectsAndKeys:qid, @"qid", aid, @"aid", nil];
    }else{
      // this happens when the tableview is refreshed
      // and self.tableView deleteSections is called
      return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"qid", nil, @"aid", nil];
    }
  }
}
- (NSUInteger) indexForInsert:(NSString *)uuid {
  NSUInteger i = [self indexOfQuestionOrGroupWithUUID:uuid];
	//  DLog(@"i: %d", i);
  for (int n = i-1; n >= 0; n--) {
		//    DLog(@"n: %d", n);
    if ([[self.allSections objectAtIndex:n] objectForKey:@"show"] == NS_YES) {
      return [self.visibleSections indexOfObject:[[self.allSections objectAtIndex:n] objectForKey:@"uuid"]] + 1;
    }
  }
  return 0;
}

#pragma mark - Core Data
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

#pragma mark - Dependencies
- (void) showAndHideDependenciesTriggeredBy:(NSIndexPath *)idx {
	//  DLog(@"showAndHideDependenciesTriggeredBy: %@", idx);
  NSDictionary *showHide = [self.responseSet dependenciesTriggeredBy:[[self idsForIndexPath:idx] objectForKey:@"qid"]];
	//  DLog(@"showHide: %@", showHide);
  for (NSString *question in [showHide objectForKey:@"show"]) {
    // show the question and insert it in the right place
    if ([self.visibleSections indexOfObject:question] == NSNotFound) {
      NSUInteger i = [self indexForInsert:question];
      [[self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:question]] setObject:NS_YES forKey:@"show"];
      // insert into visibleSections before createQuestionWithIndex to get title right
      [self.visibleSections insertObject:[[self questionOrGroupWithUUID:question] objectForKey:@"uuid"] atIndex:i];
			
      [self.visibleHeaders insertObject:[self headerViewWithTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"text"] SubTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"help_text"]] atIndex:i];
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
//      [self createQuestionWithIndex:i dictionary:[self questionOrGroupWithUUID:question]];
    }
  } 
  for (NSString *question in [showHide objectForKey:@"hide"]) {
    // hide the question
    NSUInteger i = [self.visibleSections indexOfObject:question];
    if (i != NSNotFound) {
      [self.visibleHeaders removeObjectAtIndex:i];
//      [self removeSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
      [self.visibleSections removeObjectAtIndex:i];
			//      [self headerSectionsReordered];
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];

    }
  } 	
}

#pragma mark - UITextFieldDelegate
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

#pragma mark - Split view support
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Sections"; //@"Root List";
  self.navigationItem.leftBarButtonItem = barButtonItem;
  self.popController = pc;
}
// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  self.navigationItem.leftBarButtonItem = nil;
  self.popController = nil;
}


@end
