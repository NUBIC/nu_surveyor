//
//  NUMaskedInputDelegateObject.m
//  CSMaskedTextField
//
//  Created by Jacob Van Order on 2/11/13.
//  Copyright (c) 2013 CTC. All rights reserved.
//

#import "NUMaskedInputDelegateObject.h"

#define MASK_COLOR [UIColor lightGrayColor]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_FONT [UIFont fontWithName:@"Helvetica" size:13.0f]

@interface NUMaskedInputDelegateObject ()

@property (nonatomic, strong) NSString *mask;
@property (nonatomic, strong) NSString *placeholder;

@end

@implementation NUMaskedInputDelegateObject

#pragma mark customization

-(instancetype) initWithMask:(NSString *)mask andPlaceholder:(NSString *)placeholder {
    
    self = [super init];
    if (self) {
        self.mask = mask;
        self.placeholder = (placeholder != nil) ? placeholder : @"_";
    }
    return self;    
}

-(NSString *)temporaryPlaceholder {
    if (_temporaryPlaceholder == nil)  {
        NSString *temporaryText = [NSString stringWithString:self.mask];
        temporaryText = [temporaryText stringByReplacingOccurrencesOfString:@"9" withString:self.placeholder];
        temporaryText = [temporaryText stringByReplacingOccurrencesOfString:@"a" withString:self.placeholder];
        temporaryText = [temporaryText stringByReplacingOccurrencesOfString:@"*" withString:self.placeholder];
        _temporaryPlaceholder = temporaryText;
    }
    
    return _temporaryPlaceholder;
}

#pragma mark text field delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
       
    if (range.location > self.mask.length - 1) {
        return NO;
    }
    
    NSDictionary *maskAttributeDictionary = @{NSForegroundColorAttributeName : MASK_COLOR, NSFontAttributeName : TEXT_FONT};
    NSDictionary *textAttributeDictionary = @{NSForegroundColorAttributeName : TEXT_COLOR, NSFontAttributeName : TEXT_FONT};
    
    NSMutableAttributedString *currentText = [[NSMutableAttributedString alloc] initWithAttributedString:textField.attributedText];
    
    if (range.length == 1){ //to determine backspace…
        NSMutableAttributedString *characterToReplaceString = [[NSMutableAttributedString alloc] initWithString:[self.mask substringWithRange:NSMakeRange(range.location, 1)] attributes:maskAttributeDictionary];
        if ([characterToReplaceString.string isEqualToString:@"9"] || [characterToReplaceString.string isEqualToString:@"a"] || [characterToReplaceString.string isEqualToString:@"*"]) {
            characterToReplaceString = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:maskAttributeDictionary];
        }
        
        int deletedLetterCount = 0;
        for (NSUInteger i = range.location; i > 0; i--) {
            NSString *characterString = [self.mask substringWithRange:NSMakeRange(i, 1)];
            if ([characterString isEqualToString:@"9"] || [characterString isEqualToString:@"a"] || [characterString isEqualToString:@"*"] )
                break;
            else
                [characterToReplaceString insertAttributedString:[[NSAttributedString alloc] initWithString:[self.temporaryPlaceholder substringWithRange:NSMakeRange(i - 1, 1)] attributes:maskAttributeDictionary] atIndex:0];
                deletedLetterCount++;
        }
        
        [currentText replaceCharactersInRange:NSMakeRange(range.location - deletedLetterCount, deletedLetterCount + 1) withAttributedString:characterToReplaceString];
        textField.attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:currentText];
        
        int deleteLocationInt = range.location - deletedLetterCount;
        UITextPosition *carretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:deleteLocationInt];
        UITextRange *carretRange = [textField textRangeFromPosition:carretPosition toPosition:carretPosition];
        [textField setSelectedTextRange:carretRange];
        
        return NO;
    }
    
    int addedLetterCount = 0; //to skip over mask characters
    for (NSUInteger i = range.location; i < self.mask.length; i++) {
        NSString *characterString = [self.mask substringWithRange:NSMakeRange(i, 1)];
        if ([characterString isEqualToString:@"9"] || [characterString isEqualToString:@"a"] || [characterString isEqualToString:@"*"] )
            break;
        
        else
            addedLetterCount++;
    }

    NSString *maskCharacterString = [self.mask substringWithRange:NSMakeRange(range.location + addedLetterCount, 1)];
    
    BOOL characterIsLegit = NO;
    if ([maskCharacterString isEqualToString:@"9"] && [string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
        characterIsLegit = YES;
    
    else if ([maskCharacterString isEqualToString:@"a"] && [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound)
        characterIsLegit = YES;
    
    else if ([maskCharacterString isEqualToString:@"*"] && [string rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]].location != NSNotFound)
        characterIsLegit = YES;
    
    if (characterIsLegit == YES) { //2 Legit 2 Quit
        NSMutableAttributedString *inputAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:textAttributeDictionary];
        [currentText replaceCharactersInRange:NSMakeRange(range.location + addedLetterCount, 1) withAttributedString:inputAttributedString];
        textField.attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:currentText];
        
        UITextPosition *carretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:range.location + 1 + addedLetterCount];
        UITextRange *carretRange = [textField textRangeFromPosition:carretPosition toPosition:carretPosition];
        [textField setSelectedTextRange:carretRange];
    }
    
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.attributedText = [[NSMutableAttributedString alloc] initWithString:[self temporaryPlaceholder] attributes:@{NSForegroundColorAttributeName :MASK_COLOR, NSFontAttributeName : TEXT_FONT}];
        NSCharacterSet *wildCharacters = [NSCharacterSet characterSetWithCharactersInString:@"9a*"];
        NSRange nonMaskCharacterRange = [self.mask rangeOfCharacterFromSet:wildCharacters];
        UITextPosition *carretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:nonMaskCharacterRange.location];
        UITextRange *carretRange = [textField textRangeFromPosition:carretPosition toPosition:carretPosition];
        [textField setSelectedTextRange:carretRange];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.regularDelegate) {
        [self.regularDelegate textFieldDidEndEditing:textField];
    }
}

-(void) dealloc {
    self.regularDelegate = nil;
}
@end
