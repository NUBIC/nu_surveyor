//
//  SurveySectionViewController.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/7/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveySectionViewController.h"
#import "LabelCell.h"
#import "TextFieldCell.h"
#import "NibLoadedCell.h"
#import "UILabel+Resize.h"

@implementation SurveySectionViewController
@synthesize detailItem;
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
  
//  if (self.popoverController != nil) {
//    [self.popoverController dismissPopoverAnimated:YES];
//  }
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
      [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
      for (NSInteger j = 0; j < 4; j++)
      {
        [self
         appendRowToSection:i
         cellClass:[LabelCell class]
         cellData:[NSString stringWithFormat:
                   NSLocalizedString(@"This is row %ld", @""), j + 1]
         withAnimation:(j % 2) == 0 ?
         UITableViewRowAnimationLeft :
         UITableViewRowAnimationRight];
      }
      i++;
    }else{
      [self addSectionAtIndex:i withAnimation:UITableViewRowAnimationFade];
      for (NSInteger k = 0; k < 4; k++)
      {
        [self
         appendRowToSection:i
         cellClass:[LabelCell class]
         cellData:[NSString stringWithFormat:
                   NSLocalizedString(@"This is row %ld", @""), k + 1]
         withAnimation:(k % 2) == 0 ?
         UITableViewRowAnimationLeft :
         UITableViewRowAnimationRight];
      }
      i++;
    }
  }
  
//	[self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
//	for (NSInteger i = 0; i < 4; i++)
//	{
//		[self
//     appendRowToSection:0
//     cellClass:[LabelCell class]
//     cellData:[NSString stringWithFormat:
//               NSLocalizedString(@"This is row %ld", @""), i + 1]
//     withAnimation:(i % 2) == 0 ?
//     UITableViewRowAnimationLeft :
//     UITableViewRowAnimationRight];
//	}
//  
//	[self addSectionAtIndex:1 withAnimation:UITableViewRowAnimationFade];
//	for (NSInteger i = 0; i < 4; i++)
//	{
//		[self
//     appendRowToSection:1
//     cellClass:[NibLoadedCell class]
//     cellData:[NSString stringWithFormat:
//               NSLocalizedString(@"This is row %ld", @""), i + 1]
//     withAnimation:(i % 2) == 0 ?
//     UITableViewRowAnimationLeft :
//     UITableViewRowAnimationRight];
//	}
//  
//	[self addSectionAtIndex:2 withAnimation:UITableViewRowAnimationFade];
//	for (NSInteger i = 0; i < 4; i++)
//	{
//		[self
//     appendRowToSection:2
//     cellClass:[TextFieldCell class]
//     cellData:
//     [NSMutableDictionary dictionaryWithObjectsAndKeys:
//      [NSString stringWithFormat:
//       NSLocalizedString(@"TextField very very very very very very long %ld", @""), (i + 1)*50],
//      @"label",
//      @"", @"value",
//      NSLocalizedString(@"Value goes here", @""),
//      @"placeholder",
//      nil]
//     withAnimation:(i % 2) == 0 ?
//     UITableViewRowAnimationLeft :
//     UITableViewRowAnimationRight];
//	}
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
// On load, refreshes the view (to load the rows)
//
- (void)viewDidLoad
{
  [super viewDidLoad];
	self.useCustomHeaders = YES;
	[self refresh:nil];
}

//
// loadView
//
// Since the view is so simple (just a UITableView) we might as
// well contruct it in code.
//
- (void)loadView
{
  UITableView * aTableView = 
  [[[UITableView alloc] 
    initWithFrame:CGRectZero 
    style:UITableViewStyleGrouped] 
   autorelease];
	self.view = aTableView;
	self.tableView = aTableView;
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

@end