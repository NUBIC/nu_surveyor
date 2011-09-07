//
//  TextFieldCell.m
//  TableDesignRevisited
//
//  Created by Matt Gallagher on 2010/01/23.
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

#import "TextFieldCell.h"
#import "PageViewController.h"

@implementation TextFieldCell

@synthesize textField;

//
// dealloc
//
// Need to release the textField and label when done
//
- (void)dealloc
{
	[textField release];
	textField = nil;
	[label release];
	label = nil;

	[super dealloc];
}

//
// accessibilityLabel
//
// Make sure people using VoiceOver can use the view correctly
//
// returns the description of this cell (i.e. Label followed by TextField value)
//
- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@ %@", label.text, textField.text];
}

//
// finishConstruction
//
// Completes construction of the cell.
//
- (void)finishConstruction
{
	[super finishConstruction];
	
	CGFloat height = self.contentView.bounds.size.height;
	CGFloat width = self.contentView.bounds.size.width;
	CGFloat fontSize = [UIFont labelFontSize] - 2;
	CGFloat labelWidth = 100;
	CGFloat margin = 8;
	CGFloat heightPadding = 8;

	self.selectionStyle = UITableViewCellSelectionStyleNone;

    textField =
		[[UITextField alloc]
			initWithFrame:
				CGRectMake(
					labelWidth + 2 * margin,
					0, 
					width - labelWidth - 2.0 * margin,
					height - 1)];
	textField.font = [UIFont systemFontOfSize:fontSize];
	textField.textAlignment = UITextAlignmentLeft;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.backgroundColor = [UIColor clearColor];
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	[self.contentView addSubview:textField];

	label = 
		[[UILabel alloc]
			initWithFrame:
				CGRectMake(
					margin,
					floor(0.5 * (height - fontSize - heightPadding)),
					labelWidth,
					fontSize + heightPadding)];
	label.textAlignment = UITextAlignmentRight;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:fontSize];
	label.highlightedTextColor = [UIColor colorWithRed:0.50 green:0.2 blue:0.0 alpha:1.0];
	label.textColor = [UIColor blackColor];
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0, 1);

	[self.contentView addSubview:label];
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
	[super configureForData:dataObject tableView:aTableView indexPath:anIndexPath];
	
	label.text = [(NSDictionary *)dataObject objectForKey:@"label"];
	textField.text = [(NSDictionary *)dataObject objectForKey:@"value"];
	textField.placeholder = [(NSDictionary *)dataObject objectForKey:@"placeholder"];

	textField.delegate = (PageViewController *)aTableView.delegate;
}

@end
