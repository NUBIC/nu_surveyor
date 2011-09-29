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
#import "NUSectionVC.h"

@interface SurveyorNoneAnswerCell()
- (void) resetContent;
@end

@implementation SurveyorNoneAnswerCell
@synthesize textField, label, postLabel, delegate;

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
//  DLog(@"finishConstruction %@", [super.class reuseIdentifier] );
	[super finishConstruction];
  self.textLabel.text = nil;
  
  CGFloat fontSize = [UIFont labelFontSize] - 2;
  UIColor *groupedBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	self.label = [[UILabel alloc] init];
  self.textField = [[UITextField alloc] init];
  self.postLabel = [[UILabel alloc] init];

  // (pre) text
	[label setUpCellLabelWithFontSize:fontSize];
  label.textAlignment = UITextAlignmentRight;
//  label.backgroundColor = [UIColor redColor];
  label.backgroundColor = groupedBackgroundColor;
  label.autoresizingMask = UIViewAutoresizingNone;
  [self.contentView addSubview:label];
  
  // input
	textField.font = [UIFont systemFontOfSize:fontSize];
	textField.textAlignment = UITextAlignmentLeft;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
//	textField.backgroundColor = [UIColor yellowColor];
  textField.backgroundColor = groupedBackgroundColor;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  textField.autoresizingMask = UIViewAutoresizingNone;
	[self.contentView addSubview:textField];
  
  // (post) text
  [postLabel setUpCellLabelWithFontSize:fontSize];
//  postLabel.backgroundColor = [UIColor blueColor];
  postLabel.backgroundColor = groupedBackgroundColor;;
  postLabel.autoresizingMask = UIViewAutoresizingNone;
  [self.contentView addSubview:postLabel];

}
- (void) resetContent {
  [label setHidden:NO];
  [textField setHidden:NO];
  [postLabel setHidden:NO];

  label.text = nil;
  textField.text = nil;
  postLabel.text = nil;
  
  textField.keyboardType = UIKeyboardTypeDefault;
  textField.returnKeyType = UIReturnKeyDone;
  textField.delegate = nil;
}
- (void) layoutSubviews {
  [super layoutSubviews];
  CGFloat groupedCellWidth = UIAppDelegate.sectionController.tableView.frame.size.width - 88.0;
  CGFloat widthPadding = 8;
  CGFloat heightPadding = 8;
	CGFloat height = self.contentView.frame.size.height - heightPadding * 2;
	CGFloat width = groupedCellWidth - widthPadding * 2;
  
  label.frame = CGRectMake(widthPadding, heightPadding, .2 * width, height);
  textField.frame = CGRectMake(widthPadding + (.2 * width) + widthPadding, heightPadding, .6 * width - widthPadding, height);
  postLabel.frame = CGRectMake(widthPadding + (.8 * width), heightPadding, .2 * width, height);
  
  if ([label isHidden]) {
    textField.frame = CGRectMake(label.frame.origin.x, 
                                 label.frame.origin.y, 
                                 textField.frame.origin.x - label.frame.origin.x + textField.frame.size.width, 
                                 textField.frame.size.height);
  }
  if ([postLabel isHidden]) {
    textField.frame = CGRectMake(textField.frame.origin.x, 
                                 textField.frame.origin.y, 
                                 postLabel.frame.size.width + textField.frame.size.width, 
                                 textField.frame.size.height);
  }
  
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
// Invoked when the cell is given data. All fields should be updated to reflect the data.
// Called by tableView cellForRowAtIndexPath in PageViewController
//
// Parameters:
//    dataObject - the dataObject (can be nil for data-less objects)
//    aTableView - the tableView (passed in since the cell may not be in the hierarchy)
//    anIndexPath - the indexPath of the cell
//
- (void)configureForData:(id)dataObject
               tableView:(UITableView *)aTableView
               indexPath:(NSIndexPath *)anIndexPath
{
  [super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
  [self resetContent];

  // look up existing response, fill in text
  self.delegate = (NUSectionVC *)[aTableView delegate];
  NSManagedObject *existingResponse = [[delegate responsesForIndexPath:anIndexPath] lastObject];
  if (existingResponse) {
    self.textField.text = [existingResponse valueForKey:@"value"];
  }

  // (pre) text
  if ([dataObject objectForKey:@"text"] == nil || [[dataObject objectForKey:@"text"] isEqualToString:@""]) {
    [label setHidden:YES];
  } else {
    label.text = [dataObject objectForKey:@"text"];
  }
  
  // input
	if ([[dataObject objectForKey:@"type"] isEqualToString:@"string"]) {
    // string
    textField.delegate = delegate;
  } else if([[dataObject objectForKey:@"type"] isEqualToString:@"integer"] ||
            [[dataObject objectForKey:@"type"] isEqualToString:@"float"]){
    // number
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = delegate;
  } else {
    [self.textField setHidden:YES];
  }
  
  // (post) text
  if ([dataObject objectForKey:@"post_text"] == nil || [[dataObject objectForKey:@"post_text"] isEqualToString:@""]) {
    [postLabel setHidden:YES];
  } else {
    postLabel.text = [dataObject objectForKey:@"post_text"];
  }
  
}

@end
