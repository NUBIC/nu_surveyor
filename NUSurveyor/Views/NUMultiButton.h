//
//  NUMultiButton.h
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NUMultiButton : UIControl

- (void) setItems:(NSArray *)titles;
- (void) clearItems;
- (NSIndexSet *) selectedIndexes;
- (void) selectIndexes:(NSIndexSet *)indexes;

@end
