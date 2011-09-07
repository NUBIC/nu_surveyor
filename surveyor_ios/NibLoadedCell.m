//
//  NibLoadedCell.m
//  TableDesignRevisited
//
//  Created by Matt Gallagher on 2010/12/19.
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

#import "NibLoadedCell.h"
#import "PageViewController.h"
#import "DetailViewController.h"

@implementation NibLoadedCell

@synthesize label;

//
// nibName
//
// returns the name of the nib file from which the cell is loaded.
//
+ (NSString *)nibName
{
	return @"NibCell";
}

//
// handleSelectionInTableView:
//
// Performs the appropriate action when the cell is selected
//
- (void)handleSelectionInTableView:(UITableView *)aTableView
{
	[super handleSelectionInTableView:aTableView];
	
//	NSInteger rowIndex = [aTableView indexPathForCell:self].row;
//	[((PageViewController *)aTableView.delegate).navigationController
//		pushViewController:[[[DetailViewController alloc] initWithRowIndex:rowIndex] autorelease]
//		animated:YES];
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
//    anIndexPath - the indexPath of the 'cell
//
- (void)configureForData:(id)dataObject
	tableView:(UITableView *)aTableView
	indexPath:(NSIndexPath *)anIndexPath
{
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	
	label.text = dataObject;
}


@end
