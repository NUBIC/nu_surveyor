//
//  PageViewController.m
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

#import "PageViewController.h"
#import "PageCell.h"

static const double PageViewControllerTextAnimationDuration = 0.33;

@implementation PageViewCellDescription

@synthesize cellClass;
@synthesize cellData;

//
// initWithCellClass:andData:
//
// Initializes a PageViewCellDescription with class and data
//
// Parameters:
//    aClass - Class for the row's table view cell
//    anObject - data for the object (can be nil)
//
// returns the initialized object
//
- (id)initWithCellClass:(Class)aClass andData:(id)anObject
{
	self = [super init];
	if (self)
	{
		cellClass = aClass;
		cellData = [anObject retain];
	}
	
	return self;
}

//
// description
//
// returns a string representation of the class (helpful for debugging)
//
- (NSString *)description
{
	NSString *inherited = [super description];
	NSString *classDescription = [cellClass description];
	NSString *dataDescription = [cellData description];
	
	return [NSString stringWithFormat:
		@"%@ {\n\tcellClass: %@,\n\tcellDescription: %@\n}",
		inherited, classDescription, dataDescription];
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[cellData release];
	[super dealloc];
}

@end

@implementation PageViewController

@dynamic tableView;
@synthesize currentTextField;
@synthesize constantRowHeight;
@synthesize useCustomHeaders;

#pragma mark ### Implement some of the UITableViewController behavior on our UIViewController

//
// tableView
//
// This method connects to the view property by default.
//
- (UITableView *)tableView
{
	return tableView;
}

//
// setTableView
//
// This method connects to the view property by default.
//
- (void)setTableView:(UITableView *)aTableView
{
	[aTableView retain];
	[tableView release];
	tableView = aTableView;

	[tableView setDelegate:self];
	[tableView setDataSource:self];
	
	if (!self.nibName && !self.view)
	{
		self.view = aTableView;
	}
}

//
// loadView
//
// Construct a UITableView as the view and connect the dataSource and delegate.
//
- (void)loadView
{
	if (self.nibName &&
		[[NSBundle mainBundle] URLForResource:self.nibName withExtension:@"nib"])
	{
		[super loadView];
		return;
	}
	
	UITableView *aTableView =
		[[[UITableView alloc]
			initWithFrame:CGRectZero
			style:UITableViewStyleGrouped]
		autorelease];
	self.view = aTableView;
	self.tableView = aTableView;
}

#pragma mark ### Methods for accessing/manipulating the tableSections array

//
// sectionAtIndex:
//
// Readonly accessor for a section
//
// Parameters:
//    aSectionIndex - the index of the section
//
// returns a section array
//
- (NSArray *)sectionAtIndex:(NSInteger)aSectionIndex
{
	if ([tableSections count] <= aSectionIndex)
	{
		return nil;
	}
	
	return [tableSections objectAtIndex:aSectionIndex];
}

//
// allDataInSection:
//
// Parameters:
//    aSectionIndex - the section in the tableSections to consider
//
// returns an array of all cellData objects for the given section.
//
- (NSArray *)allDataInSection:(NSInteger)aSectionIndex
{
	if ([tableSections count] <= aSectionIndex)
	{
		return nil;
	}
	
	//
	// Use the valueForKey method on the array to generate an array of the
	// cellData properties
	//
	return [[tableSections objectAtIndex:aSectionIndex] valueForKey:@"cellData"];
}

//
// dataForRow:inSection:
//
// Accesses the cached data for the specified row
//
// Parameters:
//    aRowIndex - the index of the row in its section
//    aSectionIndex - the index of the row's section
//
// returns the data for the row
//
- (id)dataForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
{
	if ([tableSections count] <= aSectionIndex)
	{
		return nil;
	}
	
	NSArray *section = [tableSections objectAtIndex:aSectionIndex];
	if ([section count] <= aRowIndex)
	{
		return nil;
	}
	
	return [[section objectAtIndex:aRowIndex] cellData];
}

//
// setData:forRow:inSection:
//
// Accesses the cached data for the specified row
//
// Parameters:
//    aRowIndex - the index of the row in its section
//    aSectionIndex - the index of the row's section
//
// returns the data for the row
//
- (void)setData:(id)dataObject forRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
{
	[[[tableSections objectAtIndex:aSectionIndex] objectAtIndex:aRowIndex]
		setCellData:dataObject];
	NSIndexPath *indexPath =
		[NSIndexPath indexPathForRow:aRowIndex inSection:aSectionIndex];
	PageCell *cell =
		(PageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell configureForData:dataObject tableView:self.tableView indexPath:indexPath];
}

//
// refreshCellForRow:inSection:
//
// Accesses the cached data for the specified row
//
// Parameters:
//    aRowIndex - the index of the row in its section
//    aSectionIndex - the index of the row's section
//
// returns the data for the row
//
- (void)refreshCellForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
{
	NSDictionary *dataObject =
		[self dataForRow:aRowIndex inSection:aSectionIndex];
	NSIndexPath *indexPath =
		[NSIndexPath indexPathForRow:aRowIndex inSection:aSectionIndex];
	PageCell *cell =
		(PageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[cell configureForData:dataObject tableView:self.tableView indexPath:indexPath];
}

//
// classForRow:inSection:
//
// Accesses the view class for the specified row
//
// Parameters:
//    aRowIndex - the index of the row in its section
//    aSectionIndex - the index of the row's section
//
// returns the data for the row
//
- (Class)classForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
{
	if ([tableSections count] <= aSectionIndex)
	{
		return nil;
	}
	
	NSArray *section = [tableSections objectAtIndex:aSectionIndex];
	if ([section count] <= aRowIndex)
	{
		return nil;
	}
	
	return [[section objectAtIndex:aRowIndex] cellClass];
}

//
// addSectionAtIndex:
//
// Adds a section object at the index. NSMutableArray will give an exception
// if the index is out of the tableSection bounds.
//
// Parameters:
//    aSectionIndex - the index of the new section
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)addSectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation
{
	if (!tableSections)
	{
		tableSections = [[NSMutableArray alloc] init];
	}
	
	if (aSectionIndex > [tableSections count])
	{
		aSectionIndex = [tableSections count];
	}
	
	[tableSections
		insertObject:[[[NSMutableArray alloc] init] autorelease]
		atIndex:aSectionIndex];
		
	if (animation != UITableViewRowAnimationNone)
	{
		[self.tableView
			insertSections:[NSIndexSet indexSetWithIndex:aSectionIndex]
			withRowAnimation:animation];
	}
	
	[self headerSectionsReordered];
}

//
// addRowAtIndex:inSection:cellClass:cellData:
//
// Convenience method to create a PageViewCellDescription and insert it at the
// specified location
//
// Parameters:
//    newRowIndex - row index for the cell
//    aSectionIndex - section index for the cell
//    aClass - Class for the cell
//    cellData - data for the cell
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)addRowAtIndex:(NSInteger)aRowIndex
	inSection:(NSInteger)aSectionIndex
	cellClass:(Class)aClass
	cellData:(id)cellData
	withAnimation:(UITableViewRowAnimation)animation
{
	if (!tableSections)
	{
		tableSections = [[NSMutableArray alloc] init];
	}
	if ([tableSections count] == 0)
	{
		[self addSectionAtIndex:0 withAnimation:animation];
	}
	
	if (aSectionIndex > [tableSections count] - 1)
	{
		aSectionIndex = [tableSections count] - 1;
	}
	NSMutableArray *tableSection = [tableSections objectAtIndex:aSectionIndex];
	if (aRowIndex > [tableSection count])
	{
		aRowIndex = [tableSection count];
	}
	
	[tableSection
		insertObject:
			[[[PageViewCellDescription alloc] initWithCellClass:aClass andData:cellData] autorelease]
		atIndex:aRowIndex];
	
	if (tableView.style == UITableViewStyleGrouped)
	{
		if (aRowIndex == [tableSection count] - 1 && aRowIndex > 0)
		{
			[self refreshCellForRow:aRowIndex - 1 inSection:aSectionIndex];
		}
	}

	if (animation != UITableViewRowAnimationNone)
	{
		[self.tableView
			insertRowsAtIndexPaths:
				[NSArray arrayWithObject:
					[NSIndexPath
						indexPathForRow:aRowIndex
						inSection:aSectionIndex]]
			withRowAnimation:animation];
	}
}

//
// appendRowToSection:cellClass:cellData:
//
// Convenience method to create a PageViewCellDescription and insert it at the
// specified location
//
// Parameters:
//    newRowIndex - row index for the cell
//    aSectionIndex - section index for the cell
//    aClass - Class for the cell
//    cellData - data for the cell
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)appendRowToSection:(NSInteger)aSectionIndex
	cellClass:(Class)aClass
	cellData:(id)cellData
	withAnimation:(UITableViewRowAnimation)animation
{
	[self
		addRowAtIndex:NSIntegerMax
		inSection:aSectionIndex
		cellClass:aClass
		cellData:cellData
		withAnimation:animation];
}

//
// emptySectionAtIndex:
//
// Removes all the rows in a section
//
// Parameters:
//    aSectionIndex - section index for removal
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)emptySectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation
{
	if (aSectionIndex >= [tableSections count])
	{
		if (aSectionIndex == [tableSections count])
		{
			[self addSectionAtIndex:0 withAnimation:animation];
		}
		return;
	}
	
	NSMutableArray *indexPaths = [NSMutableArray array];
	int i;
	int count = [[tableSections objectAtIndex:aSectionIndex] count];
	for (i = 0; i < count; i++)
	{
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:aSectionIndex]];
	}

	[[tableSections objectAtIndex:aSectionIndex] removeAllObjects];
		
	if (count && animation != UITableViewRowAnimationNone)
	{
		[self.tableView
			deleteRowsAtIndexPaths:indexPaths
			withRowAnimation:animation];
	}
}

//
// removeSectionAtIndex:
//
// Removes all the rows in a section
//
// Parameters:
//    aSectionIndex - section index for removal
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)removeSectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation
{
	if (aSectionIndex >= [tableSections count])
	{
		return;
	}
	
	[tableSections removeObjectAtIndex:aSectionIndex];
		
	if (animation != UITableViewRowAnimationNone)
	{
		[self.tableView
			deleteSections:[NSIndexSet indexSetWithIndex:aSectionIndex]
			withRowAnimation:animation];
	}

	[self headerSectionsReordered];
}

//
// removeSectionAtIndex:
//
// Removes all the rows in a section
//
// Parameters:
//    aSectionIndex - section index for removal
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)removeAllSectionsWithAnimation:(UITableViewRowAnimation)animation
{
	while ([tableSections count] > 0)
	{
		[self removeSectionAtIndex:0 withAnimation:animation];
	}
}

//
// removeRowAtIndex:inSection:withAnimation:
//
// Removes all the rows in a section
//
// Parameters:
//    aSectionIndex - section index for removal
//    animation - the animation to use for the operation (specifying
//		UITableViewRowAnimationNone will prevent the update entirely)
//
- (void)removeRowAtIndex:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation
{
	if (aSectionIndex >= [tableSections count])
	{
		return;
	}
	
	NSMutableArray *section = [tableSections objectAtIndex:aSectionIndex];
	
	if (aRowIndex >= [section count])
	{
		return;
	}
	
	[section removeObjectAtIndex:aRowIndex];
		
	if (animation != UITableViewRowAnimationNone)
	{
		[self.tableView
			deleteRowsAtIndexPaths:
				[NSArray arrayWithObject:
					[NSIndexPath indexPathForRow:aRowIndex inSection:aSectionIndex]]
			withRowAnimation:animation];
	}
}

#pragma mark ### Implementations of some typical/userful default behavior

//
// deselect
//
// Method to deselect the current item. Useful for timed callbacks.
//
- (void)deselect
{
	[self.tableView
		deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
		animated:YES];
}

//
// shouldAutorotateToInterfaceOrientation:
//
// Change the rotation of the view.
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] &&
			[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
		{
			return YES;
		}
		
		return NO;
	}
	
	return YES;
}

//
// refresh:
//
// Does nothing by default but an override, in conjunction with the show/hide
// loading indicator methods can create a reloadable view.
//
// Parameters:
//    sender - normally the bar button item that sent the message
//
- (void)refresh:(id)sender
{
}

//
// showLoadingIndicator
//
// Creates a loading indicator and adds it on the right of the navigation
// bar.
//
- (void)showLoadingIndicator
{
	UIActivityIndicatorView *indicator =
		[[[UIActivityIndicatorView alloc]
			initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
		autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
		[[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
	[self.navigationItem setRightBarButtonItem:progress animated:YES];
}

//
// hideLoadingIndicator
//
// Replaces the loading indicator with a refresh button
//
- (void)hideLoadingIndicator
{
	UIActivityIndicatorView *indicator =
		(UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem;
	if ([indicator isKindOfClass:[UIActivityIndicatorView class]])
	{
		[indicator stopAnimating];
	}
	UIBarButtonItem *refreshButton =
		[[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
			target:self
			action:@selector(refresh:)]
		autorelease];
	[self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
}

//
// viewDidLoad
//
// On viewDidLoad, always clean out everything and start again (since viewDidUnload
// may have been called).
//
- (void)viewDidLoad
{
	NSIndexSet *indexSet =
		[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tableSections count])];
	[self removeAllSectionsWithAnimation:UITableViewRowAnimationNone];
	[self.tableView
		deleteSections:indexSet
		withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ### Link many of the delegate methods into the tableSections array

//
// respondsToSelector:
//
// Change the row layout for large classes to have a fixed row height.
//
// Parameters:
//    aSelector - if tableView:heightForRowAtIndexPath:, respond NO for large tables
//
// returns super implementation for everything except tableView:heightForRowAtIndexPath:
//
- (BOOL)respondsToSelector:(SEL)aSelector
{
	if (aSelector == @selector(tableView:heightForRowAtIndexPath:))
	{
		return !constantRowHeight;
	}
	
	if (aSelector == @selector(tableView:viewForHeaderInSection:) ||
		aSelector == @selector(tableView:heightForHeaderInSection:))
	{
		return useCustomHeaders;
	}
	
	return [super respondsToSelector:aSelector];
}

//
// setConstantRowHeight:
//
// Toggle the tableView delegate when the constantRowHeight value changes.
//
// Parameters:
//    newValue - the new value for constantRowHeight
//
- (void)setConstantRowHeight:(BOOL)newValue
{
	constantRowHeight = newValue;
	
	//
	// Clear the delegate so the tableView knows to recheck if our
	// respondsToSelector: responses have changed.
	//
	tableView.delegate = nil;
	tableView.delegate = self;
}

//
// setUseCustomHeaders:
//
// Toggle the tableView delegate when the constantRowHeight value changes.
//
// Parameters:
//    newValue - the new value for constantRowHeight
//
- (void)setUseCustomHeaders:(BOOL)newValue
{
	useCustomHeaders = newValue;
	
	//
	// Clear the delegate so the tableView knows to recheck if our
	// respondsToSelector: responses have changed.
	//
	tableView.delegate = nil;
	tableView.delegate = self;
}

//
// tableView:viewForHeaderInSection:
//
// Sets the heading for a section
//
// Parameters:
//    aTableView - the table view
//    aSection - the section
//
// returns the heading text
//
- (UIView *)tableView:(UITableView *)aTableView
	viewForHeaderInSection:(NSInteger)section
{
	NSString *title = [self tableView:aTableView titleForHeaderInSection:section];
	if ([title length] == 0)
	{
		return nil;
	}
	
	if ([headerViews count] != [tableSections count])
	{
		if (!headerViews)
		{
			headerViews = [[NSMutableArray alloc] initWithCapacity:[tableSections count]];
		}
		
		while ([headerViews count] <= section)
		{
			BOOL isGrouped = tableView.style == UITableViewStyleGrouped;
			
			const CGFloat PageViewSectionGroupHeaderHeight = 36;
			const CGFloat PageViewSectionPlainHeaderHeight = 22;
			const CGFloat PageViewSectionGroupHeaderMargin = 20;
			const CGFloat PageViewSectionPlainHeaderMargin = 5;

			CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width,
				isGrouped ? PageViewSectionGroupHeaderHeight : PageViewSectionPlainHeaderHeight);
			
			UIView *headerView = [[[UIView alloc] initWithFrame:frame] autorelease];
			headerView.backgroundColor =
				isGrouped ?
					[UIColor clearColor] :
					[UIColor colorWithRed:0.46 green:0.52 blue:0.56 alpha:0.5];
			
			frame.origin.x = isGrouped ?
				PageViewSectionGroupHeaderMargin : PageViewSectionPlainHeaderMargin;
			frame.size.width -= 2.0 * frame.origin.x;

			UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
			label.text = [self tableView:aTableView titleForHeaderInSection:[headerViews count]];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = isGrouped ?
				[UIColor colorWithRed:0.3 green:0.33 blue:0.43 alpha:1.0] :
				[UIColor whiteColor];
			label.shadowColor = isGrouped ? [UIColor whiteColor] : [UIColor darkGrayColor];
			label.shadowOffset = CGSizeMake(0, 1.0);
			label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + (isGrouped ? 0 : 1)];
			label.lineBreakMode = UILineBreakModeMiddleTruncation;
			label.adjustsFontSizeToFitWidth = YES;
			label.minimumFontSize = 12.0;
			[headerView addSubview:label];
			
			[headerViews addObject:headerView];
		}
	}

	return [headerViews objectAtIndex:section];
}

//
// tableView:heightForHeaderInSection:
//
// Sets the height of the section
//
// Parameters:
//    tableView - the tableView
//    section - the section
//
// returns STMTableSectionHeaderHeight
//
- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section
{
	NSString *title = [self tableView:aTableView titleForHeaderInSection:section];
	if ([title length] == 0)
	{
		return 0;
	}
	
	return
		[[self tableView:aTableView viewForHeaderInSection:section] bounds].size.height;
}

//
// headerSectionsReordered
//
// Clears the headerViews array
//
- (void)headerSectionsReordered
{
	[headerViews release];
	headerViews = nil;
}

//
// tableView:heightForRowAtIndexPath:
//
// Sets the height of the row to the height of the cell by default
//
// Parameters:
//    aTableView - our table view
//    anIndexPath - the indexPath of the row
//
// returns the height
//
- (CGFloat)tableView:(UITableView *)aTableView
	heightForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
	Class cellClass = [self classForRow:anIndexPath.row inSection:anIndexPath.section];
	return [cellClass rowHeight];
}

//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return [tableSections count];
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	if (!tableSections)
	{
		return 0;
	}
	return [[tableSections objectAtIndex:section] count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
	NSArray *rows = [tableSections objectAtIndex:anIndexPath.section];
	PageViewCellDescription *description = [rows objectAtIndex:anIndexPath.row];
	NSString *cellIdentifier = [description.cellClass reuseIdentifier];
	
	PageCell *cell =
		(PageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[[description.cellClass alloc] init] autorelease];
	}
	
	[cell
		configureForData:description.cellData
		tableView:aTableView
		indexPath:anIndexPath];
	
	return cell;
}

//
// tableView:titleForHeaderInSection:
//
// Sets the section headers
//
// Parameters:
//    aTableView - the table view
//    section - the section
//
// returns the section header as a string
//
- (NSString *)tableView:(UITableView *)aTableView
	titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

//
// tableView:didSelectRowAtIndexPath:
//
// Handle row selection
//
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
	PageCell *cell = (PageCell *)[aTableView cellForRowAtIndexPath:anIndexPath];
	if (![cell isKindOfClass:[PageCell class]])
	{
		return;
	}
	
	[cell handleSelectionInTableView:aTableView];
}

#pragma mark ### Handle the sliding/scrolling of the view when the keyboard appears

//
// keyboardWillHideNotification:
//
// Slides the view back when done editing.
//
- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
	if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.view.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}

//
// keyboardWillShowNotification:
//
// Slides the view to avoid the keyboard.
//
- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
	//
	// Remove any previous view offset.
	//
	[self keyboardWillHideNotification:nil];
	
	//
	// Only animate if the text field is part of the hierarchy that we manage.
	//
	UIView *parentView = [currentTextField superview];
	while (parentView != nil && ![parentView isEqual:self.view])
	{
		parentView = [parentView superview];
	}
	if (parentView == nil)
	{
		//
		// Not our hierarchy... ignore.
		//
		return;
	}
	
	CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
			convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
			fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		
		//
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid
		// deprecated warnings in the compiler.
		//
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
			convertRect:keyboardRect
			fromView:topLevelView];
	}
	
	CGRect viewFrame = self.view.frame;

	textFieldAnimatedDistance = 0;
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
		[self.view setFrame:viewFrame];
		[UIView commitAnimations];
	}
	
	const CGFloat PageViewControllerTextFieldScrollSpacing = 40;

	CGRect textFieldRect =
		[self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];
}

//
// viewWillAppear:
//
// Watches for keyboard animation when visible.
//
// Parameters:
//    animated - Will the appearance be animated.
//
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(keyboardWillShowNotification:)
		name:UIKeyboardWillShowNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(keyboardWillHideNotification:)
		name:UIKeyboardWillHideNotification
		object:nil];
}

//
// viewWillDisappear:
//
// Deanimates the keyboard on dismiss.
//
// Parameters:
//    animated - is the transition animated
//
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter]
		removeObserver:self
		name:UIKeyboardWillShowNotification
		object:nil];
	[[NSNotificationCenter defaultCenter]
		removeObserver:self
		name:UIKeyboardWillHideNotification
		object:nil];

	if (currentTextField)
	{
		[self keyboardWillHideNotification:nil];
	}
}

//
// dismissKeyboard
//
// Action method to dismiss the keyboard
//
- (IBAction)dismissKeyboard:(id)sender
{
	[currentTextField resignFirstResponder];
}

//
// textFieldShouldBeginEditing:
//
// Changes the default to YES and resign firstResponder.
//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.currentTextField = textField;
	return YES;
}

//
// textFieldShouldReturn:
//
// Changes the default to YES and resign firstResponder.
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

//
// textFieldShouldBeginEditing:
//
// Changes the default to YES and resign firstResponder.
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([currentTextField isEqual:textField])
	{
		self.currentTextField = nil;
	}
}

//
// dealloc
//
// Release instance memory
//
- (void)dealloc
{
	[tableSections release];
	tableSections = nil;

	[currentTextField release];
	currentTextField = nil;
	
	//
	// Nil out the delegate and dataSource fields because sometimes
	// the tableView tries to contact us again as it's getting deleted
	// (and after we've been deleted).
	//
	tableView.delegate = nil;
	tableView.dataSource = nil;

	[tableView release];
	tableView = nil;

	[super dealloc];
}


@end

