//
//  NUDatePickerCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUDatePickerCell.h"

@interface NUDatePickerCell()
- (void) pickerDone;
- (NSDateFormatter *) dateFormatterFromType:(NSString *)type;
@end

@implementation NUDatePickerCell
@synthesize sectionTVC = _sectionTVC, pickerVC = _pickerVC, popoverController = _popoverController, dateFormatter = _dateFormatter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - NUCell
- (NSString *)accessibilityLabel{
	return [NSString stringWithFormat:@"%@", self.textLabel.text];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.dateFormatter = [self dateFormatterFromType:[dataObject objectForKey:@"type"]];
  
  // set up popover with datepicker
  if (self.pickerVC == nil) {
    self.pickerVC = [[NUPickerVC alloc] init];    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.pickerVC];
    self.pickerVC.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:nav];
    [self.pickerVC setupDelegate:self withTitle:[NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]] date:YES];
    self.pickerVC.nowButton.title = [[dataObject objectForKey:@"type"] isEqualToString:@"date"] ? @"    Today   " : @"      Now     ";
    self.pickerVC.datePicker.datePickerMode = [self datePickerModeFromType:[dataObject objectForKey:@"type"]];
    self.popoverController.delegate = self;
  }

  // look up existing response, fill in text and set datepicker
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];
  NSManagedObject *existingResponse = [[self.sectionTVC responsesForIndexPath:indexPath] lastObject];
  if (existingResponse) {
    self.textLabel.text = [existingResponse valueForKey:@"value"];
    self.textLabel.textColor = RGB(1, 113, 233);
    self.pickerVC.datePicker.date = [self.dateFormatter dateFromString:[existingResponse valueForKey:@"value"]];
  } else {
    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
    self.textLabel.textColor = [UIColor blackColor];
  }

}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	[self.popoverController presentPopoverFromRect:self.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1];
}
- (void)deselect{
  [self setSelected:NO animated:YES];
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
- (void) nowPressed{
  [self.pickerVC.datePicker setDate:[NSDate date] animated:YES];
  [self performSelector:@selector(pickerDone) withObject:nil afterDelay:0.4];
	//  [self  pickerDone];  
}
- (void) pickerDone{
  [self.popoverController dismissPopoverAnimated:NO];
  
  NSString *selectedDate = [self.dateFormatter stringFromDate:[self.pickerVC.datePicker date]]; 
  [self.sectionTVC deleteResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self]];
  [self.sectionTVC newResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self] Value:selectedDate];
  [self.sectionTVC showAndHideDependenciesTriggeredBy:[self.sectionTVC.tableView indexPathForCell:self]];
  self.textLabel.text = selectedDate;
  self.textLabel.textColor = RGB(1, 113, 233);
}
- (void) pickerCancel{
  [self.popoverController dismissPopoverAnimated:NO];
}

@end
