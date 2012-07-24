//
//  UILabel+NUResize.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "UILabel+NUResize.h"

@implementation UILabel (NUResize)
-(void)setUpMultiLineVerticalResizeWithFont:(UIFont*)font
{
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0; //instructs the label to contain any number of lines
  self.font = font;
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MAX(self.frame.size.height, [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height));
}

-(void)setUpCellLabelWithFontSize:(CGFloat)fontSize
{
  [self setUpMultiLineVerticalResizeWithFont:[UIFont boldSystemFontOfSize:fontSize]];
  self.font = [UIFont boldSystemFontOfSize:fontSize];
	self.textAlignment = UITextAlignmentLeft;
	self.backgroundColor = [UIColor whiteColor];
	self.highlightedTextColor = [UIColor whiteColor];
	self.textColor = [UIColor blackColor];
	self.shadowColor = [UIColor whiteColor];
	self.shadowOffset = CGSizeMake(0, 1);
}
@end
