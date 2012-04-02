//
//  NUAnyCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUAnyCell.h"
#import <QuartzCore/QuartzCore.h>

@interface NUAnyCell()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) CAShapeLayer *checkLayer;
@end

@implementation NUAnyCell
@synthesize sectionTVC = _sectionTVC, checked = _checked;
@synthesize checkLayer = _checkLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
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
      self.checkLayer.backgroundColor = [[UIColor clearColor] CGColor];
      self.checkLayer.frame = CGRectMake(44.0, 0.0, 44.0, 44.0);
      
      CGMutablePathRef path = CGPathCreateMutable();
      CGPathMoveToPoint(path, Nil, 12.0, 20.0);
      CGPathAddLineToPoint(path, Nil, 21.0, 27.0);
      CGPathAddArcToPoint(path, Nil, 26.0, 15.0, 33.0, 8.0, 40.0);
      
      self.checkLayer.path = path;
      CGPathRelease(path);
      
      self.checkLayer.strokeColor = [UIColor blackColor].CGColor;
      self.checkLayer.fillColor = [UIColor clearColor].CGColor;
      self.checkLayer.lineCap = kCALineCapRound;
      self.checkLayer.lineWidth = 3.0;
      [self.layer insertSublayer:self.checkLayer atIndex:1];
    }

  }
  self.checked = YES;
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - NUCell
- (NSString *)accessibilityLabel{
	return [NSString stringWithFormat:@"NUAnyCell %@", self.textLabel.text];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	self.sectionTVC = (NUSectionTVC *)tableView.delegate;
	[[self.sectionTVC responsesForIndexPath:indexPath] lastObject] ? [self check] : [self uncheck];
	self.textLabel.text = [GRMustacheTemplate renderObject:self.sectionTVC.renderContext
                                              fromString:[dataObject objectForKey:@"text"]
                                                   error:NULL];
}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	if ([[self.sectionTVC responsesForIndexPath:indexPath] lastObject]) {
		[self.sectionTVC deleteResponseForIndexPath:indexPath];
		[(NUAnyCell *)[tableView cellForRowAtIndexPath:indexPath] uncheck];
	} else {
		[self.sectionTVC newResponseForIndexPath:indexPath];
		[(NUAnyCell *)[tableView cellForRowAtIndexPath:indexPath] check];
	}
  [self.sectionTVC.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat groupedCellWidth = self.frame.size.width - 88.0;
  self.textLabel.frame = CGRectMake(44.0, 
                                    self.textLabel.frame.origin.y, 
                                    groupedCellWidth - 44.0 - 10.0, // -10.0 to miss right rounded edges
                                    self.textLabel.frame.size.height);  
}
- (void)check {
  [self.checkLayer setHidden:NO];
  self.checked = YES;
}
- (void)uncheck {
  [self.checkLayer setHidden:YES];
  self.checked = NO;
}
@end
