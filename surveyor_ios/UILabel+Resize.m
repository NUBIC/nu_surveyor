//
//  UILabel+Resize.m
//  surveyor_ios
//
//  Created by Mark Yoon on 6/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILabel+Resize.h"


@implementation UILabel (Resize)
-(void)setUpMultiLineVerticalResizeWithFontSize:(CGFloat)fontSize
{
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0; //instructs the label to contain any number of lines
  self.font = [UIFont systemFontOfSize:fontSize];
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MAX(self.frame.size.height, [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height));
}

-(void)setUpCellLabelWithFontSize:(CGFloat)fontSize
{
  [self setUpMultiLineVerticalResizeWithFontSize:fontSize];
  self.font = [UIFont boldSystemFontOfSize:fontSize];
	self.textAlignment = UITextAlignmentLeft;
	self.backgroundColor = [UIColor whiteColor];
	self.highlightedTextColor = [UIColor colorWithRed:0.50 green:0.2 blue:0.0 alpha:1.0];
	self.textColor = [UIColor blackColor];
	self.shadowColor = [UIColor whiteColor];
	self.shadowOffset = CGSizeMake(0, 1);
}

@end
