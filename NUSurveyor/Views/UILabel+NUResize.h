//
//  UILabel+NUResize.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NUResize)
-(void)setUpMultiLineVerticalResizeWithFont:(UIFont*)font;
-(void)setUpCellLabelWithFontSize:(CGFloat)fontSize;
@end
