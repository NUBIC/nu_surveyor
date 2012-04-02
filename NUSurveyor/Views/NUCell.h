//
//  NUCell.h
//  NUSurveyor
//
//  Created by Mark Yoon on 1/20/12.
//  Copyright (c) 2012 Unicycle Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUSectionTVC.h"
#import "GRMustache.h"

@protocol NUCell <NSObject>
- (NSString *)accessibilityLabel;
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
