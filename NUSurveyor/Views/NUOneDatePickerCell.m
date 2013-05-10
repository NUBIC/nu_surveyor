//
//  NUOneDatePickerCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 3/27/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUOneDatePickerCell.h"
#import "NUOneStringOrNumberCell.h"
#import "NSDateFormatter+NUAdditions.h"

@interface NUOneDatePickerCell() <NUPickerVCDelegate>
- (NSDateFormatter *) dateFormatterFromType:(NSString *)type;
- (NSDateFormatter *) storedDateFormatterFromType:(NSString *)type;
@end
@implementation NUOneDatePickerCell
@synthesize pickerVC = _pickerVC, popoverController = _popoverController, displayDateFormatter = _displayDateFormatter, storedDateFormatter = _storedDateFormatter, type = _type;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - NUCell
- (NSString *)accessibilityLabel{
	return [NSString stringWithFormat:@"NUOneDatePickerCell %@", self.textLabel.text];
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
    [self dot];
    self.pickerVC.datePicker.date = [self.storedDateFormatter dateFromString:[existingResponse valueForKey:@"value"]];    
    NSString *display = [self.displayDateFormatter stringFromDate:[self.pickerVC.datePicker date]];
    self.detailTextLabel.text = display;
    self.detailTextLabel.textColor = RGB(1, 113, 233);
  } else {
    [self undot];
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
    self.detailTextLabel.textColor = [UIColor blackColor];
  }
  
}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  for (int i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
		NSIndexPath *j = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
		if (![j isEqual:indexPath]) {
      [self.sectionTVC deleteResponseForIndexPath:j];
      NUOneCell *cell = (NUOneCell *)[tableView cellForRowAtIndexPath:j];
      [cell undot];
      if ([[[tableView cellForRowAtIndexPath:j] reuseIdentifier] isEqualToString:@"NUOneStringOrNumberCell"]) {
        ((NUOneStringOrNumberCell *)cell).textField.text = nil;
        [((NUOneStringOrNumberCell *)cell).textField resignFirstResponder]; // doing this will create a response, which needs to be deleted
        [self.sectionTVC deleteResponseForIndexPath:j];
      } else if([[[tableView cellForRowAtIndexPath:j] reuseIdentifier] isEqualToString:@"NUOneDatePickerCell"]){
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), ((NUOneDatePickerCell *)cell).type];
        cell.detailTextLabel.textColor = [UIColor blackColor];
      }
      
    }
	}
  if (![[self.sectionTVC responsesForIndexPath:indexPath] lastObject]) {
		[self.sectionTVC newResponseForIndexPath:indexPath];
	}
  [self.popoverController presentPopoverFromRect:self.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  [(NUOneCell *)[tableView cellForRowAtIndexPath:indexPath] dot];
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
    NSDateFormatter *formatter = [NSDateFormatter dateResponseFormatter];
    if ([type isEqualToString:@"datetime"]) {
        formatter = [NSDateFormatter dateTimeResponseFormatter];
    } else if ([type isEqualToString:@"time"]) {
        formatter = [NSDateFormatter timeResponseFormatter];
    }
    return formatter;
}
- (void) nowPressed{
  [self.pickerVC.datePicker setDate:[NSDate date] animated:YES];
  [self performSelector:@selector(pickerViewControllerIsDone:) withObject:nil afterDelay:0.4];
}
- (void) pickerViewControllerIsDone:(NUPickerVC *)pickerViewController {
  [self.popoverController dismissPopoverAnimated:NO];
  
  [self.sectionTVC deleteResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self]];
  NSString *store = [self.storedDateFormatter stringFromDate:[self.pickerVC.datePicker date]]; 
  [self.sectionTVC newResponseForIndexPath:[self.sectionTVC.tableView indexPathForCell:self] Value:store];
  [self.sectionTVC showAndHideDependenciesTriggeredBy:[self.sectionTVC.tableView indexPathForCell:self]];

  NSString *display = [self.displayDateFormatter stringFromDate:[self.pickerVC.datePicker date]];
  self.detailTextLabel.text = display;
  self.detailTextLabel.textColor = RGB(1, 113, 233);
}
- (void) pickerViewControllerDidCancel:(NUPickerVC *)pickerViewController {
  [self.popoverController dismissPopoverAnimated:NO];
}


@end