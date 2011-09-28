//
//  SurveyorAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorOneAnswerCell.h"
#import "NUSectionVC.h"

@implementation SurveyorOneAnswerCell

//
// accessibilityLabel
//
// Make sure people using VoiceOver can use the view correctly
//
// returns the description of this cell (i.e. Label followed by TextField value)
//
- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@", self.textLabel.text];
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
	self.imageView.image = [[(NUSectionVC *)aTableView.delegate responsesForIndexPath:anIndexPath] lastObject] ? [UIImage imageNamed:@"dotted"] : [UIImage imageNamed:@"undotted"];
	self.textLabel.text = [dataObject objectForKey:@"text"];
  
}
@end
