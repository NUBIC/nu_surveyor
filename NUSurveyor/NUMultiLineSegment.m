//
//  NUMultiLineSegment.m
//  NUSurveyor
//
//  Created by Jacob Van Order on 3/28/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUMultiLineSegment.h"

#import <QuartzCore/QuartzCore.h>

#define MINIMUM_FONT_SIZE 11.0f
#define VERTICAL_PADDING 2.0f

#define DARK_TEXT_COLOR colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0

typedef NS_ENUM(NSInteger, NUMultiLineSegmentedControlSegment) {
    NUMultiLineSegmentedControlSegmentAny = 0,
    NUMultiLineSegmentedControlSegmentLeft = 1,   // The capped, leftmost segment. Only applies when numSegments > 1.
    NUMultiLineSegmentedControlSegmentCenter = 2, // Any segment between the left and rightmost segments. Only applies when numSegments > 2.
    NUMultiLineSegmentedControlSegmentRight = 3,  // The capped,rightmost segment. Only applies when numSegments > 1.
    NUMultiLineSegmentedControlSegmentAlone = 4,  // The standalone segment, capped on both ends. Only applies when numSegments = 1.
};

@interface NUMultiLineSegment ()

@property (nonatomic, assign) NUMultiLineSegmentedControlSegment backgroundType;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, assign) NSUInteger segmentIndex;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation NUMultiLineSegment

#pragma mark delegate methods

#pragma mark customization

-(instancetype)initWithTitle:(NSString *)title atIndex:(NSUInteger)idx {
    if (self = [super init]) {
        _segmentIndex = idx;
        self.backgroundColor = [UIColor clearColor];
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.exclusiveTouch = NO;
        [self addSubview:_backgroundImageView];
        
        _mainLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _mainLabel.backgroundColor = [UIColor clearColor];
        _mainLabel.font = [UIFont boldSystemFontOfSize:18];
        _mainLabel.textColor = [UIColor DARK_TEXT_COLOR];
        _mainLabel.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.0f];
        _mainLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _mainLabel.numberOfLines = 0;
        _mainLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.text = title;
        _mainLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        _mainLabel.userInteractionEnabled = YES;
        _mainLabel.exclusiveTouch = NO;
        [self addSubview:_mainLabel];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped)];
        [self addGestureRecognizer:_tapGesture];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)changeBackgroundToCapsule {
    self.backgroundType = NUMultiLineSegmentedControlSegmentAlone;
}

-(void)changeBackgroundToLeftEndcap {
    self.backgroundType = NUMultiLineSegmentedControlSegmentLeft;
}

-(void)changeBackgroundToRightEndcap {
    self.backgroundType = NUMultiLineSegmentedControlSegmentRight;
}

-(void)changeBackgroundToMiddle {
    self.backgroundType = NUMultiLineSegmentedControlSegmentCenter;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self setNeedsDisplay];
    [self invertTextColorBasedOnSelection:isSelected];
}

-(void) invertTextColorBasedOnSelection:(BOOL)isSelected {
    if (isSelected == YES) {
        self.mainLabel.textColor = [UIColor whiteColor];
        self.mainLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    }
    else {
        self.mainLabel.textColor = [UIColor DARK_TEXT_COLOR];
        self.mainLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    }
}

-(void) wasTapped {
    if (self.isSelected == YES) {
        return;
    }
    [self.delegate segment:self wasSelectedAtIndex:self.segmentIndex];
}

-(void)selectSegment {
    self.isSelected = YES;
}


-(void)deselectSegment {
    self.isSelected = NO;
}

-(void)increaseHeightTo:(CGFloat)newHeight {
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newHeight);
    self.mainLabel.center = CGPointMake(ceil(CGRectGetMidX(self.bounds)), ceil(CGRectGetMidY(self.bounds)));
}

-(void)decreaseFontSizeTo:(CGFloat)newFontSize {
    self.mainLabel.font = [UIFont boldSystemFontOfSize:newFontSize];
    [self.mainLabel sizeToFit];
    self.mainLabel.center = CGPointMake(ceil(CGRectGetMidX(self.bounds)), ceil(CGRectGetMidY(self.bounds)));
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundImageView.frame = self.bounds;
    CGFloat oldFontSize = self.mainLabel.font.pointSize;
        for (int i = oldFontSize; i >= MINIMUM_FONT_SIZE; i--) {
            self.mainLabel.frame = CGRectIntegral(CGRectInset(self.bounds, VERTICAL_PADDING, VERTICAL_PADDING));
            self.mainLabel.font = [UIFont boldSystemFontOfSize:i];
            [self.mainLabel sizeToFit];
            self.mainLabel.center = CGPointMake(ceil(CGRectGetMidX(self.bounds)), ceil(CGRectGetMidY(self.bounds)));
            self.mainLabel.frame = CGRectIntegral(self.mainLabel.frame);
            self.mainLabel.bounds = CGRectIntegral(self.mainLabel.bounds);
            if (self.mainLabel.bounds.size.height + (VERTICAL_PADDING * 2) <= self.bounds.size.height) {
                break;
            }
        }
    if (self.mainLabel.font.pointSize < oldFontSize) {
        [self.delegate segment:self isUsingFontSize:self.mainLabel.font.pointSize];
    }

    if (self.mainLabel.bounds.size.height > self.bounds.size.height) {
        [self.delegate segment:self increasedHeightTo:self.mainLabel.bounds.size.height + (VERTICAL_PADDING * 2)];
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    
    CGSize cornerSize = CGSizeMake(10.0f, 10.0f);
    UIBezierPath *path;
    switch (self.backgroundType) {
        case NUMultiLineSegmentedControlSegmentAlone:
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerSize];
            break;
        case NUMultiLineSegmentedControlSegmentCenter:
            path = [UIBezierPath bezierPathWithRect:self.bounds];
            break;
        case NUMultiLineSegmentedControlSegmentLeft:
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:cornerSize];
            break;
        case NUMultiLineSegmentedControlSegmentRight:
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:cornerSize];
            break;
        default:
            break;
    }
    
    NSArray *gradientFillValueArray = @[];
    UIColor *strokeColor = nil;
    CGFloat colors[8];
    
    if (self.isSelected == NO) {
        gradientFillValueArray = @[@(255.0f/255.0f), @(255.0f/255.0f), @(255.0f/255.0f), @1.0f,   //white
                                   @(200.0f/255.0f), @(200.0f/255.0f), @(200.0f/255.0f), @1.0f];  //light gray
        strokeColor = [UIColor colorWithWhite:(166.0f/255.0f) alpha:1.0f];
    }
    else {
        gradientFillValueArray = @[@(40.0f/255.0f), @(88.0f/255.0f), @(172.0f/255.0f), @1.0f,   //dark blue
                                   @(111.0f/255.0f), @(169.0f/255.0f), @(252.0f/255.0f), @1.0f];  //lighter blue
        strokeColor = [UIColor colorWithRed:(12.0f/255.0f) green:(58.0f/255.0f) blue:(137.0f/255.0f) alpha:0.8f];
    }
    
    for (int i = 0; i < [gradientFillValueArray count]; i++) {
        colors[i] = [gradientFillValueArray[i] floatValue];
    }
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(context);
    CGContextAddPath(context, path.CGPath);
    [strokeColor setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
}

#pragma mark prototyping

#pragma mark stock code

@end
