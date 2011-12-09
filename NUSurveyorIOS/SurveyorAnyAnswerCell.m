//
//  SurveyorAnyAnswerCell.m
//  surveyor_ios
//
//  Created by Mark Yoon on 9/12/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorAnyAnswerCell.h"
#import "NUSectionVC.h"
#import <QuartzCore/QuartzCore.h>

@interface SurveyorAnyAnswerCell()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) CAShapeLayer *checkLayer;
@end

@implementation SurveyorAnyAnswerCell
@synthesize checkLayer;

//
// finishConstruction
//
// Completes construction of the cell.
//
- (void)finishConstruction {
	[super finishConstruction];
	self.textLabel.text = nil;
  CAShapeLayer *boxLayer = [[CAShapeLayer alloc] init];
  boxLayer.backgroundColor = [[UIColor clearColor] CGColor];
  boxLayer.frame = CGRectMake(44.0, 0.0, 44.0, 44.0);
  
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, CGRectMake(14.0, 14.0, 16.0, 16.0));
  boxLayer.path = path;
  CGPathRelease(path);

  boxLayer.strokeColor = [UIColor lightGrayColor].CGColor;
  boxLayer.fillColor = [UIColor whiteColor].CGColor;
  boxLayer.lineWidth = 2.0;

  [self.layer insertSublayer:boxLayer atIndex:0];
  
  if (!self.checkLayer) {
    self.checkLayer = [[CAShapeLayer alloc] init];
    checkLayer.backgroundColor = [[UIColor clearColor] CGColor];
    checkLayer.frame = CGRectMake(44.0, 0.0, 44.0, 44.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, Nil, 12.0, 20.0);
    CGPathAddLineToPoint(path, Nil, 21.0, 27.0);
    CGPathAddArcToPoint(path, Nil, 26.0, 15.0, 33.0, 8.0, 40.0);
    
    checkLayer.path = path;
    CGPathRelease(path);
    
    checkLayer.strokeColor = [UIColor blackColor].CGColor;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineWidth = 3.0;
    [self.layer insertSublayer:checkLayer atIndex:1];
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

	self.textLabel.text = [dataObject objectForKey:@"text"];
  [self performSelector:[[(NUSectionVC *)aTableView.delegate responsesForIndexPath:anIndexPath] lastObject] ? @selector(check) : @selector(uncheck)];

}
- (void)check {
  [checkLayer setHidden:NO];
}
- (void)uncheck {
  [checkLayer setHidden:YES];
}



@end
