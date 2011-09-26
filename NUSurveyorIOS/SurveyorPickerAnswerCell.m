//
//  SurveyorPickerAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorPickerAnswerCell.h"


@implementation SurveyorPickerAnswerCell
@synthesize pickerController, popoverController, answers;

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
  self.textLabel.text = @"Pick one";
  self.answers = dataObject;
  if (pickerController == nil) {
    self.pickerController = [[NUPickerVC alloc] init];
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    [pickerController setupDelegate:self withTitle:@"Pick one" date:NO];
    popoverController.delegate = self;
  }

  
}
- (void)handleSelectionInTableView:(UITableView *)aTableView
{
  [super handleSelectionInTableView:aTableView];
  [popoverController presentPopoverFromRect:self.frame inView:aTableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}
- (void) pickerDone{
  [popoverController dismissPopoverAnimated:NO];
}
- (void) pickerCancel{
  [popoverController dismissPopoverAnimated:NO];
}


#pragma mark -
#pragma mark Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [answers count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  UILabel *pickerRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
  pickerRow.backgroundColor = [UIColor clearColor];
  pickerRow.font = [UIFont systemFontOfSize:16.0];
  pickerRow.text = [[(NSArray *)answers objectAtIndex:row] objectForKey:@"text"];
  
  return pickerRow;
}


@end
