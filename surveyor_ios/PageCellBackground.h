//
//  PageCellBackground.h
//  TableDesignRevisited
//
//  Created by Matt Gallagher on 27/04/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
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

typedef enum
{
	PageCellGroupPositionUnknown = 0,
	PageCellGroupPositionTop,
	PageCellGroupPositionBottom,
	PageCellGroupPositionMiddle,
	PageCellGroupPositionTopAndBottom
} PageCellGroupPosition;

@interface PageCellBackground : UIView
{
	PageCellGroupPosition position;
	BOOL selected;
	BOOL groupBackground;
	UIColor *strokeColor;
}

@property (nonatomic, assign) PageCellGroupPosition position;
@property (nonatomic, retain) UIColor *strokeColor;

+ (PageCellGroupPosition)positionForIndexPath:(NSIndexPath *)anIndexPath inTableView:(UITableView *)aTableView;
- (id)initSelected:(BOOL)isSelected grouped:(BOOL)isGrouped;

@end





