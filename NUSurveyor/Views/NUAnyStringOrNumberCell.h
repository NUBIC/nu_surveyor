//
//  NUAnyStringOrNumberCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 3/26/2012.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUAnyCell.h"

@interface NUAnyStringOrNumberCell : NUAnyCell

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *postLabel;

@end
