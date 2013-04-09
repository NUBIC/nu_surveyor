//
//  NUGridOneCell.h
//  NUSurveyoriOS
//
//  Created by Mark Yoon on 1/24/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCell.h"
#import "NUMultiLineControl.h"

@interface NUGridOneCell : UITableViewCell <NUCell>

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) NUMultiLineControl *segments;
@property (nonatomic, strong) NSArray *answers;

+ (CGFloat)cellHeightForQuestion:(NSDictionary *)question contentWidth:(CGFloat)contentWidth;

@end
