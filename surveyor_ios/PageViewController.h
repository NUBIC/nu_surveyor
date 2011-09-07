//
//  PageViewController.h
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

@interface PageViewController : UIViewController
	<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
	IBOutlet UITableView *tableView;
	NSMutableArray *tableSections;
	UITextField *currentTextField;
	CGFloat textFieldAnimatedDistance;
	NSMutableArray *headerViews;
	BOOL constantRowHeight;
	BOOL useCustomHeaders;
}

@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) BOOL constantRowHeight;
@property (nonatomic, assign) BOOL useCustomHeaders;

- (NSArray *)sectionAtIndex:(NSInteger)aSectionIndex;
- (id)dataForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex;
- (NSArray *)allDataInSection:(NSInteger)aSectionIndex;
- (void)setData:(id)dataObject forRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex;
- (void)refreshCellForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex;
- (Class)classForRow:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex;
- (void)addSectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation;
- (void)removeRowAtIndex:(NSInteger)aRowIndex inSection:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation;
- (void)removeAllSectionsWithAnimation:(UITableViewRowAnimation)animation;
- (void)appendRowToSection:(NSInteger)aSectionIndex
	cellClass:(Class)aClass
	cellData:(id)cellData
	withAnimation:(UITableViewRowAnimation)animation;
- (void)addRowAtIndex:(NSInteger)aRowIndex
	inSection:(NSInteger)aSectionIndex
	cellClass:(Class)aClass
	cellData:(id)cellData
	withAnimation:(UITableViewRowAnimation)animation;
- (void)emptySectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation;
- (void)removeSectionAtIndex:(NSInteger)aSectionIndex
	withAnimation:(UITableViewRowAnimation)animation;
- (IBAction)dismissKeyboard:(id)sender;
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;
- (void)refresh:(id)sender;
- (void)headerSectionsReordered;
- (NSString *)tableView:(UITableView *)aTableView subTitleForHeaderInSection:(NSInteger)section;

@end

//
// PageViewCellDescription is the class used to store Class and data pairs for
// table rows.
//
@interface PageViewCellDescription : NSObject
{
	Class cellClass;
	id cellData;
}

@property (nonatomic, assign, readonly) Class cellClass;
@property (nonatomic, retain) id cellData;

@end

