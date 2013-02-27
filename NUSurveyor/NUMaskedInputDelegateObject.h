//
//  NUMaskedInputDelegateObject.h
//  CSMaskedTextField
//
//  Created by Jacob Van Order on 2/11/13.
//  Copyright (c) 2013 CTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUMaskedInputDelegateObject : NSObject <UITextFieldDelegate>

@property (nonatomic, strong, readonly) NSString *mask;
@property (nonatomic, strong, readonly) NSString *placeholder;

@property (nonatomic, weak) id regularDelegate;

-(instancetype) initWithMask:(NSString *)mask andPlaceholder:(NSString *)placeholder;

@end
