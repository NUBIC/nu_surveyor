//
//  PageCell.h
//  TableDesignRevisited
//
//  Created by Matt Gallagher on 2010/01/22.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@interface PageCell : UITableViewCell
{
	IBOutlet UIView *content;
	NSArray *contentArray;
}

@property (nonatomic, assign) UIView *content;

+ (NSString *)reuseIdentifier;
+ (NSString *)nibName;
+ (UITableViewCellStyle)style;
+ (CGFloat)rowHeight;

- (void)configureForData:(id)dataObject
	tableView:(UITableView *)aTableView
	indexPath:(NSIndexPath *)anIndexPath;
- (void)finishConstruction;
- (void)handleSelectionInTableView:(UITableView *)aTableView;

@end
