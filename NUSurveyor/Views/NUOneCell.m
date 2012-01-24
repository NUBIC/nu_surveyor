//
//  NUOneCell.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUOneCell.h"
#import <QuartzCore/QuartzCore.h>

@interface NUOneCell()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) CAShapeLayer *dotLayer;
@end

@implementation NUOneCell
@synthesize sectionTVC = _sectionTVC, dotLayer = _dotLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      if (!self.dotLayer) {
        self.dotLayer = [[CAShapeLayer alloc] init];
        self.dotLayer.backgroundColor = [[UIColor clearColor] CGColor];
        self.dotLayer.frame = CGRectMake(44.0, 0.0, 44.0, 44.0);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, CGRectMake(14.0, 14.0, 16.0, 16.0));
        self.dotLayer.path = path;
        CGPathRelease(path);
        
        self.dotLayer.strokeColor = [UIColor grayColor].CGColor;
        self.dotLayer.fillColor = [UIColor whiteColor].CGColor;
        self.dotLayer.lineWidth = 2.0;
        [self.layer insertSublayer:self.dotLayer atIndex:0];
      }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - NUCell

- (NSString *)accessibilityLabel
{
	return [NSString stringWithFormat:@"%@", self.textLabel.text];
}

- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  self.sectionTVC = (NUSectionTVC *)tableView.delegate;
  [[self.sectionTVC responsesForIndexPath:indexPath] lastObject] ? [self dot] : [self undot];
	self.textLabel.text = [dataObject objectForKey:@"text"];
}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
	for (int i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
		NSIndexPath *j = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
		if ([j isEqual:indexPath]) {
      [self.sectionTVC newResponseForIndexPath:j];
      [(NUOneCell *)[tableView cellForRowAtIndexPath:j] dot];
    } else {
      [self.sectionTVC deleteResponseForIndexPath:j];
      [(NUOneCell *)[tableView cellForRowAtIndexPath:j] undot];
    }
	}
  [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1];
}
- (void)deselect{
  [self setSelected:NO animated:YES];
}
- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat groupedCellWidth = self.frame.size.width - 88.0;
  self.textLabel.frame = CGRectMake(44.0, 
                                    self.textLabel.frame.origin.y, 
                                    groupedCellWidth - 44.0,
                                    self.textLabel.frame.size.height);  
}
- (void)dot {
  self.dotLayer.strokeColor = [[UIColor blackColor] CGColor];
  self.dotLayer.fillColor = [[UIColor blackColor] CGColor];
  [self.dotLayer setNeedsDisplay];
}
- (void)undot {
  self.dotLayer.strokeColor = [UIColor grayColor].CGColor;
  self.dotLayer.fillColor = [UIColor whiteColor].CGColor;
  [self.dotLayer setNeedsDisplay];
}
@end
