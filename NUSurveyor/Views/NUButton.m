//
//  NUButton.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUButton.h"

@interface NUButton()

@property (nonatomic, retain) CAGradientLayer *shineLayer;
@property (nonatomic, retain) CAGradientLayer *highlightLayer;
- (void)initLayers;
- (void)addShineLayer;
- (void)addHighlightLayer;
@end

@implementation NUButton

@synthesize shineLayer, highlightLayer;

//+ (Class)layerClass {
//  return [CAGradientLayer class];
//}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self initLayers];
  }
  return self;
}
- (void)initBorder {
  CALayer *layer = self.layer;
  layer.cornerRadius = 8.0f;
  layer.masksToBounds = YES;
  layer.borderWidth = 1.0f;
  layer.borderColor = RGBA(0.0, 0.0, 0.0, .27).CGColor;
}
- (void)initLayers {
  [self initBorder];
}

- (void)awakeFromNib {
  [self initLayers];
}
- (void)addShineLayer {
  self.shineLayer = [CAGradientLayer layer];
  shineLayer.frame = self.layer.bounds;
  shineLayer.colors = [NSArray arrayWithObjects:
                       (id)(RGB(255.0, 255.0, 255.0).CGColor),
                       (id)(RGB(229.0, 229.0, 229.0).CGColor),
                       nil];
  shineLayer.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
  [self.layer insertSublayer:shineLayer atIndex:0];
}
- (void)addHighlightLayer {
  self.highlightLayer = [CAGradientLayer layer];
  highlightLayer.frame = self.layer.bounds;
  highlightLayer.colors = [NSArray arrayWithObjects:
                           (id)(RGB(17.0, 81.0, 191.0).CGColor),
                           (id)(RGB(99, 164.0, 255.0).CGColor),
                           nil];
  highlightLayer.locations = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
  highlightLayer.hidden = YES;
  [self.layer insertSublayer:highlightLayer atIndex:1];
}
- (void)setHighlighted:(BOOL)highlight {
  highlightLayer.hidden = !highlight;
  self.titleLabel.shadowOffset = CGSizeMake(0.0f, highlight ? -1.0f : 1.0f);
  [super setHighlighted:highlight];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
  [super setTitle:title forState:state];
  
  self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
  [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self setTitleShadowColor:RGB(46.0, 100.0, 189.0) forState:UIControlStateSelected|UIControlStateHighlighted];
  [self setTitleShadowColor:RGB(46.0, 100.0, 189.0) forState:UIControlStateHighlighted];
  self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
  
  [self setTitleColor:RGB(122.0, 122.0, 122.0) forState:UIControlStateNormal];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [self setContentEdgeInsets:UIEdgeInsetsMake(7.0, 4.0, 7.0, 4.0)];
  
  [self sizeToFit];
  //  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 32.0);
  
  [self addShineLayer];
  [self addHighlightLayer];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
