//
//  NUPickerCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUPickerCell.h"

@implementation NUPickerCell
@synthesize pickerController = _pickerController, popoverController = _popoverController, answers = _answers, sectionTVC = _sectionTVC;

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
	return [NSString stringWithFormat:@"NUPickerCell %@", self.textLabel.text];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.answers = (NSArray *)dataObject;
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];
  self.textLabel.text = @"Pick one";
  self.textLabel.textColor = [UIColor blackColor];
  for (int i = 0; i < [self.answers count]; i++) {
    if ([[self.sectionTVC responsesForIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]] lastObject]) {
      self.textLabel.text = [[self.answers objectAtIndex:i] valueForKey:@"text"];
      self.textLabel.textColor = RGB(1, 113, 233);
    }
  }
  if (self.pickerController == nil) {
    self.pickerController = [[NUPickerVC alloc] init];    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.pickerController];
    self.pickerController.contentSizeForViewInPopover = CGSizeMake(384.0, 216.0);
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:nav];
    [self.pickerController setupDelegate:self withTitle:@"Pick one" date:NO];
    self.popoverController.delegate = self;
  }

}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	[self.popoverController presentPopoverFromRect:self.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1];
}
- (void)deselect{
  [self setSelected:NO animated:YES];
}

- (NSIndexPath *)myIndexPathWithRow:(NSUInteger)r {
  return [NSIndexPath indexPathForRow:r inSection:[(UITableView *)self.sectionTVC.tableView indexPathForCell:self].section];
}
- (void) pickerDone{
  [self.popoverController dismissPopoverAnimated:NO];
  NSUInteger selectedRow = [self.pickerController.picker selectedRowInComponent:0]; 
  if (selectedRow != -1) {
    [self.sectionTVC deleteResponseForIndexPath:[self myIndexPathWithRow:selectedRow]];
    [self.sectionTVC newResponseForIndexPath:[self myIndexPathWithRow:selectedRow]];
    [self.sectionTVC showAndHideDependenciesTriggeredBy:[self myIndexPathWithRow:selectedRow]];
    self.textLabel.text = [(NSDictionary *)[self.answers objectAtIndex:selectedRow] objectForKey:@"text"];
    self.textLabel.textColor = RGB(1, 113, 233);
  }
}
- (void) pickerCancel{
  [self.popoverController dismissPopoverAnimated:NO];
}


#pragma mark - Picker view data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}

#pragma mark - Picker view delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [self.answers count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  UILabel *pickerRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
  pickerRow.backgroundColor = [UIColor clearColor];
  pickerRow.font = [UIFont systemFontOfSize:16.0];
  pickerRow.text = [[self.answers objectAtIndex:row] objectForKey:@"text"];
  
  return pickerRow;
}

@end
