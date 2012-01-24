//
//  NUGridAnyCell.h
//  NUSurveyoriOS
//
//  Created by Mark Yoon on 1/24/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCell.h"
#import "NUMultiButton.h"
#import "NUSectionTVC.h"

@interface NUGridAnyCell : UITableViewCell <NUCell>

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) NUMultiButton *buttons;
@property (nonatomic, strong) NSArray *answers;

@end
