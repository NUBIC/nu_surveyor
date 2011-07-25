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
  @property (nonatomic,retain) NSArray* answers;
  @property (nonatomic,retain) NSString* pick;
  @property (nonatomic,retain) UITableViewCell* selectedCell;
  @property (nonatomic,retain) PickerViewController* pickerContent;
  @property (nonatomic,retain) UIPopoverController* popover;
  @property (nonatomic,retain) UIButton* pickerButton;
  @property (nonatomic,retain) UIToolbar* surveyorKeyboardAccessory;
  - (UIToolbar *)surveyorKeyboardAccessory:(DetailViewController *)dvc;
  + (int) nextNumber;
@end

@implementation SurveyorQuestionView
@synthesize responses, responseSetId, answers, pick, selectedCell, pickerContent, popover, pickerButton, surveyorKeyboardAccessory;

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

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc showNumber:(BOOL)showNumber{
  if((self = [super initWithFrame:frame])) {
    float height = 5.0;
    if ([json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *question_text_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 24.0)];
      
      if ([@"label" isEqual:[json valueForKey:@"type"]]) {
        showNumber = false;
      }
      
      NSMutableString *txt = [[[NSMutableString alloc] init] autorelease];
      [txt appendString: showNumber ? [NSString stringWithFormat:@"%d) ", [[self class] nextNumber]] : @""];
      [txt appendString: [json valueForKey:@"post_text"] ? [NSString stringWithFormat:@"%@ | %@", [json valueForKey:@"post_text"], [json valueForKey:@"text"]] : [json valueForKey:@"text"]];
      question_text_label.text = txt;
      
      [question_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
      question_text_label.font = [UIFont boldSystemFontOfSize:19.0];
      
      height += question_text_label.frame.size.height + 5.0;
      [self addSubview:question_text_label];
      [question_text_label release];
    }
    
    self.answers = [json valueForKey:@"answers"];
    self.pick = [json valueForKey:@"pick"];
    
    if ([pick isEqualToString:@"one"] && answers) {
      // pick one (radio buttons)
            
      if ([@"dropdown" isEqual:[json valueForKey:@"type"]]) {
        self.pickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [pickerButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        [pickerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.37 blue:0.90 alpha:1.0] forState:UIControlStateSelected];
        pickerButton.frame = CGRectMake(0.0, height, 100.0, 35.0);
        [pickerButton setTitle:@"Pick one" forState:UIControlStateNormal];
        [pickerButton addTarget:self action:@selector(pickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pickerButton];
        height += pickerButton.frame.size.height;
        
        self.pickerContent = [[PickerViewController alloc] init];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:pickerContent];
        [self.pickerContent setupDelegate:self withTitle:[json valueForKey:@"text"]];
        self.popover.delegate = self;

      }else{
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width/2, 44.0 * [answers count]) style:UITableViewStylePlain];
        tableView.scrollEnabled = FALSE; 
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        height += tableView.frame.size.height;   
      }
      
    }else if([pick isEqualToString:@"any"] && answers){
      // pick any (checkboxes)
      UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width/2, 44.0 * [answers count]) style:UITableViewStylePlain];
      tableView.scrollEnabled = FALSE; 
      tableView.delegate = self;
      tableView.dataSource = self;
      [self addSubview:tableView];
      height += tableView.frame.size.height;
    }else{
      // pick none, default
      float max_text_width = 0.0;
      float max_post_text_width = 0.0;
      
      for (NSDictionary *answer in [json objectForKey:@"answers"]) {
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

      if(answers){     
        for (NSDictionary *answer in answers) {
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

- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc{
  self = [super initWithFrame:frame];
  if (self) {
    float height = 5.0;
    if ([json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *group_text_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 44.0)];
      
      group_text_label.text = [NSString stringWithFormat:@"%d) %@", [[self class] nextNumber], [json valueForKey:@"text"]];;
      
      [group_text_label setUpMultiLineVerticalResizeWithFontSize:19.0];
      group_text_label.font = [UIFont boldSystemFontOfSize:19.0];
      
      height += group_text_label.frame.size.height + 5.0;
      [self addSubview:group_text_label];
      [group_text_label release];
    }
    if ([@"grid" isEqual:[json valueForKey:@"type"]] && [json valueForKey:@"questions"] && [json valueForKey:@"answers"]) {
      // grid
      float max_text_width = 0.0;
      float max_post_text_width = 0.0;
      
      for (NSDictionary *question in [json objectForKey:@"questions"]) {
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
      
      for (NSDictionary *question in [json objectForKey:@"questions"]) {
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
        UISegmentedControl *pickOneSegment = [[UISegmentedControl alloc] initWithItems:[[json valueForKey:@"answers"] valueForKey:@"text"]];
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
      if([json objectForKey:@"questions"]){
        for (NSDictionary *question in [json objectForKey:@"questions"]) {
          UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(0.0, height, frame.size.width, 44.0) json:question controller:dvc showNumber:false] autorelease];
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

#pragma mark -
#pragma mark Pick Button target

- (void) pickButtonPressed:(id) sender {
  if ([sender isKindOfClass:[UIButton class]]) {
    UIButton* myButton = (UIButton*)sender;
    [self.popover presentPopoverFromRect:myButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  }
}
- (void) pickerDone{
  [self.popover dismissPopoverAnimated:NO];
  if ([self.pickerContent.picker selectedRowInComponent:0] != -1) {
    self.pickerButton.selected = true;
  }
  [self.pickerButton setTitle:[[answers objectAtIndex:[self.pickerContent.picker selectedRowInComponent:0]] objectForKey:@"text"] forState:UIControlStateNormal];
  [self.pickerButton sizeToFit];
}
- (void) pickerCancel{
  [self.popover dismissPopoverAnimated:NO];
}

#pragma mark -
#pragma mark Picker view data source


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [answers count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  UILabel *pickerRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
  pickerRow.backgroundColor = [UIColor clearColor];
  pickerRow.font = [UIFont systemFontOfSize:16.0];
  pickerRow.text = [[answers objectAtIndex:row] objectForKey:@"text"];
  return pickerRow;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return @"Very long title Very long title Very long title Very long title Very long title Very long title Very long title Very long title Very long title Very long title ";
//}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [answers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CheckboxCellIdentifier";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:[pick isEqual:@"one"] ? @"undotted" : @"unchecked.png"];
  }

  // Configure the cell.
//  cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
  
  cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
  cell.textLabel.text = [[answers objectAtIndex:indexPath.row] objectForKey:@"text"];
//	cell.textLabel.text = @"foo";
	return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
  if ([@"one" isEqual:pick]) {
    if (selectedCell) {
      selectedCell.imageView.image = [UIImage imageNamed:@"undotted.png"];
    }
    cell.imageView.image = [UIImage imageNamed:@"dotted.png"];
    selectedCell = cell;
  } else {
    Boolean checked = cell.imageView.image == [UIImage imageNamed:@"checked.png"];  
    cell.imageView.image = checked ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
  }
}



- (void)dealloc
{
  [responses release];
  [responseSetId release];
  [answers release];
  [pick release];
  [selectedCell release];
  [pickerContent release];
  [popover release];
  [pickerButton release];
  [surveyorKeyboardAccessory release];
  [super dealloc];
}

@end
