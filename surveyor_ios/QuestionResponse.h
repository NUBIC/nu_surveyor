//
//  QuestionResponse.h
//  surveyor_ios
//
//  Created by Mark Yoon on 7/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface QuestionResponse : NSObject <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate, UITextFieldDelegate, UITextViewDelegate> {
}
@property (nonatomic, retain) NSDictionary *json;
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSArray* answers;
@property (nonatomic, retain) NSString* pick;
@property (nonatomic, retain) NSManagedObject *responseSet;
@property (nonatomic, retain) UIButton *pickerButton;
@property (nonatomic, retain) DetailViewController *detailViewController;

- (QuestionResponse *) initWithJson:(NSDictionary *)dict responseSet:(NSManagedObject *)nsmo;
- (NSManagedObject *) responseForAnswer:(NSString *)aid;
- (void) newResponseForAnswer:(NSString *)aid;
- (void) newResponseForAnswer:(NSString *)aid value:(NSString *)value;
- (UIButton *) setupPickerButton;
- (UITextField *) setupTextFieldWithFrame:(CGRect)frame forAnswer:(NSDictionary *)answer;
- (UITextView *) setupTextViewWithFrame:(CGRect)frame forAnswer:(NSDictionary *)answer;
@end
