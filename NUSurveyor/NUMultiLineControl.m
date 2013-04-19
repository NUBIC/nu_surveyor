//
//  NUMultiLineControl.m
//  NUSurveyor
//
//  Created by Jacob Van Order on 3/28/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUMultiLineControl.h"
#import "NUMultiLineSegment.h"

#define DEFAULT_CELL_HEIGHT 44.0f
#define VERTICAL_PADDING    2.0f
#define MINIMUM_FONT_SIZE   11.0f
#define DEFAULT_FONT_SIZE   18.0f

@protocol NUMultiLineSegmentProtocol;

@interface NUMultiLineControl () <NUMultiLineSegmentProtocol>

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, assign) CGFloat segmentFontSize;

-(void)segmentSelected:(NSUInteger)segIndex;

@end

@implementation NUMultiLineControl

#pragma mark delegate methods

-(void)segment:(NUMultiLineSegment *)segment wasSelectedAtIndex:(NSUInteger)idx {
    [self segmentSelected:idx];
}

-(void)segment:(NUMultiLineSegment *)bigSegment increasedHeightTo:(CGFloat)heightFloat {
    if (heightFloat > self.frame.size.height) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, heightFloat);
        for (NUMultiLineSegment *segment in self.segments) {
            [segment increaseHeightTo:heightFloat];
        }
    }
}

-(void)segment:(NUMultiLineSegment *)teenyFontSegment isUsingFontSize:(CGFloat)fontSize {
    if (fontSize < self.segmentFontSize) {
        for (NUMultiLineSegment *segment in self.segments) {
            if ([segment isEqual:teenyFontSegment] == NO) {
                [segment decreaseFontSizeTo:fontSize];
            }
        }
    }
}

#pragma mark customization

-(void)segmentSelected:(NSUInteger)segIndex {
    self.selectedSegmentIndex = segIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    if ([self.segments count] >= selectedSegmentIndex) {
        NUMultiLineSegment *selectedSegment = self.segments[selectedSegmentIndex];
        [selectedSegment selectSegment];
        for (NUMultiLineSegment *segment in self.segments) {
            if ([segment isEqual:selectedSegment] == NO && segment.isSelected == YES) {
                [segment deselectSegment];
            }
        }
    }
}

-(void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment {
    NUMultiLineSegment *newSegment = [[NUMultiLineSegment alloc] initWithTitle:title atIndex:segment];
    
    NSMutableArray *mutableSegments = [self.segments mutableCopy];
    [mutableSegments insertObject:newSegment atIndex:segment];
    self.segments = [NSArray arrayWithArray:mutableSegments];
}

-(void)removeAllSegments {
    for (NUMultiLineSegment *segment in [self subviews]) {
        [segment removeFromSuperview];
    }
    self.segments = @[];
}

-(NSUInteger)numberOfSegments  {
    return [self.segments count];
}

+(CGFloat)heightForAnswers:(NSArray *) answerArray forSegmentControlWidth:(CGFloat)widthSize {
        
    NSString *longAnswer = [[answerArray sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [@(string1.length) compare:@(string2.length)];
    }] lastObject];
    
    CGSize newSize = CGSizeZero;
    for (int i = DEFAULT_CELL_HEIGHT; i >= MINIMUM_FONT_SIZE; i--) {
        newSize = [longAnswer sizeWithFont:[UIFont boldSystemFontOfSize:i] constrainedToSize:CGSizeMake(widthSize - (VERTICAL_PADDING * 2), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        if (newSize.height + (VERTICAL_PADDING * 2) <= DEFAULT_CELL_HEIGHT) {
            break;
        }
    }
    
    return ceil(newSize.height) + (VERTICAL_PADDING * 4);
}

#pragma mark prototyping

#pragma mark stock code

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect brandNewRectSize = CGRectZero;
    CGRect remainingRectSize = CGRectZero;
    float percentage = (self.bounds.size.width / [self.segments count]);
    CGRectDivide(self.bounds, &brandNewRectSize, &remainingRectSize, percentage, CGRectMinXEdge);
    
    for (NUMultiLineSegment *segment in self.segments) {
        [segment removeFromSuperview];
        NSUInteger index = [self.segments indexOfObject:segment];
        segment.delegate = self;
        segment.frame = CGRectIntegral(CGRectMake((0.0f + (brandNewRectSize.size.width * index)), 0.0f, brandNewRectSize.size.width, brandNewRectSize.size.height));
        [self addSubview:segment];
        
        if (index == 0 && [self.segments count] != 0) {
            [segment changeBackgroundToLeftEndcap];
        }
        else if (index == ([self.segments count] - 1) && [self.segments count] != 0) {
            [segment changeBackgroundToRightEndcap];
        }
        else if ([self.segments count] != 0) {
            [segment changeBackgroundToMiddle];
        }
        else {
            [segment changeBackgroundToCapsule];
        }
    }
}

-(instancetype)init {
    
    if (self = [super init]) {
        self.segmentFontSize = DEFAULT_FONT_SIZE;
    }
    
    return self;
}


@end