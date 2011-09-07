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
#import "GradientBackgroundTable.h"

@implementation SurveySectionViewController
//
// title
//
// returns the navigation bar text for the front screen
//
- (NSString *)title
{
	return NSLocalizedString(@"TableViewRevisited", @"");
}

//
// createRows
//
// Constructs all the rows on the front screen and animates them in
//
- (void)createRows
{
	[self addSectionAtIndex:0 withAnimation:UITableViewRowAnimationFade];
	for (NSInteger i = 0; i < 4; i++)
	{
		[self
     appendRowToSection:0
     cellClass:[LabelCell class]
     cellData:[NSString stringWithFormat:
               NSLocalizedString(@"This is row %ld", @""), i + 1]
     withAnimation:(i % 2) == 0 ?
     UITableViewRowAnimationLeft :
     UITableViewRowAnimationRight];
	}
  
	[self addSectionAtIndex:1 withAnimation:UITableViewRowAnimationFade];
	for (NSInteger i = 0; i < 4; i++)
	{
		[self
     appendRowToSection:1
     cellClass:[NibLoadedCell class]
     cellData:[NSString stringWithFormat:
               NSLocalizedString(@"This is row %ld", @""), i + 1]
     withAnimation:(i % 2) == 0 ?
     UITableViewRowAnimationLeft :
     UITableViewRowAnimationRight];
	}
  
	[self addSectionAtIndex:2 withAnimation:UITableViewRowAnimationFade];
	for (NSInteger i = 0; i < 4; i++)
	{
		[self
     appendRowToSection:2
     cellClass:[TextFieldCell class]
     cellData:
     [NSMutableDictionary dictionaryWithObjectsAndKeys:
      [NSString stringWithFormat:
       NSLocalizedString(@"TextField very very very very very very long %ld", @""), (i + 1)*50],
      @"label",
      @"", @"value",
      NSLocalizedString(@"Value goes here", @""),
      @"placeholder",
      nil]
     withAnimation:(i % 2) == 0 ?
     UITableViewRowAnimationLeft :
     UITableViewRowAnimationRight];
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
// Since the view is so simple (just a GradientBackgroundView) we might as
// well contruct it in code.
//
- (void)loadView
{
	GradientBackgroundTable *aTableView =
  [[[GradientBackgroundTable alloc]
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
	if (section == 0)
	{
		return NSLocalizedString(@"Simple text rows", nil);
	}
	else if (section == 1)
	{
		return NSLocalizedString(@"Rows loaded from NIBs", nil);
	}
	else if (section == 2)
	{
		return NSLocalizedString(@"Some editable text fields", nil);
	}
  
	return nil;
}

@end


