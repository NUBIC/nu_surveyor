//
//  NUAnyDatePickerCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 3/26/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUAnyDatePickerCell.h"

@interface NUAnyDatePickerCell()
@property (nonatomic, strong) NSString *type;
- (void) pickerDone;
- (NSDateFormatter *) dateFormatterFromType:(NSString *)type;
- (NSDateFormatter *) storedDateFormatterFromType:(NSString *)type;
@end

@implementation NUAnyDatePickerCell
@synthesize pickerVC = _pickerVC, popoverController = _popoverController, displayDateFormatter = _displayDateFormatter, storedDateFormatter = _storedDateFormatter;
@synthesize type = _type;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - NUCell
- (NSString *)accessibilityLabel{
	return [NSString stringWithFormat:@"NUAnyDatePickerCell %@", self.textLabel.text];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	self.sectionTVC = (NUSectionTVC *)tableView.delegate;
  
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.displayDateFormatter = [self dateFormatterFromType:[dataObject objectForKey:@"type"]];
  self.storedDateFormatter = [self storedDateFormatterFromType:[dataObject objectForKey:@"type"]];

  self.textLabel.text = [self.sectionTVC renderMustacheFromString:[dataObject objectForKey:@"text"]];

  self.type = [dataObject objectForKey:@"type"];
  
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
  NSManagedObject *existingResponse = [[self.sectionTVC responsesForIndexPath:indexPath] lastObject];
  if (existingResponse) {
    [self check];
    self.pickerVC.datePicker.date = [self.storedDateFormatter dateFromString:[existingResponse valueForKey:@"value"]];    
    NSString *display = [self.displayDateFormatter stringFromDate:[self.pickerVC.datePicker date]];
    self.detailTextLabel.text = display;
    self.detailTextLabel.textColor = RGB(1, 113, 233);

  } else {
    [self uncheck];
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
    self.detailTextLabel.textColor = [UIColor blackColor];
  }
  
}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  if ([[self.sectionTVC responsesForIndexPath:indexPath] lastObject]) {
		[self.sectionTVC deleteResponseForIndexPath:indexPath];
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), self.type];
    self.detailTextLabel.textColor = [UIColor blackColor];
		[(NUAnyCell *)[tableView cellForRowAtIndexPath:indexPath] uncheck];
	} else {
		[self.sectionTVC newResponseForIndexPath:indexPath];
    [self.popoverController presentPopoverFromRect:self.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
		[(NUAnyCell *)[tableView cellForRowAtIndexPath:indexPath] check];
	}
  [self.sectionTVC.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (NSDateFormatter *) storedDateFormatterFromType:(NSString *)type {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  if ([type isEqualToString:@"datetime"]) {
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mmZ"];
  } else if ([type isEqualToString:@"time"]) {
    [formatter setDateFormat:@"HH:mm"];
  }
  return formatter;
}
- (void) nowPressed{
  [self.pickerVC.datePicker setDate:[NSDate date] animated:YES];
  [self performSelector:@selector(pickerDone) withObject:nil afterDelay:0.4];
}
- (void) pickerDone{
  [self.popoverController dismissPopoverAnimated:NO];
  
  [self.sectionTVC deleteResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self]];
  NSString *store = [self.storedDateFormatter stringFromDate:[self.pickerVC.datePicker date]]; 
  [self.sectionTVC newResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self] Value:store];
  [self.sectionTVC showAndHideDependenciesTriggeredBy:[self.sectionTVC.tableView indexPathForCell:self]];
  
  NSString *display = [self.displayDateFormatter stringFromDate:[self.pickerVC.datePicker date]];
  self.detailTextLabel.text = display;
  self.detailTextLabel.textColor = RGB(1, 113, 233);
}
- (void) pickerCancel{
  [self.popoverController dismissPopoverAnimated:NO];
}


@end