//
//  NUOneStringOrNumberCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 3/27/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUOneCell.h"

@interface NUOneStringOrNumberCell : NUOneCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *postLabel;

@end
