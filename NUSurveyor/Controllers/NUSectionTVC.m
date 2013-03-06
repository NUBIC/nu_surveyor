//
//  NUSectionTVC.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUSectionTVC.h"
#import "NUUUID.h"
#import "UILabel+NUResize.h"
#import "NUButton.h"
#import "NSString+NUAdditions.h"
#import "NUCell.h"

@interface VisibleSection : NSObject {
    NSString* _uuid;
    NSNumber* _rgid;
    NSString* _groupUUID;
}
@property(nonatomic,retain)NSString* uuid;
@property(nonatomic,retain)NSNumber* rgid;
@property(nonatomic,retain)NSString* groupUUID;

-(void)deselectOtherNonExclusiveCellsInSectionOfIndex:(NSIndexPath *)idx;

@end

@implementation VisibleSection

@synthesize uuid = _uuid;
@synthesize rgid = _rgid;
@synthesize groupUUID = _groupUUID;

- (id)initWithUUID:(NSString*)uuid rgid:(NSNumber*)rgid groupUUID:(NSString*)groupUUID {
    self = [super init];
    if (self) {
        _uuid = uuid;
        _rgid = rgid;
        _groupUUID = groupUUID;
    }
    return self;
}

@end

@interface NUSectionTVC()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) UIView *cursorView;
@property (nonatomic, retain) NSIndexPath *cursorIndex;
// Table and section headers
- (void)createHeader;
- (void)createFooter;
- (UIView  *)headerViewWithTitle:(NSString *)title SubTitle:(NSString *)subTitle;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView subTitleForHeaderInSection:(NSInteger)section;
// Lookup functions
- (NSMutableDictionary *)questionOrGroupWithUUID:(NSString *)uuid;
- (NSUInteger) indexOfQuestionOrGroupWithUUID:(NSString *)uuid;
- (NSDictionary *)idsForIndexPath:(NSIndexPath *)i;
- (NSUInteger) indexForInsert:(NSString *)uuid;
- (VisibleSection*)findVisibleSectionWithUUID:(NSString*)uuid;
- (NSArray*)findAllVisibleSectionsWithUUID:(NSString*)uuid;
// Detail item
- (void)createRows;
- (BOOL)isLastSectionInRepeaterGroup:(NSInteger)section;
- (NSArray*)findVisibleSectionsWithGroupUUID:(NSString*)uuid;
@end

@implementation NUSectionTVC
@synthesize cursorView = _cursorView, cursorIndex = _cursorIndex;
@synthesize pageControl = _pageControl, popController = _popController, detailItem = _detailItem, responseSet = _responseSet, visibleSections = _visibleSections, allSections = _allSections, visibleHeaders = _visibleHeaders, prevSectionTitle = _prevSectionTitle, nextSectionTitle = _nextSectionTitle, delegate = _delegate, renderContext = _renderContext;

#pragma mark - Utility class methods
+ (NSString *) classNameForQuestion:(NSDictionary *)questionOrGroup answer:(NSDictionary *)answer {
  NSString *className;
  if ([(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
    className = [(NSString *)[answer objectForKey:@"pick"] isEqualToString:@"one"] ? 
    @"NUGridOneCell" : @"NUGridAnyCell";
  }else if ([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"one"]) {
    if([(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"dropdown"] || [(NSString *)[questionOrGroup objectForKey:@"type"] isEqualToString:@"slider"]){
      className = @"NUPickerCell";
    } else {
      className = @"NUOneCell";
      if ([[answer objectForKey:@"type"] isEqualToString:@"string"] ||
          [[answer objectForKey:@"type"] isEqualToString:@"integer"] ||
          [[answer objectForKey:@"type"] isEqualToString:@"float"] ) {
        className = @"NUOneStringOrNumberCell";
      } else if ([[answer objectForKey:@"type"] isEqualToString:@"date"] ||
                 [[answer objectForKey:@"type"] isEqualToString:@"time"] ||
                 [[answer objectForKey:@"type"] isEqualToString:@"datetime"] ) {
        className = @"NUOneDatePickerCell";
      }
    }
  } else if([(NSString *)[questionOrGroup objectForKey:@"pick"] isEqualToString:@"any"]){
    className = @"NUAnyCell";
    if ([[answer objectForKey:@"type"] isEqualToString:@"string"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"integer"] ||
        [[answer objectForKey:@"type"] isEqualToString:@"float"] ) {
      className = @"NUAnyStringOrNumberCell";
    } else if ([[answer objectForKey:@"type"] isEqualToString:@"date"] ||
               [[answer objectForKey:@"type"] isEqualToString:@"time"] ||
               [[answer objectForKey:@"type"] isEqualToString:@"datetime"] ) {
      className = @"NUAnyDatePickerCell";
    }

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
			self.pageControl = [[UIPageControl alloc] init];
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
  self.pageControl.frame = CGRectMake(0.0, 19.0, self.view.frame.size.width, 36.0);
	self.pageControl.userInteractionEnabled = NO;
	[self.navigationController.view addSubview:self.pageControl];
  self.tableView.accessibilityLabel = @"sectionTableView";
	
  // Swipe gesture recognizers
  // A left to right swipe is now used to bring up the master table view, so these conflict.
  //  UISwipeGestureRecognizer *r = [[UISwipeGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(prevSection)];
  //  r.direction = UISwipeGestureRecognizerDirectionRight;      
  //  UISwipeGestureRecognizer *l = [[UISwipeGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(nextSection)];
  //  l.direction = UISwipeGestureRecognizerDirectionLeft;
  //  [self.view addGestureRecognizer:r];
  //  [self.view addGestureRecognizer:l];
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
  [self createFooter];
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
                                [questionOrGroup objectForKey:@"uuid"] == nil ? [NUUUID generateUuidString] : [questionOrGroup objectForKey:@"uuid"], @"uuid",
                                 questionOrGroup, @"question",
                                 (![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[questionOrGroup objectForKey:@"dependency"]]) ? NS_YES : NS_NO, @"show", nil ]];
    //    DLog(@"uuid: %@ questionOrGroup: %@", [questionOrGroup objectForKey:@"uuid"], questionOrGroup);
    
    NSString* type = [questionOrGroup objectForKey:@"type"];
    if (![type isEqualToString:@"grid"]) {
        if ([type isEqualToString:@"repeater"]) {
            NSMutableArray* groupQuestionIds = [NSMutableArray new];
            for (NSDictionary* q in [questionOrGroup objectForKey:@"questions"]) {
                [groupQuestionIds addObject:[q objectForKey:@"uuid"]];
            }
            
            NSInteger count = [self.responseSet countGroupResponsesForQuestionIds:groupQuestionIds] + 1; // +1 for new section
            for (int i=0; i < count; i++) {
                for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
                    // repeaters
                    NSNumber* show = ((![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && ![[question objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[questionOrGroup objectForKey:@"dependency"]] && [self.responseSet showDependency:[question objectForKey:@"dependency"]]) ? NS_YES : NS_NO);
                    [self.allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [question objectForKey:@"uuid"], @"uuid",
                                                 question, @"question",
                                                 [NSNumber numberWithInt:i], @"rgid",
                                                 [questionOrGroup objectForKey:@"uuid"], @"groupUUID",
                                                 show, @"show", nil]];

                }                    
            }
        } else {
            for (NSDictionary *question in [questionOrGroup objectForKey:@"questions"]) {
                // inline
                [self.allSections addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [question objectForKey:@"uuid"], @"uuid",
                                      question, @"question",
                                      ((![[questionOrGroup objectForKey:@"type"] isEqualToString:@"hidden"] && ![[question objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[questionOrGroup objectForKey:@"dependency"]] && [self.responseSet showDependency:[question objectForKey:@"dependency"]]) ? NS_YES : NS_NO), @"show", nil]];
            }
        }
    }
  }
	//  DLog(@"all sections: %@", allSections);
	
  // generate a listing of the visible questions
  self.visibleSections = [[NSMutableArray alloc] init];
  for (NSMutableDictionary *questionOrGroup in self.allSections) {
		//    DLog(@"show: %@, question: %@, uuid: %@", [questionOrGroup objectForKey:@"show"], [[questionOrGroup objectForKey:@"question"] objectForKey:@"text"], [questionOrGroup objectForKey:@"uuid"] );
    if ([questionOrGroup objectForKey:@"show"] == NS_YES) {
      NSString* uuid = [questionOrGroup objectForKey:@"uuid"];
      NSNumber* rgid = [questionOrGroup objectForKey:@"rgid"];
      NSString* groupUUID = [questionOrGroup objectForKey:@"groupUUID"];
      VisibleSection* v = [[VisibleSection alloc] initWithUUID:uuid rgid:rgid groupUUID:groupUUID];
      [self.visibleSections addObject:v];
    }
  }
	//  DLog(@"visible sections: %@", visibleSections);
	
	//	[self hideLoadingIndicator];
	[self.tableView reloadData];
}

- (NSString*) visibleSectionUUIDForSection:(NSInteger)section {
    VisibleSection* v = [self.visibleSections objectAtIndex:section];
    return v.uuid;
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
	NSDictionary *question = [self questionOrGroupWithUUID:[self visibleSectionUUIDForSection:section]];
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
	NSDictionary *question = [self questionOrGroupWithUUID:[self visibleSectionUUIDForSection:indexPath.section]];
  NSString *CellIdentifier = [self.class classNameForQuestion:question answer:[[question objectForKey:([(NSString *)[question objectForKey:@"type"] isEqualToString:@"grid"] ? @"questions" : @"answers")] objectAtIndex:indexPath.row]];
    
	UITableViewCell<NUCell> *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
    if ([CellIdentifier isEqualToString:@"NUAnyDatePickerCell"] || [CellIdentifier isEqualToString:@"NUOneDatePickerCell"]) {
      cell = [(UITableViewCell<NUCell> *)[NSClassFromString(CellIdentifier) alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    } else {
      cell = [(UITableViewCell<NUCell> *)[NSClassFromString(CellIdentifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
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
    [self deselectOtherNonExclusiveCellsInSectionOfIndex:indexPath];
  if (self.cursorView && ![self.cursorView isDescendantOfView:cell]) {
    [self.cursorView resignFirstResponder];
    self.cursorView = nil;
  }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    CGFloat height = 44.0f;
    
    NSDictionary *questionOrGroup = [self questionOrGroupWithUUID:[self visibleSectionUUIDForSection:indexPath.section]];

    NSDictionary* question = nil;
    NSString* CellIdentifier = nil;
    if ([[questionOrGroup objectForKey:@"type"] isEqualToString:@"grid"]) {
        // Grid questions is within a section and each question has its own row
        question = [questionOrGroup objectForKey:@"questions"][indexPath.row];
        CellIdentifier = [self.class classNameForQuestion:questionOrGroup answer:question];
    } else {
        question = questionOrGroup;
        CellIdentifier = [self.class classNameForQuestion:questionOrGroup answer:[[questionOrGroup objectForKey:@"answers"] objectAtIndex:indexPath.row]];
    }

    id cell = NSClassFromString(CellIdentifier);
    if ([cell respondsToSelector:@selector(cellHeightForQuestion:contentWidth:)]) {
        CGFloat calculatedHeight = [cell cellHeightForQuestion:question contentWidth:self.tableView.frame.size.width];
        height = MAX(calculatedHeight, height);
    }
    
    return height;
     
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL isGrouped = self.tableView.style == UITableViewStyleGrouped;
    const CGFloat HorizontalMargin = isGrouped ? 45.0 : 30.0;
    CGFloat height = 32.0;
    UIView* v = NULL;

    if ([self isLastSectionInRepeaterGroup:section]) {
        v = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, height)];
        
        NUButton *addRowButton = [[NUButton alloc] initWithFrame:CGRectMake(HorizontalMargin, 0, 100.0, height)];
        [addRowButton setTitle:@"+ add row" forState:UIControlStateNormal];
        [addRowButton addTarget:self action:@selector(addRow) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:addRowButton];
    }
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self isLastSectionInRepeaterGroup:section] ? 35 : 0;
}

- (BOOL)isLastSectionInRepeaterGroup:(NSInteger)section {
    BOOL result = false;
    VisibleSection* cur = [self.visibleSections objectAtIndex:section];
    if (cur.rgid) {
        NSArray* group = [self findVisibleSectionsWithGroupUUID:cur.groupUUID];
        if ([cur isEqual:[group lastObject]]) {
            result = true;
        }
    }
    return result;
}

- (void)addRow {
    [self createRows];
}


#pragma mark - Table and section headers (private)
- (void)createHeader{
  // Section title
  BOOL isGrouped = self.tableView.style == UITableViewStyleGrouped;
  const CGFloat HorizontalMargin = isGrouped ? 20.0 : 5.0;
  const CGFloat VerticalMargin = 10.0;
  CGFloat y = VerticalMargin;
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
  if (self.prevSectionTitle) {
    CGFloat height = 32.0;
    NUButton *prevSectionButton = [[NUButton alloc] initWithFrame:CGRectMake(HorizontalMargin, y, 100.0, height)];
    [prevSectionButton setTitle:[NSString stringWithFormat:@"Previous: %@", self.prevSectionTitle] forState:UIControlStateNormal];    
    [prevSectionButton addTarget:self.delegate action:@selector(prevSection) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:prevSectionButton];
    y+= height + VerticalMargin;
  }
  UILabel *section_title = [[UILabel alloc] initWithFrame:CGRectMake(HorizontalMargin, y, self.tableView.bounds.size.width - (2 * HorizontalMargin), 22.0)];
  section_title.text = [self.detailItem valueForKey:@"title"];
  [section_title setUpMultiLineVerticalResizeWithFont:[UIFont systemFontOfSize:22.0]];
  section_title.backgroundColor = isGrouped ? [UIColor clearColor] : [UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
  y += section_title.frame.size.height + VerticalMargin;
  headerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, y);
  [headerView addSubview:section_title];
  self.tableView.tableHeaderView = headerView;
}
- (void)createFooter{
  // Section title
  BOOL isGrouped = self.tableView.style == UITableViewStyleGrouped;
  const CGFloat HorizontalMargin = isGrouped ? 20.0 : 5.0;
  const CGFloat VerticalMargin = 10.0;
  CGFloat y = VerticalMargin;
  CGFloat height = 32.0;
  
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
  NUButton *nextSectionOrDoneButton = [[NUButton alloc] initWithFrame:CGRectMake(HorizontalMargin, y, 100.0, height)];
  [nextSectionOrDoneButton setTitle:(self.nextSectionTitle ? [NSString stringWithFormat:@"Next: %@", self.nextSectionTitle] : @"Done") forState:UIControlStateNormal];    
  nextSectionOrDoneButton.frame = CGRectMake(self.tableView.frame.size.width - nextSectionOrDoneButton.frame.size.width - HorizontalMargin, y, nextSectionOrDoneButton.frame.size.width, height);
  [nextSectionOrDoneButton addTarget:self.delegate action:(self.nextSectionTitle ? @selector(nextSection) : @selector(surveyDone)) forControlEvents:UIControlEventTouchUpInside];
  [footerView addSubview:nextSectionOrDoneButton];
  y+= height + VerticalMargin*4;
  footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, y);
  self.tableView.tableFooterView = footerView;
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
    [label setUpMultiLineVerticalResizeWithFont:([UIFont boldSystemFontOfSize:[UIFont labelFontSize] + (isGrouped ? 0 : 1)])];
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
    [subTitleLabel setUpMultiLineVerticalResizeWithFont:([UIFont italicSystemFontOfSize:[UIFont labelFontSize] - (isGrouped ? 3 : 2)])];
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
//    return [[self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:section]] objectForKey:@"text"];
    NSString* text = [[[self questionOrGroupWithUUID:[self visibleSectionUUIDForSection:section]] objectForKey:@"text"] normalizeWhitespace];
    return [self renderMustacheFromString:text];

  }
}
- (NSString *)tableView:(UITableView *)tableView subTitleForHeaderInSection:(NSInteger)section{ 
  if (section >= self.visibleSections.count) {
    return nil;
  } else {
//    DLog(@"%@", [[self questionOrGroupWithUUID:[visibleSections objectAtIndex:section]] objectForKey:@"help_text"]);
//    return [[self questionOrGroupWithUUID:[self.visibleSections objectAtIndex:section]] objectForKey:@"help_text"];
    NSString* helpText = [[[self questionOrGroupWithUUID:[self visibleSectionUUIDForSection:section]] objectForKey:@"help_text"] normalizeWhitespace];
    return [self renderMustacheFromString:helpText];
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
  NSString* uuid = [self visibleSectionUUIDForSection:[i indexAtPosition:0]];
  NSDictionary *qOrG = [self questionOrGroupWithUUID:uuid];
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
      VisibleSection* v = [self.visibleSections objectAtIndex:i.section];
      NSString *qid = v.uuid;
      NSString *aid = [[[qOrG objectForKey:@"answers"] objectAtIndex:i.row] objectForKey:@"uuid"];
      NSNumber *rgid = v.rgid;
      //  DLog(@"i: %@ section: %d row: %d qid: %@ aid: %@", i, i.section, i.row, qid, aid);
      return [NSDictionary dictionaryWithObjectsAndKeys:qid, @"qid", aid, @"aid", rgid, @"rgid", nil];
    }else{
      // this happens when the tableview is refreshed
      // and self.tableView deleteSections is called
      return [NSDictionary dictionaryWithObjectsAndKeys:nil, @"qid", nil, @"aid", nil];
    }
  }
}

- (VisibleSection*)findVisibleSectionWithUUID:(NSString*)uuid {
    NSArray* r = [self findAllVisibleSectionsWithUUID:uuid];
    return [r lastObject];
}

- (NSArray*)findAllVisibleSectionsWithUUID:(NSString*)uuid {
    NSMutableArray* result = [NSMutableArray new];
    for (VisibleSection* v in self.visibleSections) {
        if ([v.uuid isEqualToString:uuid]) {
            [result addObject:v];
        }
    }
    return result;
}

- (NSUInteger) indexOfVisibleQuestionWithUUID:(NSString*)uuid {
    VisibleSection* v = [self findVisibleSectionWithUUID:uuid];
    return (v != nil) ? [self.visibleSections indexOfObject:v] : NSNotFound;
}


- (NSUInteger) indexForInsert:(NSString *)uuid {
    NSUInteger i = [self indexOfQuestionOrGroupWithUUID:uuid];
    if (i != NSNotFound) {
        for (int n = i-1; n >= 0; n--) {
            if ([[self.allSections objectAtIndex:n] objectForKey:@"show"] == NS_YES) {
                NSString* secondUUID = [[self.allSections objectAtIndex:n] objectForKey:@"uuid"];
                NSUInteger returnVal = [self indexOfVisibleQuestionWithUUID:secondUUID];
                if (returnVal != NSNotFound) {
                    return returnVal + 1;
                }
            }
        }
        return 0U;
    }
    else {
        return 0U;
    }
}

- (NSArray*)findVisibleSectionsWithGroupUUID:(NSString*)uuid {
    NSMutableArray* found = [NSMutableArray new];
    for (VisibleSection* s in self.visibleSections) {
        if ([s.groupUUID isEqual:uuid]) {
            [found addObject:s];
        }
    }
    return found;
}

#pragma mark - Core Data
- (NSArray *) responsesForIndexPath:(NSIndexPath *)i{
  NSDictionary *ids = [self idsForIndexPath:i];
  return [self.responseSet responsesForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"] Response:[ids objectForKey:@"rgid"]];
}
- (NSManagedObject *) newResponseForIndexPath:(NSIndexPath *)i Value:(NSString *)value{
  NSDictionary *ids = [self idsForIndexPath:i];
  return (NSManagedObject *) [self.responseSet newResponseForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"] responseGroup:[ids objectForKey:@"rgid"] Value:value];
}
- (NSManagedObject *) newResponseForIndexPath:i {
  return [self newResponseForIndexPath:i Value:nil];
}
- (void) deleteResponseForIndexPath:(NSIndexPath *)i {
  NSDictionary *ids = [self idsForIndexPath:i];
  [self.responseSet deleteResponseForQuestion:[ids objectForKey:@"qid"] Answer:[ids objectForKey:@"aid"] ResponseGroup:[ids objectForKey:@"rgid"]];
}

#pragma mark - Dependencies

// We show first, then hide second, so hide always "wins"
- (void) showAndHideDependenciesTriggeredBy:(NSIndexPath *)idx {
	//  DLog(@"showAndHideDependenciesTriggeredBy: %@", idx);
  NSDictionary *showHide = [self.responseSet dependenciesTriggeredBy:[[self idsForIndexPath:idx] objectForKey:@"qid"]];
	//  DLog(@"showHide: %@", showHide);
  for (NSString *question in [showHide objectForKey:@"show"]) {
    // show the question and insert it in the right place
    if ([self findVisibleSectionWithUUID:question] == nil) {
      NSUInteger i = [self indexForInsert:question];
      if (i != 0U) { // NSUInteger 0 is returned by indexForInsert if nothing is found
        [[self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:question]] setObject:NS_YES forKey:@"show"];
        // insert into visibleSections before insertSections to get title right
        NSDictionary* s = [self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:question]];
        VisibleSection* v = [[VisibleSection alloc] initWithUUID:[s objectForKey:@"uuid"] rgid:[s objectForKey:@"rgid"] groupUUID:nil];
        NSAssert(!(self.visibleSections.count < i), @"tried to plant outside of bounds of visible sections with uuid: %@", question);
        [self.visibleSections insertObject:v atIndex:i];
        [self.visibleHeaders insertObject:[self headerViewWithTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"text"] SubTitle:[[self questionOrGroupWithUUID:question] objectForKey:@"help_text"]] atIndex:i];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
      }
    }
    // show question group's questions
    NSUInteger qIdx = [self indexOfQuestionOrGroupWithUUID:question];
    if (qIdx != NSNotFound) {
      for (NSDictionary *q in [[[self.allSections objectAtIndex:qIdx] objectForKey:@"question"] objectForKey:@"questions"]) {
        NSUInteger i = [self indexForInsert:[q objectForKey:@"uuid"]];
        if (i != 0U) { // NSUInteger 0 is returned by indexForInsert if nothing is found
          if ([self indexOfVisibleQuestionWithUUID:[q objectForKey:@"uuid"]] == NSNotFound){
            NSNumber* show = (![[q objectForKey:@"type"] isEqualToString:@"hidden"] && [self.responseSet showDependency:[q objectForKey:@"dependency"]]) ? NS_YES : NS_NO;
            [[self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:[q objectForKey:@"uuid"]]] setObject:show forKey:@"show"];
            if (show == NS_YES) {
              // insert into visibleSections before insertSections to get title right
              NSDictionary* s = [self.allSections objectAtIndex:[self indexOfQuestionOrGroupWithUUID:[q objectForKey:@"uuid"]]];
                NSString* groupUUID = [[[self allSections] objectAtIndex:qIdx] valueForKey:@"uuid"];
              VisibleSection* v = [[VisibleSection alloc] initWithUUID:[s objectForKey:@"uuid"] rgid:[s objectForKey:@"rgid"] groupUUID:groupUUID];
              [self.visibleSections insertObject:v atIndex:i];
              
              [self.visibleHeaders insertObject:[self headerViewWithTitle:[[self questionOrGroupWithUUID:[q objectForKey:@"uuid"]] objectForKey:@"text"] SubTitle:[[self questionOrGroupWithUUID:[q objectForKey:@"uuid"]] objectForKey:@"help_text"]] atIndex:i];
              [self.tableView insertSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
            }
          }
        }
      }
    }
  } 
  for (NSString *question in [showHide objectForKey:@"hide"]) {
    // hide question group's questions
    NSUInteger gIdx = [self indexOfQuestionOrGroupWithUUID:question];
    if (gIdx != NSNotFound) {
      for (NSDictionary *q in [[[self.allSections objectAtIndex:gIdx] objectForKey:@"question"] objectForKey:@"questions"]) {
        NSUInteger i = [self indexOfVisibleQuestionWithUUID:[q objectForKey:@"uuid"]];
        if (i != NSNotFound) {
          [self.visibleHeaders removeObjectAtIndex:i];
          //      [self removeSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
          [self.visibleSections removeObjectAtIndex:i];
          //      [self headerSectionsReordered];
          [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
        }
      }
    }

    // hide the question
    NSUInteger i = [self indexOfVisibleQuestionWithUUID:question];
    if (i != NSNotFound) {
      [self.visibleHeaders removeObjectAtIndex:i];
//      [self removeSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
      [self.visibleSections removeObjectAtIndex:i];
			//      [self headerSectionsReordered];
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];

    }
  } 	
}

#pragma mark - Exclusive

-(void)deselectOtherNonExclusiveCellsInSectionOfIndex:(NSIndexPath *)idx {
    
    NUSectionTVC __weak *weakSelf = self;
    NSDictionary *(^answerDictionaryForIndexPath)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
        NSString *qid = [[weakSelf idsForIndexPath:indexPath] objectForKey:@"qid"];
        NSString *aid = [[weakSelf idsForIndexPath:indexPath] objectForKey:@"aid"];
        NSDictionary *questionDictionary = [weakSelf questionOrGroupWithUUID:qid];
        NSDictionary *answerDictionary = [[questionDictionary[@"answers"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uuid MATCHES %@", aid]] lastObject];
        return answerDictionary;
    };
    
    void (^ deselectAnswerAtIndexPath)(NSIndexPath *) = ^(NSIndexPath *deselectedIndexPath) {
        NSArray *answersMatchingDeselectArray = [self.responseSet responsesForQuestion:[[self idsForIndexPath:deselectedIndexPath] objectForKey:@"qid"] Answer:[[self idsForIndexPath:deselectedIndexPath] objectForKey:@"aid"]];
        if (answersMatchingDeselectArray.count > 0) {
            UITableViewCell<NUCell> *cell = (UITableViewCell<NUCell> *)[weakSelf.tableView cellForRowAtIndexPath:deselectedIndexPath];
            [cell selectedinTableView:weakSelf.tableView indexPath:deselectedIndexPath];
            [weakSelf showAndHideDependenciesTriggeredBy:deselectedIndexPath];
            if (weakSelf.cursorView && ![weakSelf.cursorView isDescendantOfView:cell]) {
                [weakSelf.cursorView resignFirstResponder];
                weakSelf.cursorView = nil;
            }
        }
    };
    
    NSDictionary *answerDictionary = answerDictionaryForIndexPath(idx);
    if ([answerDictionary[@"exclusive"] isEqualToNumber:@(YES)]) {  //if the cell is exclusive…
        NSUInteger numberOfCells = [self.tableView numberOfRowsInSection:idx.section];
        for (int i = 0; i < numberOfCells ; i++) {
            if (i != idx.row) {
                NSIndexPath *deselectIndexPath = [NSIndexPath indexPathForRow:i inSection:idx.section];
                deselectAnswerAtIndexPath(deselectIndexPath); //…deselect other rows
            }
        }
        return;
    }
    else {
        NSUInteger numberOfCells = [self.tableView numberOfRowsInSection:idx.section]; //otherwise, deselect any exclusive rows that are selected
        for (int i = 0; i < numberOfCells ; i++) {
            if (i != idx.row) {
                NSIndexPath *deselectIndexPath = [NSIndexPath indexPathForRow:i inSection:idx.section];
                NSDictionary *answerDictionary = answerDictionaryForIndexPath(deselectIndexPath);
                if ([answerDictionary[@"exclusive"] isEqualToNumber:@(YES)]) {
                    NSIndexPath *deselectIndexPath = [NSIndexPath indexPathForRow:i inSection:idx.section];
                    deselectAnswerAtIndexPath(deselectIndexPath);
                }
            }
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
  UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
  NSIndexPath *idx = [self.tableView indexPathForCell:cell];
  self.cursorIndex = idx;
  self.cursorView = textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
  NSIndexPath *idx = self.cursorIndex;
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:idx];
  [self deleteResponseForIndexPath:idx];
  if ([cell.reuseIdentifier isEqualToString:@"NUAnyStringOrNumberCell"] || [cell.reuseIdentifier isEqualToString:@"NUOneStringOrNumberCell"]) {
    [self newResponseForIndexPath:idx Value:textField.text];
    textField.userInteractionEnabled = NO;
  } else if((textField.text != nil && ![textField.text isEqualToString:@""])){
    [self newResponseForIndexPath:idx Value:textField.text];    
  }
  
  [self showAndHideDependenciesTriggeredBy:idx];
  self.cursorIndex = nil;
  self.cursorView = nil;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
  UITableViewCell *cell = (UITableViewCell *)textView.superview.superview;
  NSIndexPath *idx = [self.tableView indexPathForCell:cell];
  self.cursorIndex = idx;
  self.cursorView = textView;
}
- (void)textViewDidEndEditing:(UITextView *)aTextView {
  NSIndexPath *idx = self.cursorIndex;
  [self deleteResponseForIndexPath:idx];
  if (aTextView.text != nil && ![aTextView.text isEqualToString:@""]) {
    [self newResponseForIndexPath:idx Value:aTextView.text];
  }
  [self showAndHideDependenciesTriggeredBy:idx];
  self.cursorIndex = nil;
  self.cursorView = nil;
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

#pragma mark - GRMustache

- (NSString *) renderMustacheFromString:(NSString *)templateString{
  NSError *error = NULL;
  GRMustacheTemplate *template = [GRMustacheTemplate templateFromString:templateString error:&error];
  template.delegate = self;
  // NSLog(@"%@", template.description);
  return [template renderObject:self.renderContext];
}

- (void)template:(GRMustacheTemplate *)template willInterpretReturnValueOfInvocation:(GRMustacheInvocation *)invocation as:(GRMustacheInterpretation)interpretation
{
  // When returnValue is nil, GRMustache could not find any value to render.
  if (invocation.returnValue == nil) {
    //    NSLog(@"GRMustache missing value for %@", invocation.description);
    NSError *error = NULL;    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\{\\{.*\\}\\})" options:0 error:&error];
    NSRange range = [regex rangeOfFirstMatchInString:invocation.description options:0 range:NSMakeRange(0, [invocation.description length])];
    invocation.returnValue = [invocation.description substringWithRange:range];
  }
}

@end
