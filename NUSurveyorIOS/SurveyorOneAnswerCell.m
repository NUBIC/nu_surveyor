//
//  SurveyorAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorOneAnswerCell.h"
#import "NUSectionVC.h"
#import <QuartzCore/QuartzCore.h>


@interface SurveyorOneAnswerCell()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) CAShapeLayer *dotLayer;
@end

@implementation SurveyorOneAnswerCell
@synthesize dotLayer;

//
// accessibilityLabel
//
// Make sure people using VoiceOver can use the view correctly
//
// returns the description of this cell (i.e. Label followed by TextField value)
//
- (NSString *)accessibilityLabel {
	return [NSString stringWithFormat:@"%@", self.textLabel.text];
}

//
// finishConstruction
//
// Completes construction of the cell.
//
- (void)finishConstruction {
  [super finishConstruction];
  if (!self.dotLayer) {
    self.dotLayer = [[CAShapeLayer alloc] init];
    dotLayer.backgroundColor = [[UIColor clearColor] CGColor];
    dotLayer.frame = CGRectMake(44.0, 0.0, 44.0, 44.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(14.0, 14.0, 16.0, 16.0));
    dotLayer.path = path;
    CGPathRelease(path);
    
    dotLayer.strokeColor = [UIColor grayColor].CGColor;
    dotLayer.fillColor = [UIColor whiteColor].CGColor;
    dotLayer.lineWidth = 2.0;
    [self.layer insertSublayer:dotLayer atIndex:0];
  }
}
- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat groupedCellWidth = self.frame.size.width - 88.0;
  self.textLabel.frame = CGRectMake(44.0, 
                                    self.textLabel.frame.origin.y, 
                                    groupedCellWidth - 44.0,
                                    self.textLabel.frame.size.height);  
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

	self.textLabel.text = [dataObject objectForKey:@"text"];
  [self performSelector:[[(NUSectionVC *)aTableView.delegate responsesForIndexPath:anIndexPath] lastObject] ? @selector(dot) : @selector(undot)];
}
- (void)dot {
  dotLayer.strokeColor = [[UIColor blackColor] CGColor];
  dotLayer.fillColor = [[UIColor blackColor] CGColor];
  [dotLayer setNeedsDisplay];
}
- (void)undot {
  dotLayer.strokeColor = [UIColor grayColor].CGColor;
  dotLayer.fillColor = [UIColor whiteColor].CGColor;
  [dotLayer setNeedsDisplay];
}
@end
