//
//  PageCell.m
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

#import "PageCell.h"
//#import "PageCellBackground.h"
#import "PageViewController.h"

const CGFloat PageCellDefaultRowHeight = 44.0;

@implementation PageCell

@synthesize content;

//
// reuseIdentifier
//
// returns the reuseIdentifier for the class (which is normally the Class name
//	since instances of the class should be reusable for different rows).
//
+ (NSString *)reuseIdentifier
{
	return NSStringFromClass(self);
}

//
// nibName
//
// returns the name of the nib file from which the cell is loaded.
//
+ (NSString *)nibName
{
	return nil;
}

//
// style
//
// returns the cell style used (will have no effect if a nib is used.
//
+ (UITableViewCellStyle)style
{
	return UITableViewCellStyleDefault;
}

//
// pageCellBackgroundClass
//
// returns the subclass of PageCellBackground used for drawing the background
//
//+ (Class)pageCellBackgroundClass
//{
//	return [PageCellBackground class];
//}

//
// rowHeight
//
// returns the height for rows of this cell. The default implementation tries
//	to load the NIB file and get the height from the NIB's view. If the NIB
//	isn't set, then it returns the default row height.
//
+ (CGFloat)rowHeight
{
	static CFMutableDictionaryRef rowHeightsForClasses = nil;
	
	NSNumber *rowHeight =
		rowHeightsForClasses ?
			(NSNumber *)CFDictionaryGetValue(rowHeightsForClasses, self) : nil;
	if (rowHeight == nil)
	{
		NSString *nibName = [[self class] nibName];
		if (nibName)
		{
			if (rowHeightsForClasses == nil)
			{
				rowHeightsForClasses =
					CFDictionaryCreateMutable(
						kCFAllocatorDefault,
						0,
						&kCFTypeDictionaryKeyCallBacks,
						&kCFTypeDictionaryValueCallBacks);
			}
			
			PageCell *cellInstance = [[[[self class] alloc] init] autorelease];
			[[NSBundle mainBundle]
				loadNibNamed:nibName
				owner:cellInstance
				options:nil];
			UIView *cellContentView = cellInstance->content;
			NSAssert(cellContentView != nil, @"NIB file loaded but content property not set.");
			rowHeight = [NSNumber numberWithFloat:cellContentView.bounds.size.height];
			CFDictionaryAddValue(rowHeightsForClasses, self, rowHeight);
		}
		else
		{
			return PageCellDefaultRowHeight;
		}
	}
	
	return [rowHeight floatValue];
}

//
// init
//
// Initializer.
//
- (id)init
{
	UITableViewCellStyle style = [[self class] style];
	NSString *identifier = [[self class] reuseIdentifier];

	if (self = [super initWithStyle:style reuseIdentifier:identifier])
	{
		NSString *nibName = [[self class] nibName];
		if (nibName)
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			contentArray =
				[[[NSBundle mainBundle]
					loadNibNamed:nibName
					owner:self
					options:nil]
				retain];
			[pool drain];
			NSAssert(content != nil, @"NIB file loaded but content property not set.");
			[self addSubview:content];
		}

		[self finishConstruction];
	}
	return self;
}

//
// contentView
//
// Overrides the internal behavior to set the contentView
//
// returns the content view as loaded from the nib file.
//
- (UIView *)contentView
{
	if (content)
	{
		return content;
	}
	return [super contentView];
}

//
// prepareForReuse
//
// Normally used to unhighlight cells. Deliberately suppressed.
// 
- (void)prepareForReuse
{
}

//
// finishConstruction
//
// Invoked after the cell is constructed to perform any post load tasks
//
- (void)finishConstruction
{
}

//
// configureForData:tableView:indexPath:
//
// Invoked when the cell is given data. All fields should be updated to reflect
// the data.
//
// Parameters:
//    dataObject - the dataObject (can be nil for data-less objects)
//    aTableView - the tableView (passed in since the cell may not be in the
//		hierarchy)
//    anIndexPath - the indexPath of the cell
//
- (void)configureForData:(id)dataObject
	tableView:(UITableView *)aTableView
	indexPath:(NSIndexPath *)anIndexPath
{
//	if (!self.backgroundView)
//	{
//		PageCellBackground *cellBackgroundView =
//			[[[[[self class] pageCellBackgroundClass] alloc]
//				initSelected:NO
//				grouped:aTableView.style == UITableViewStyleGrouped]
//			autorelease];
//		self.backgroundView = cellBackgroundView;
//		PageCellBackground *cellSelectionView =
//			[[[[[self class] pageCellBackgroundClass] alloc]
//				initSelected:YES
//				grouped:aTableView.style == UITableViewStyleGrouped]
//			autorelease];
//		self.selectedBackgroundView = cellSelectionView;
//	}
//	
//	if (aTableView.style == UITableViewStyleGrouped)
//	{
//		PageCellGroupPosition position = 
//			[PageCellBackground positionForIndexPath:anIndexPath inTableView:aTableView];
//		((PageCellBackground *)self.backgroundView).position = position;
//		((PageCellBackground *)self.selectedBackgroundView).position = position;
//	}
}

//
// handleSelectionInTableView:
//
// An overrideable method to handle behavior when a row is selected.
// Default implementation just deselects the row.
//
// Parameters:
//    aTableView - the table view from which the row was selected
//
- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	[(PageViewController *)aTableView.delegate
		performSelector:@selector(deselect)
		withObject:nil
		afterDelay:0.25];
}

//
// setSelected:animated:
//
// The default setSelected:animated: method sets the textLabel and
// detailTextLabel background to white when invoked (or at least, it did in iOS
// 3 -- I haven't checked in a while). This override undoes that
// and sets their background to clearColor.
//
// Parameters:
//    selected - is the cell being selected
//    animated - should the selection be animated
//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];

	if (!content)
	{
		UIColor *clearColor = [UIColor clearColor];
		if (![self.textLabel.backgroundColor isEqual:clearColor])
		{
			self.textLabel.backgroundColor = [UIColor clearColor];
		}
		if (![self.detailTextLabel.backgroundColor isEqual:clearColor])
		{
			self.detailTextLabel.backgroundColor = [UIColor clearColor];
		}
	}
}

//
// dealloc
//
// Release instance memory
//
- (void)dealloc
{
	[contentArray release];

	[super dealloc];
}

@end
