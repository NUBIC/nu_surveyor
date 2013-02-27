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

@property (nonatomic, strong, readwrite) NSString *mask;
@property (nonatomic, strong, readwrite) NSString *placeholder;

-(NSString *)generateGenericPlaceholderFromMask:(NSString *)maskString;
-(NSString *)lengthenPlaceholder:(NSString *)placeholderString ToLengthOfMask:(NSString *)maskString;

@end

@implementation NUMaskedInputDelegateObject

#pragma mark customization

-(instancetype) initWithMask:(NSString *)mask andPlaceholder:(NSString *)placeholder {
    
    self = [super init];
    if (self) {
        self.mask = mask;
        self.placeholder = (placeholder != nil) ? placeholder : [self generateGenericPlaceholderFromMask:mask];
        if (self.placeholder.length < self.mask.length) {
            self.placeholder = [self lengthenPlaceholder:self.placeholder ToLengthOfMask:self.mask];
        }
    }
    return self;    
}

-(NSString *) generateGenericPlaceholderFromMask:(NSString *)maskString {
    NSString *retString = @"";
    for (int i = 0; i < maskString.length; i++) {
        unichar checkChar = [maskString characterAtIndex:i];
        if (checkChar == '9' || checkChar == 'a' || checkChar == '*') {
            retString = [retString stringByAppendingString:@"_"];
        }
        else {
            retString = [retString stringByAppendingString:[NSString stringWithCharacters:&checkChar length:1]];
        }
    }

    return retString;
}

-(NSString *) lengthenPlaceholder:(NSString *)placeholderString ToLengthOfMask:(NSString *)maskString {
    NSString *retString = placeholderString;
    for (int i = placeholderString.length; i < maskString.length; i++) {
            retString = [retString stringByAppendingString:@"_"];
    }

    return retString;
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
            characterToReplaceString = [[NSMutableAttributedString alloc] initWithString:[self.placeholder substringWithRange:range] attributes:maskAttributeDictionary];
        }
        
        int deletedLetterCount = 0;
        for (NSUInteger i = range.location; i > 0; i--) {
            NSString *characterString = [self.mask substringWithRange:NSMakeRange(i, 1)];
            if ([characterString isEqualToString:@"9"] || [characterString isEqualToString:@"a"] || [characterString isEqualToString:@"*"] )
                break;
            else
                [characterToReplaceString insertAttributedString:[[NSAttributedString alloc] initWithString:[self.placeholder substringWithRange:NSMakeRange(i - 1, 1)] attributes:maskAttributeDictionary] atIndex:0];
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
    NSDictionary *maskAttributeDictionary = @{NSForegroundColorAttributeName :MASK_COLOR, NSFontAttributeName : TEXT_FONT};
    if (textField.text.length == 0) {
        textField.attributedText = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:maskAttributeDictionary];
        NSCharacterSet *wildCharacters = [NSCharacterSet characterSetWithCharactersInString:@"9a*"];
        NSRange nonMaskCharacterRange = [self.mask rangeOfCharacterFromSet:wildCharacters];
        UITextPosition *carretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:nonMaskCharacterRange.location];
        UITextRange *carretRange = [textField textRangeFromPosition:carretPosition toPosition:carretPosition];
        [textField setSelectedTextRange:carretRange];   
    }
    if (textField.attributedText.string.length < self.mask.length) {
        NSMutableAttributedString *attribTextString = [textField.attributedText mutableCopy];
        NSUInteger insertLength = self.mask.length - textField.attributedText.string.length;
        for (int i = 0; i < insertLength; i++) {
            NSUInteger characterIndex = textField.attributedText.string.length + i;
            unichar insertChar = [self.mask characterAtIndex:characterIndex];
            if (insertChar == '9' || insertChar == 'a' || insertChar == '*') {
                insertChar = [self.placeholder characterAtIndex:characterIndex];
            }
            NSAttributedString *insertAttribString = [[NSAttributedString alloc] initWithString:[NSString stringWithCharacters:&insertChar length:1] attributes:maskAttributeDictionary];
            [attribTextString insertAttributedString:insertAttribString atIndex:characterIndex];
        }
        textField.attributedText = [[NSAttributedString alloc] initWithAttributedString:attribTextString];
        UITextPosition *carretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:textField.attributedText.string.length - insertLength];
        UITextRange *carretRange = [textField textRangeFromPosition:carretPosition toPosition:carretPosition];
        [textField setSelectedTextRange:carretRange];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableAttributedString *attribTextString = [textField.attributedText mutableCopy];
    [attribTextString enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attribTextString.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(UIColor *colorValue, NSRange range, BOOL *stop) {
        if ([colorValue isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]] == NO) {
            for (int i = range.length; i > 0 ; i--) {
                unichar maskChar = [self.mask characterAtIndex:(range.location + i - 1)];
                if (maskChar == '9' || maskChar == 'a' || maskChar == '*') {
                    [attribTextString deleteCharactersInRange:NSMakeRange(range.location + i - 1, 1)];
                }
                else {
                    int rangeLocationInt = range.location;
                    if (rangeLocationInt + i - 2 > 0) {
                        unichar previousChar = [self.mask characterAtIndex:range.location + i - 2];
                        if (previousChar == '9' || previousChar == 'a' || previousChar == '*') {
                        NSDictionary *attribDict = [textField.attributedText attributesAtIndex:(range.location + i - 2) effectiveRange:NULL];
                            if ([[attribDict valueForKey:NSForegroundColorAttributeName] isEqual:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]] == NO) {
                                [attribTextString deleteCharactersInRange:NSMakeRange(range.location + i - 1, 1)];
                            }
                        }
                    }
                }
            }
        }
    }];
    
    textField.attributedText = [[NSAttributedString alloc] initWithAttributedString:attribTextString];
    
    if (self.regularDelegate) {
        [self.regularDelegate textFieldDidEndEditing:textField];
    }
}

-(void) dealloc {
    self.regularDelegate = nil;
}
@end
