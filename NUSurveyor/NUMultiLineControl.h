//
//  NUMultiLineControl.h
//  NUSurveyor
//
//  Created by Jacob Van Order on 3/28/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUMultiLineControl : UIControl

@property (nonatomic, assign) NSUInteger selectedSegmentIndex;
@property (nonatomic, assign, readonly) NSUInteger numberOfSegments;

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment;
-(void)removeAllSegments;

+(CGFloat)heightForAnswers:(NSArray *)answerArray forSegmentControlWidth:(CGFloat)widthSize;

@end
