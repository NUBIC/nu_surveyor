//
//  NUMultiLineSegment.h
//  NUSurveyor
//
//  Created by Jacob Van Order on 3/28/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NUMultiLineSegmentProtocol;

@interface NUMultiLineSegment : UILabel

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CGFloat *labelHeight;

@property (nonatomic, weak) id<NUMultiLineSegmentProtocol> delegate;

-(instancetype)initWithTitle:(NSString *)title atIndex:(NSUInteger)idx;

-(void)changeBackgroundToCapsule;
-(void)changeBackgroundToLeftEndcap;
-(void)changeBackgroundToRightEndcap;
-(void)changeBackgroundToMiddle;

-(void)selectSegment;
-(void)deselectSegment;

-(void)increaseHeightTo:(CGFloat)newHeight;
-(void)decreaseFontSizeTo:(CGFloat)newFontSize;

@end

@protocol NUMultiLineSegmentProtocol <NSObject>

-(void)segment:(NUMultiLineSegment *)segment wasSelectedAtIndex:(NSUInteger)idx;
-(void)segment:(NUMultiLineSegment *)segment increasedHeightTo:(CGFloat)heightFloat;
-(void)segment:(NUMultiLineSegment *)segment isUsingFontSize:(CGFloat)fontSize;

@end
