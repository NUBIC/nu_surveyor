//
//  SurveyorQuestionView.m
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorQuestionView.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+Resize.h"
#import "PickerViewController.h"

@interface SurveyorQuestionView ()
  // http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
  @property (nonatomic,retain) UIButton* pickerButton;
  @property (nonatomic,retain) UIToolbar* surveyorKeyboardAccessory;
  - (UIToolbar *)surveyorKeyboardAccessory:(DetailViewController *)dvc;
  + (int) nextNumber;
@end

@implementation SurveyorQuestionView
@synthesize questionResponse, pickerButton, surveyorKeyboardAccessory;

static int qCount; // http://jongampark.wordpress.com/2009/04/25/class-variable-for-objective-c-and-c/

+ (void) initialize{
  qCount = 0;
}
+ (int) nextNumber{
  qCount++;
  return qCount;
}
+ (void) resetNumber{
  qCount = 0;
}

- (id)initWithFrame:(CGRect)frame questionResponse:(QuestionResponse *)qr controller:(DetailViewController *)dvc showNumber:(BOOL)showNumber {
  if((self = [super initWithFrame:frame])) {
    self.questionResponse = qr;
    float height = 5.0;
    if ([qr.json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *question_text_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 24.0)];
      
      if ([@"label" isEqual:[qr.json valueForKey:@"type"]]) {
        showNumber = false;
      }
      
      NSMutableString *txt = [[[NSMutableString alloc] init] autorelease];
      [txt appendString: showNumber ? [NSString stringWithFormat:@"%d) ", [[self class] nextNumber]] : @""];
      [txt appendString: [qr.json valueForKey:@"post_text"] ? [NSString stringWithFormat:@"%@ | %@", [qr.json valueForKey:@"post_text"], [qr.json valueForKey:@"text"]] : [qr.json valueForKey:@"text"]];
      question_text_label.text = txt;
      
      [question_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
      question_text_label.font = [UIFont boldSystemFontOfSize:19.0];
      
      height += question_text_label.frame.size.height + 5.0;
      [self addSubview:question_text_label];
      [question_text_label release];
    }
    if ([questionResponse.pick isEqualToString:@"one"] && questionResponse.answers) {
      // pick one (radio buttons)
            
      if ([@"dropdown" isEqual:[qr.json valueForKey:@"type"]]) {
        self.pickerButton = [questionResponse setupPickerButton];
        pickerButton.frame = CGRectMake(0.0, height, 100.0, 35.0);

        [self addSubview:pickerButton];
        height += pickerButton.frame.size.height;
        
      }else{
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width/2, 44.0 * [questionResponse.answers count]) style:UITableViewStylePlain];
        tableView.scrollEnabled = FALSE; 
        tableView.delegate = questionResponse;
        tableView.dataSource = questionResponse;
        [self addSubview:tableView];
        height += tableView.frame.size.height;
      }
      
    }else if([questionResponse.pick isEqualToString:@"any"] && questionResponse.answers){
      // pick any (checkboxes)
      UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width/2, 44.0 * [questionResponse.answers count]) style:UITableViewStylePlain];
      tableView.scrollEnabled = FALSE; 
      tableView.delegate = questionResponse;
      tableView.dataSource = questionResponse;
      [self addSubview:tableView];
      height += tableView.frame.size.height;
    }else{
      // pick none, default
      float max_text_width = 0.0;
      float max_post_text_width = 0.0;
      
      for (NSDictionary *answer in qr.answers) {
        // loop to find maximum widths of text and post-text (+5.0 for extra padding)
        if ([answer valueForKey:@"text"]) {
          max_text_width = MAX(max_text_width, 5.0+[[answer valueForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(999.0, 44.0)].width);
        }
        if ([answer valueForKey:@"post_text"]) {
          max_post_text_width = MAX(max_text_width, 5.0+[[answer valueForKey:@"post_text"] sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(999.0, 44.0)].width);
        }
        max_text_width = MIN(max_text_width, frame.size.width/3);
        max_post_text_width = MIN(max_post_text_width, frame.size.width/3);
      }

      if(questionResponse.answers){     
        for (NSDictionary *answer in questionResponse.answers) {
          float max_height = 0.0;
          float x_cursor = 0.0;

          // add help text
          if ([answer valueForKey:@"help"]) {
            UILabel *answer_help_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 24.0)];
            answer_help_label.text = [answer valueForKey:@"help"];
            answer_help_label.textColor = [UIColor darkGrayColor];
            [answer_help_label setUpMultiLineVerticalResizeWithFontSize:14.0];
            
            height += answer_help_label.frame.size.height;
            [self addSubview:answer_help_label];
            [answer_help_label release];
          }
          // add answer text
          if ([answer valueForKey:@"text"]) {
            UILabel *answer_text_label = [[UILabel alloc] initWithFrame:CGRectMake(x_cursor, height, max_text_width, 24.0)];
            answer_text_label.text = [answer valueForKey:@"text"];
            [answer_text_label setUpMultiLineVerticalResizeWithFontSize:16.0];
            
            x_cursor += answer_text_label.frame.size.width;
            max_height = MAX(max_height, answer_text_label.frame.size.height);
            [self addSubview:answer_text_label];
            [answer_text_label release];
          }
          
          if([@"text" isEqual:[answer valueForKey:@"type"]]){
            // response type: text
            height += max_height;
            x_cursor = 0.0;
            max_height = 0.0;
            
            UITextView *text_response = [[UITextView alloc] initWithFrame:CGRectMake(x_cursor, height, frame.size.width/2, 128.0)];
            text_response.delegate = dvc;
            text_response.returnKeyType = UIReturnKeyDone;
            text_response.inputAccessoryView = [self surveyorKeyboardAccessory:dvc];
            [dvc.editViews addObject:text_response];
            
            text_response.font = [UIFont systemFontOfSize:16.0];            
            text_response.layer.cornerRadius = 8.0;
            text_response.layer.borderWidth = 1.0;
            text_response.layer.borderColor = [[UIColor grayColor] CGColor];
            
            x_cursor += text_response.frame.size.width;
            max_height = MAX(max_height, text_response.frame.size.height);
            [self addSubview:text_response];
            [text_response release];
          }else if ([@"string" isEqual:[answer valueForKey:@"type"]]) {
            // response type: string
            UITextField *string_response = [[UITextField alloc] initWithFrame:CGRectMake(x_cursor, height, frame.size.width/2, 31.0)];
            string_response.delegate = dvc;
            string_response.returnKeyType = UIReturnKeyDone;
            string_response.inputAccessoryView = [self surveyorKeyboardAccessory:dvc];
            [dvc.editViews addObject:string_response];
            
            string_response.font = [UIFont systemFontOfSize:16.0];
            string_response.borderStyle = UITextBorderStyleRoundedRect;
            
            x_cursor += string_response.frame.size.width;
            max_height = MAX(max_height, string_response.frame.size.height);
            [self addSubview:string_response];
            [string_response release];
          }else if([@"integer" isEqual:[answer valueForKey:@"type"]]){
            // response type: integer
            UITextField *integer_response = [[UITextField alloc] initWithFrame:CGRectMake(x_cursor, height, frame.size.width/6, 31.0)];
            integer_response.delegate = dvc;
            integer_response.returnKeyType = UIReturnKeyDone;
            integer_response.inputAccessoryView = [self surveyorKeyboardAccessory:dvc];
            [dvc.editViews addObject:integer_response];

            integer_response.font = [UIFont systemFontOfSize:16.0];
            integer_response.textAlignment = UITextAlignmentRight;
            integer_response.keyboardType = UIKeyboardTypeNumberPad;
            integer_response.borderStyle = UITextBorderStyleRoundedRect;

            x_cursor += integer_response.frame.size.width;
            max_height = MAX(max_height, integer_response.frame.size.height);
            [self addSubview:integer_response];
            [integer_response release];
          }else if([@"float" isEqual:[answer valueForKey:@"type"]]){
            // response type: float
            UITextField *float_response = [[UITextField alloc] initWithFrame:CGRectMake(x_cursor, height, frame.size.width/4, 31.0)];
            float_response.delegate = dvc;
            float_response.returnKeyType = UIReturnKeyDone;
            float_response.inputAccessoryView = [self surveyorKeyboardAccessory:dvc];
            [dvc.editViews addObject:float_response];
            
            float_response.font = [UIFont systemFontOfSize:16.0];
            float_response.textAlignment = UITextAlignmentRight;
            float_response.keyboardType = UIKeyboardTypeDecimalPad;
            float_response.borderStyle = UITextBorderStyleRoundedRect;
            
            x_cursor += float_response.frame.size.width;
            max_height = MAX(max_height, float_response.frame.size.height);
            [self addSubview:float_response];
            [float_response release];
          }
          
          // add answer post text
          if ([answer valueForKey:@"post_text"]) {
            UILabel *answer_post_text_label = [[UILabel alloc] initWithFrame:CGRectMake(x_cursor, height, max_post_text_width, 24.0)];
            answer_post_text_label.text = [answer valueForKey:@"post_text"];
            [answer_post_text_label setUpMultiLineVerticalResizeWithFontSize:16.0];
            
            max_height = MAX(max_height, answer_post_text_label.frame.size.height);
            [self addSubview:answer_post_text_label];
            [answer_post_text_label release];
          }
          
          height += max_height;
        }
      }
    }    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+5.0);
  }
  return self;
}

- (id)initGroupWithFrame:(CGRect)frame questionResponse:(QuestionResponse *)qr controller:(DetailViewController *)dvc {
  self = [super initWithFrame:frame];
  if (self) {
    self.questionResponse = qr;
    float height = 5.0;
    if ([qr.json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *group_text_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 44.0)];
      group_text_label.text = [NSString stringWithFormat:@"%d) %@", [[self class] nextNumber], [qr.json valueForKey:@"text"]];;
      [group_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
      group_text_label.font = [UIFont boldSystemFontOfSize:19.0];
      height += group_text_label.frame.size.height + 5.0;
      [self addSubview:group_text_label];
      [group_text_label release];
    }
    if ([@"grid" isEqual:[qr.json valueForKey:@"type"]] && [qr.json valueForKey:@"questions"] && [qr.json valueForKey:@"answers"]) {
      // grid
      float max_text_width = 0.0;
      float max_post_text_width = 0.0;
      
      for (NSDictionary *question in [qr.json objectForKey:@"questions"]) {
        // loop to find maximum widths of text and post-text (+5.0 for extra padding)
        if ([question valueForKey:@"text"]) {
          max_text_width = MAX(max_text_width, 5.0+[[question valueForKey:@"text"] sizeWithFont:[UIFont boldSystemFontOfSize:19.0] constrainedToSize:CGSizeMake(999.0, 44.0)].width);
        }
        if ([question valueForKey:@"post_text"]) {
          max_post_text_width = MAX(max_text_width, 5.0+[[question valueForKey:@"post_text"] sizeWithFont:[UIFont boldSystemFontOfSize:19.0] constrainedToSize:CGSizeMake(999.0, 44.0)].width);
        }
        max_text_width = MIN(max_text_width, frame.size.width/3);
        max_post_text_width = MIN(max_post_text_width, frame.size.width/3);
      }
      
      for (NSDictionary *question in [qr.json objectForKey:@"questions"]) {
        float max_height = 0.0;
        float x_cursor = 0.0;
        
        // text
        if ([question valueForKey:@"text"]) {
          // Question text label wraps and expands height to fit
          UILabel *question_text_label = [[UILabel alloc] initWithFrame:CGRectMake(x_cursor, height, max_text_width, 44.0)];
          question_text_label.text = [question valueForKey:@"text"];
          
          [question_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
          question_text_label.font = [UIFont boldSystemFontOfSize:19.0];
          question_text_label.textAlignment = UITextAlignmentRight;
          
          max_height = MAX(max_height, question_text_label.frame.size.height);
          x_cursor += question_text_label.frame.size.width;
          [self addSubview:question_text_label];
          [question_text_label release];
        }
        
        // segment
        UISegmentedControl *pickOneSegment = [[UISegmentedControl alloc] initWithItems:[[qr.json valueForKey:@"answers"] valueForKey:@"text"]];
        pickOneSegment.frame = CGRectMake(x_cursor, height, MIN(frame.size.width - max_text_width - max_post_text_width, pickOneSegment.frame.size.width), pickOneSegment.frame.size.height);
        max_height = MAX(max_height, pickOneSegment.frame.size.height);
        x_cursor += pickOneSegment.frame.size.width;
        [self addSubview:pickOneSegment];
        [pickOneSegment release];
        
        // post text
        if ([question valueForKey:@"post_text"]) {
          // Question text label wraps and expands height to fit
          UILabel *question_post_text_label = [[UILabel alloc] initWithFrame:CGRectMake(x_cursor, height, max_post_text_width, 44.0)];
          question_post_text_label.text = [question valueForKey:@"post_text"];
          
          [question_post_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
          question_post_text_label.font = [UIFont boldSystemFontOfSize:19.0];
          
          max_height = MAX(max_height, question_post_text_label.frame.size.height);
          [self addSubview:question_post_text_label];
          [question_post_text_label release];
        }
        
        height += max_height;
        
      }
      
    }else{
      if([qr.json objectForKey:@"questions"]){
        for (NSDictionary *question in [qr.json objectForKey:@"questions"]) {
          QuestionResponse *qqr = [[QuestionResponse alloc] initWithJson:question responseSet:qr.responseSet];
          UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 44.0) questionResponse:qqr controller:dvc showNumber:false] autorelease];
          [self addSubview:q_view];
          height += q_view.frame.size.height;
        }
      }
    }
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+10.0);
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark Input accessory view
- (UIToolbar *)surveyorKeyboardAccessory:(DetailViewController *)dvc {
  if (!surveyorKeyboardAccessory) {
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 44.0);
    surveyorKeyboardAccessory = [[UIToolbar alloc] initWithFrame:accessFrame];
    surveyorKeyboardAccessory.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:dvc action:@selector(prevField)];
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:dvc action:@selector(nextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:dvc action:@selector(editViewResignFirstResponder)];
    surveyorKeyboardAccessory.items = [NSArray arrayWithObjects:prev, next, space, doneButton, nil];
    
  }
  return surveyorKeyboardAccessory;
}

- (void)dealloc
{
  [pickerButton release];
  [surveyorKeyboardAccessory release];
  [super dealloc];
}

@end
