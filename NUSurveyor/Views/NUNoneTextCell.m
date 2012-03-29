//
//  NUNoneTextCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUNoneTextCell.h"

@implementation NUNoneTextCell
@synthesize textView = _textView, label = _label, sectionTVC = _sectionTVC;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, 
                                          self.contentView.frame.origin.y,
                                          self.contentView.frame.size.width,
                                          self.contentView.frame.size.height * 5);
      
      CGFloat height = self.contentView.bounds.size.height;
      CGFloat width = self.contentView.bounds.size.width;
      CGFloat fontSize = [UIFont labelFontSize] - 2;
      CGFloat heightPadding = 8;
      CGFloat labelHeight = fontSize + heightPadding;
      CGFloat widthPadding = 8;
      UIColor *groupedBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1];
      
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      self.textView =
      [[UITextView alloc]
       initWithFrame:
       CGRectMake(widthPadding,
                  heightPadding + labelHeight, 
                  width - 2.0 * widthPadding,
                  height - 2.0 * heightPadding - labelHeight)];
      self.textView.backgroundColor = groupedBackgroundColor;
      self.textView.font = [UIFont systemFontOfSize:fontSize];
      self.textView.textAlignment = UITextAlignmentLeft;
      
      self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
      self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
      self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      [self.contentView addSubview:self.textView];
      
      self.label = [[UILabel alloc] initWithFrame:
                    CGRectMake(widthPadding,
                               heightPadding,
                               width - 2.0 * widthPadding,
                               labelHeight)];
      self.label.backgroundColor = groupedBackgroundColor;
      self.label.font = [UIFont boldSystemFontOfSize:fontSize];
      self.label.textAlignment = UITextAlignmentLeft;
      
      self.label.highlightedTextColor = [UIColor colorWithRed:0.50 green:0.2 blue:0.0 alpha:1.0];
      self.label.textColor = [UIColor blackColor];
      self.label.shadowColor = [UIColor whiteColor];
      self.label.shadowOffset = CGSizeMake(0, 1);
      
      [self.contentView addSubview:self.label];
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
	return [NSString stringWithFormat:@"NUNoneTextCell %@ %@", self.label.text, self.textView.text];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	self.textView.text = nil;
  self.textView.delegate = nil;
  
  // look up existing response, fill in text
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];
  NSManagedObject *existingResponse = [[self.sectionTVC responsesForIndexPath:indexPath] lastObject];
  if (existingResponse) {
    self.textView.text = [existingResponse valueForKey:@"value"];
  }
  self.textView.delegate = self.sectionTVC;
  
  if ([[dataObject objectForKey:@"text"] length] < 1 ) {
    self.label.text = @"";
    self.textView.frame = CGRectMake(self.label.frame.origin.x,
                                     self.label.frame.origin.y + self.label.frame.size.height / 2, 
                                     self.textView.frame.size.width,
                                     self.textView.frame.size.height);
    [self.label setHidden:TRUE];
  } else {
    self.textView.frame = CGRectMake(self.label.frame.origin.x,
                                     self.label.frame.origin.y + self.label.frame.size.height, 
                                     self.textView.frame.size.width,
                                     self.textView.frame.size.height);
    self.label.text = [GRMustacheTemplate renderObject:self.sectionTVC.renderContext
                                            fromString:[dataObject objectForKey:@"text"]
                                                 error:NULL];
    [self.label setHidden:FALSE];
  }

}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  [self.textView becomeFirstResponder];
  // Don't need deselect for: UITableViewCellSelectionStyleNone
}

@end
