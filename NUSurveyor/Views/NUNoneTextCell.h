//
//  NUNoneTextCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCell.h"

@interface NUNoneTextCell : UITableViewCell <NUCell>

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;

+ (CGFloat)cellHeightForQuestion:(NSDictionary *)question contentWidth:(CGFloat)contentWidth;

@end
