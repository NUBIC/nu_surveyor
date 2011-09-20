//
//  SurveyorNoneAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorNoneAnswerCell.h"
#import "PageViewController.h"
#import "UILabel+Resize.h"

@interface SurveyorNoneAnswerCell()
- (void) resetFrames;
@end

@implementation SurveyorNoneAnswerCell
@synthesize textField, label, postLabel;

//
// dealloc
//
// Need to release the textField and label when done
//
- (void)dealloc
{
	[textField release];
	textField = nil;
	[label release];
	label = nil;
  [postLabel release];
  postLabel = nil;
  
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
	return [NSString stringWithFormat:@"%@ %@ %@", label.text, textField.text, postLabel.text];
}

//
// finishConstruction
//
// Completes construction of the cell.
//
- (void)finishConstruction
{
  
	[super finishConstruction];
  self.textLabel.text = nil;
  
  CGFloat fontSize = [UIFont labelFontSize] - 2;
  UIColor *groupedBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
  

	self.label = [[UILabel alloc] init];
  self.textField = [[UITextField alloc] init];
  self.postLabel = [[UILabel alloc] init];
  
  [self resetFrames];
  
  // (pre) text
	[label setUpCellLabelWithFontSize:fontSize];
  label.textAlignment = UITextAlignmentRight;
  label.backgroundColor = groupedBackgroundColor;
  [self.contentView addSubview:label];
  
  // input
	textField.font = [UIFont systemFontOfSize:fontSize];
	textField.textAlignment = UITextAlignmentLeft;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.backgroundColor = groupedBackgroundColor;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.contentView addSubview:textField];
  
  // (post) text
  [postLabel setUpCellLabelWithFontSize:fontSize];
  postLabel.backgroundColor = groupedBackgroundColor;
  postLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
  [self.contentView addSubview:postLabel];

}
- (void) resetFrames {
  CGFloat widthPadding = 8;
  CGFloat heightPadding = 8;
	CGFloat height = self.contentView.frame.size.height - heightPadding * 2;
	CGFloat width = self.contentView.frame.size.width - widthPadding * 2;

  label.frame = CGRectMake(widthPadding, heightPadding, .2 * width, height);
  textField.frame = CGRectMake(widthPadding + (.2 * width) + widthPadding, heightPadding, .6 * width - widthPadding, height);
  postLabel.frame = CGRectMake(widthPadding + (.8 * width), heightPadding, .2 * width, height);
  
  [label setHidden:NO];
  [textField setHidden:NO];
  [postLabel setHidden:NO];
  
}

- (void)handleSelectionInTableView:(UITableView *)aTableView
{
  // super call unnecessary because of UITableViewCellSelectionStyleNone
//	[super handleSelectionInTableView:aTableView];
  if (textField.hidden == NO) {
    [textField becomeFirstResponder];
  }
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
  [self resetFrames];

  // (pre) text
  if ([dataObject objectForKey:@"text"] == nil || [[dataObject objectForKey:@"text"] isEqualToString:@""]) {
    [label setHidden:YES];
    textField.frame = CGRectMake(label.frame.origin.x, 
                                 label.frame.origin.y, 
                                 textField.frame.origin.x - label.frame.origin.x + textField.frame.size.width, 
                                 textField.frame.size.height);
    label.text = nil;
  } else {
    label.text = [dataObject objectForKey:@"text"];
  }
  
  // input
	if ([[dataObject objectForKey:@"type"] isEqualToString:@"string"]) {
//    textField.text = [(NSDictionary *)dataObject objectForKey:@"value"];
//    textField.placeholder = [(NSDictionary *)dataObject objectForKey:@"placeholder"];
    textField.delegate = (PageViewController *)aTableView.delegate;
  } else if([[dataObject objectForKey:@"type"] isEqualToString:@"integer"] ||
            [[dataObject objectForKey:@"type"] isEqualToString:@"float"]){
//    textField.text = [(NSDictionary *)dataObject objectForKey:@"value"];
//    textField.placeholder = [(NSDictionary *)dataObject objectForKey:@"placeholder"];
    textField.delegate = (PageViewController *)aTableView.delegate;
    textField.keyboardType = UIKeyboardTypeNumberPad;
  } else {
    [self.textField setHidden:YES];
  }
  
  // (post) text
  if ([dataObject objectForKey:@"post_text"] == nil || [[dataObject objectForKey:@"post_text"] isEqualToString:@""]) {
    [postLabel setHidden:YES];
    textField.frame = CGRectMake(textField.frame.origin.x, 
                                 textField.frame.origin.y, 
                                 postLabel.frame.size.width + textField.frame.size.width, 
                                 textField.frame.size.height);
  } else {
    postLabel.text = [dataObject objectForKey:@"post_text"];
  }

  [self layoutSubviews];
}

@end
