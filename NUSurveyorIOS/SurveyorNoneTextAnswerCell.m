//
//  SurveyorNoneTextAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/15/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorNoneTextAnswerCell.h"
#import "NUSectionVC.h"
#import "PageViewController.h"

@implementation SurveyorNoneTextAnswerCell
@synthesize textView, label;


+ (CGFloat)rowHeight
{
  return [super rowHeight] * 5;
}

//
// dealloc
//
// Need to release the textField and label when done
//
- (void)dealloc
{
	[textView release];
	textView = nil;
	[label release];
	label = nil;
  
	[super dealloc];
}

//
// accessibilityLabel
//
// Make sure people using VoiceOver can use the view correctly
//
// returns the description of this cell (i.e. Label followed by TextField value)
//
- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@ %@", label.text, textView.text];
}

//
// finishConstruction
//
// Completes construction of the cell.
//
- (void)finishConstruction
{
  
	[super finishConstruction];
	
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
  
  textView =
  [[UITextView alloc]
   initWithFrame:
   CGRectMake(widthPadding,
              heightPadding + labelHeight, 
              width - 2.0 * widthPadding,
              height - 2.0 * heightPadding - labelHeight)];
	textView.backgroundColor = groupedBackgroundColor;
  textView.font = [UIFont systemFontOfSize:fontSize];
	textView.textAlignment = UITextAlignmentLeft;
  
	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.contentView addSubview:textView];
  
	label = 
  [[UILabel alloc]
   initWithFrame:
   CGRectMake(widthPadding,
              heightPadding,
              width - 2.0 * widthPadding,
              labelHeight)];
	label.backgroundColor = groupedBackgroundColor;
  label.font = [UIFont boldSystemFontOfSize:fontSize];
  label.textAlignment = UITextAlignmentLeft;
	
	label.highlightedTextColor = [UIColor colorWithRed:0.50 green:0.2 blue:0.0 alpha:1.0];
	label.textColor = [UIColor blackColor];
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0, 1);
  
	[self.contentView addSubview:label];
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
  textView.delegate = (PageViewController *)aTableView.delegate;
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
    self.label.text = [dataObject objectForKey:@"text"];
    [self.label setHidden:FALSE];
  }
  
}

@end
