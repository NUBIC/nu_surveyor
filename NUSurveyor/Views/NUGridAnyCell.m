//
//  NUGridAnyCell.m
//  NUSurveyoriOS
//
//  Created by Mark Yoon on 1/24/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUGridAnyCell.h"
#import "UILabel+NUResize.h"

@interface NUGridAnyCell()
- (void)resetContent;
@end
@implementation NUGridAnyCell
@synthesize sectionTVC = _sectionTVC, label = _label, postLabel = _postLabel, buttons = _buttons, answers = _answers;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self.textLabel setHidden:YES];
      
      CGFloat fontSize = [UIFont labelFontSize] - 2;
      UIColor *groupedBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      self.label = [[UILabel alloc] init];
      self.buttons = [[NUMultiButton alloc] init];
      self.postLabel = [[UILabel alloc] init];
      
      // (pre) text
      [self.label setUpCellLabelWithFontSize:fontSize];
      self.label.textAlignment = UITextAlignmentRight;
      //  self.label.backgroundColor = [UIColor redColor];
      self.label.backgroundColor = groupedBackgroundColor;
      self.label.autoresizingMask = UIViewAutoresizingNone;
      [self.contentView addSubview:self.label];
      
      // buttons
      
      [self.contentView addSubview:self.buttons];
      [self.buttons addTarget:self
                  action:@selector(buttonsChanged)
        forControlEvents:UIControlEventValueChanged];
      
      // (post) text
      [self.postLabel setUpCellLabelWithFontSize:fontSize];
      //  self.postLabel.backgroundColor = [UIColor blueColor];
      self.postLabel.backgroundColor = groupedBackgroundColor;;
      self.postLabel.autoresizingMask = UIViewAutoresizingNone;
      [self.contentView addSubview:self.postLabel];

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
  return [NSString stringWithFormat:@"NUGridAnyCell %@", self.answers];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  [self resetContent];
  
  self.answers = [dataObject objectForKey:@"answers"];
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];  
  
  // (pre) text
  if ([dataObject objectForKey:@"text"] == nil || [[dataObject objectForKey:@"text"] isEqualToString:@""]) {
    [self.label setHidden:YES];
  } else {
    self.label.text = [dataObject objectForKey:@"text"];
  }
  
  // input
  [self.buttons setItems:[self.answers valueForKey:@"text"]];
//  [self.buttons selectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]];
  // (post) text
  if ([dataObject objectForKey:@"post_text"] == nil || [[dataObject objectForKey:@"post_text"] isEqualToString:@""]) {
    [self.postLabel setHidden:YES];
  } else {
    self.postLabel.text = [dataObject objectForKey:@"post_text"];
  }
  
  // look up existing response
//  NSManagedObject *existingResponse = [[self.sectionTVC responsesForIndexPath:indexPath] lastObject];
//  if (existingResponse) {
//    self.textLabel.text = [existingResponse valueForKey:@"value"];
//    self.textLabel.textColor = RGB(1, 113, 233);
//    self.pickerVC.datePicker.date = [self.dateFormatter dateFromString:[existingResponse valueForKey:@"value"]];
//  } else {
//    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Pick %@", @""), [dataObject objectForKey:@"type"]];
//    self.textLabel.textColor = [UIColor blackColor];
//  }
  
  [self layoutSubviews];
}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  
}

- (void) buttonsChanged{
  //  DLog(@"buttonsChanged");
  //  DLog(@"indexes: %@", [buttons selectedIndexes]);
}
- (void) resetContent {
  [self.label setHidden:NO];
  [self.postLabel setHidden:NO];
  
  self.label.text = nil;
  [self.buttons clearItems];
  self.postLabel.text = nil;
  
}
- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat groupedCellWidth = self.frame.size.width - 88.0;
  CGFloat widthPadding = 8;
  CGFloat heightPadding = 4;
	CGFloat height = self.contentView.frame.size.height - heightPadding * 2;
	CGFloat width = groupedCellWidth - widthPadding * 2;
  
  self.label.frame = CGRectMake(widthPadding, heightPadding, .15 * width, height);
  self.buttons.frame = CGRectMake(widthPadding + (.15 * width) + widthPadding, heightPadding, .7 * width -  (2 * widthPadding), height);
  self.postLabel.frame = CGRectMake(widthPadding + (.85 * width), heightPadding, .15 * width, height);
  
  if ([self.label isHidden]) {
    self.buttons.frame = CGRectMake(self.label.frame.origin.x, 
                               self.label.frame.origin.y, 
                               self.buttons.frame.origin.x - self.label.frame.origin.x + self.buttons.frame.size.width, 
                               self.buttons.frame.size.height);
  }
  if ([self.postLabel isHidden]) {
    self.buttons.frame = CGRectMake(self.buttons.frame.origin.x, 
                               self.buttons.frame.origin.y, 
                               self.postLabel.frame.size.width + self.buttons.frame.size.width, 
                               self.buttons.frame.size.height);
  }
  //  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, buttons.frame.size.height + 2 * heightPadding);
}
@end
