//
//  SurveyorDatePickerAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorDatePickerAnswerCell.h"

@interface SurveyorDatePickerAnswerCell()
- (void) pickerDone;
- (UIDatePickerMode)datePickerModeFromType:(NSString *)type;
@end
@implementation SurveyorDatePickerAnswerCell
@synthesize pickerController, popoverController;

//
// accessibilityLabel
//
// Make sure people using VoiceOver can use the view correctly
//
// returns the description of this cell (i.e. Label followed by TextField value)
//
- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@", self.textLabel.text];
}

//
// configureForData:tableView:indexPath:
//
// Invoked when the cell is given data. All fields should be updated to reflect
// the data.
//
// Parameters:
//    dataObject - the dataObject (can be nil for data-less objects)
//    aTableView - the tableView (passed in since the cell may not be in the
//		hierarchy)
//    anIndexPath - the indexPath of the cell
//
- (void)configureForData:(id)dataObject
               tableView:(UITableView *)aTableView
               indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
  
  if (self.pickerController == nil) {
    self.pickerController = [[NUPickerVC alloc] init];
    pickerController.contentSizeForViewInPopover = CGSizeMake(384.0, 304.0);
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    [pickerController setupDelegate:self withTitle:[NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]] date:YES];
    pickerController.nowButton.title = [[dataObject objectForKey:@"type"] isEqualToString:@"date"] ? @"    Today   " : @"      Now     ";
    pickerController.datePicker.datePickerMode = [self datePickerModeFromType:[dataObject objectForKey:@"type"]];

    popoverController.delegate = self;
  }
  
}

- (UIDatePickerMode)datePickerModeFromType:(NSString *)type {
  if ([type isEqualToString:@"datetime"]) {
    return UIDatePickerModeDateAndTime;
  } else if ([type isEqualToString:@"time"]) {
    return UIDatePickerModeTime;
  }
  return UIDatePickerModeDate;
}

//
// handleSelectionInTableView:
//
// An overrideable method to handle behavior when a row is selected.
// Default implementation just deselects the row.
//
// Parameters:
//    aTableView - the table view from which the row was selected
//
- (void)handleSelectionInTableView:(UITableView *)aTableView
{
  [super handleSelectionInTableView:aTableView];
  [popoverController presentPopoverFromRect:self.frame inView:aTableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

- (void) nowPressed{
  [self pickerDone];
}
- (void) pickerDone{
  [popoverController dismissPopoverAnimated:NO];
}
- (void) pickerCancel{
  [popoverController dismissPopoverAnimated:NO];
}

@end
