//
//  NUMultiButton.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUMultiButton.h"
#import "NUButton.h"

@interface NUMultiButton()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) NSArray *titles;
@end

@implementation NUMultiButton
@synthesize buttons = _buttons, titles = _titles;

#define _padding	4.0
#define _spacing	1.0

- (id)init {
  //  DLog(@"init");
  if ((self = [super init])){
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.buttons = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void) setItems:(NSArray *)titles {
  if (![self.titles isEqualToArray:titles]) {
    self.titles = titles;
    [self clearItems];
    for(NSString *title in titles){
      
      NUButton *button = [[NUButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 32.0)];
      [button setTitle:title forState:UIControlStateNormal];
      
      [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:button];
      [self.buttons addObject:button];
    }

  }
}
- (void) clearItems {
  // removes UIButton and UIButton subclass subviews
  for (UIView *subview in self.subviews) {
    if([subview isKindOfClass:[UIButton class]]) {
      [subview removeFromSuperview];
    } else {
      // Do nothing - not a UIButton or subclass instance
    }
  }
  self.buttons = [[NSMutableArray alloc] init];
}
- (NSIndexSet *) selectedIndexes{
  // block syntax
  // ^int (int x) { return x*3; }
  return [self.buttons indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){ 
    return ((UIButton *)obj).selected;
  }];
}
- (void) selectIndexes:(NSIndexSet *)indexes {
  // block syntax
  // ^int (int x) { return x*3; }
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    if (idx < self.buttons.count) {
      ((UIButton *)[self.buttons objectAtIndex:idx]).selected = YES;
      [self performSelector:@selector(highlightButton:) withObject:(UIButton *)[self.buttons objectAtIndex:idx] afterDelay:0];
    }
  }];
}
- (void)buttonPressed:(id)sender {
  ((UIButton *)sender).selected = !((UIButton *)sender).selected;
  [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void) highlightButton:(UIButton *)button {
  [button setHighlighted:button.selected];
}
- (void)layoutSubviews {
  //	NSLog(@"subviews: %@", self.subviews);
	CGFloat x = 0, y = _spacing;
	CGFloat maxX = 0, lastHeight = 0;
	CGFloat maxWidth = self.frame.size.width;
	for (UIView* subview in self.subviews) {
    //		NSLog(@"x %f, y %f, maxX %f, lastHeight %f, maxWidth %f", x, y, maxX, lastHeight, maxWidth);
		if (x + subview.frame.size.width > maxWidth) {
			x = 0;
			y += lastHeight + _spacing;
		}
		subview.frame = CGRectMake(x, y, subview.frame.size.width, subview.frame.size.height);
		x += subview.frame.size.width + _padding;
		if (x > maxX) {
			maxX = x;
		}
		lastHeight = subview.frame.size.height;
	}
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxX, y+lastHeight);
  //	NSLog(@"x:%f y:%f w:%f h:%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
@end
