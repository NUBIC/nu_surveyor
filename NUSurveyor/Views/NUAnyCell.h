//
//  NUAnyCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUCell.h"
#import "NUSectionTVC.h"

@interface NUAnyCell : UITableViewCell <NUCell>

@property (nonatomic, weak) NUSectionTVC *sectionTVC;
@property (nonatomic, assign) BOOL checked;

- (void) check;
- (void) uncheck;

@end
