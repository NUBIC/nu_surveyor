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
- (NSDateFormatter *) dateFormatterFromType:(NSString *)type;
@end
@implementation SurveyorDatePickerAnswerCell
@synthesize pickerController, popoverController, delegate, myDateFormatter;

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
  // set up cell
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.myDateFormatter = [self dateFormatterFromType:[dataObject objectForKey:@"type"]];
  
  // set up popover with datepicker
  if (pickerController == nil) {
    self.pickerController = [[NUPickerVC alloc] init];
    pickerController.contentSizeForViewInPopover = CGSizeMake(384.0, 304.0);
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    [pickerController setupDelegate:self withTitle:[NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]] date:YES];
    pickerController.nowButton.title = [[dataObject objectForKey:@"type"] isEqualToString:@"date"] ? @"    Today   " : @"      Now     ";
    pickerController.datePicker.datePickerMode = [self datePickerModeFromType:[dataObject objectForKey:@"type"]];
    popoverController.delegate = self;
  }

  // look up existing response, fill in text and set datepicker
  self.delegate = (NUSectionVC *)[aTableView delegate];
  NSManagedObject *existingResponse = [[delegate responsesForIndexPath:anIndexPath] lastObject];
  if (existingResponse) {
    self.textLabel.text = [existingResponse valueForKey:@"value"];
    self.textLabel.textColor = RGB(1, 113, 233);
    pickerController.datePicker.date = [myDateFormatter dateFromString:[existingResponse valueForKey:@"value"]];
  } else {
    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
    self.textLabel.textColor = [UIColor blackColor];
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
- (NSDateFormatter *) dateFormatterFromType:(NSString *)type {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM/dd/yyyy"];
  if ([type isEqualToString:@"datetime"]) {
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
  } else if ([type isEqualToString:@"time"]) {
    [formatter setDateFormat:@"HH:mm"];
  }
  return formatter;
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
  [pickerController.datePicker setDate:[NSDate date] animated:YES];
  [self performSelector:@selector(pickerDone) withObject:nil afterDelay:0.4];
//  [self  pickerDone];  
}
- (void) pickerDone{
  [popoverController dismissPopoverAnimated:NO];
  
  NSString *selectedDate = [myDateFormatter stringFromDate:[pickerController.datePicker date]]; 
  [delegate deleteResponseForIndexPath:[delegate.tableView indexPathForCell:self]];
  [delegate newResponseForIndexPath:[delegate.tableView indexPathForCell:self] Value:selectedDate];
  [delegate showAndHideDependenciesTriggeredBy:[delegate.tableView indexPathForCell:self]];
  self.textLabel.text = selectedDate;
  self.textLabel.textColor = RGB(1, 113, 233);
}
- (void) pickerCancel{
  [popoverController dismissPopoverAnimated:NO];
}

@end
