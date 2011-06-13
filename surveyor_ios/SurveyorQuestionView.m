//
//  SurveyorQuestionView.m
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorQuestionView.h"
#import <QuartzCore/QuartzCore.h> 

@interface SurveyorQuestionView ()
  @property (nonatomic,retain) NSArray* answers;
  @property (nonatomic,retain) NSString* pick;
  @property (nonatomic,retain) UITableViewCell* selectedCell;
@end

@implementation SurveyorQuestionView
@synthesize answers, pick, selectedCell;

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
    float height = 0.0;
    if ([json valueForKey:@"text"]) {
    // Question text label wraps and expands height to fit
      
      UILabel *q_text = [[[UILabel alloc] init] autorelease];
      q_text.lineBreakMode = UILineBreakModeWordWrap;
      q_text.numberOfLines = 0;
      
      if ([@"label" isEqual:[json valueForKey:@"type"]]) {
        showNumber = false;
      }
      NSMutableString *txt = [[[NSMutableString alloc] init] autorelease];
      [txt appendString: showNumber ? [NSString stringWithFormat:@"%d) ", [[self class] nextNumber]] : @""];
      [txt appendString: [json valueForKey:@"post_text"] ? [NSString stringWithFormat:@"%@ | %@", [json valueForKey:@"post_text"], [json valueForKey:@"text"]] : [json valueForKey:@"text"]];
      q_text.text = txt;
      height = [q_text.text sizeWithFont:q_text.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
      q_text.frame = CGRectMake(0, 0, frame.size.width, height);
      //    q_text.backgroundColor = [UIColor blueColor];
      [self addSubview:q_text];
    }
    
    self.answers = [json valueForKey:@"answers"];
    self.pick = [json valueForKey:@"pick"];
    
    if ([pick isEqualToString:@"one"] && answers) {
    // pick one (radio buttons)
      
//      if ([@"dropdown" isEqual:[json valueForKey:@"type"]]) {
//        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height, frame.size.width/2, 162)];
//        picker.delegate = self;
//        picker.dataSource = self;
//        height += picker.frame.size.height;
//        [self addSubview:picker];
//      }else{
//        UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:[answers valueForKey:@"text"]];
//        segmented.frame = CGRectMake(0, height, segmented.frame.size.width, segmented.frame.size.height);
//        height += segmented.frame.size.height;      
//        [self addSubview:segmented];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, frame.size.width/2, 44 * [answers count]) style:UITableViewStylePlain];
        tableView.scrollEnabled = FALSE; 
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        height += tableView.frame.size.height;   
//      }
      
    }else if([pick isEqualToString:@"any"] && answers){
    // pick any (checkboxes)

      UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, frame.size.width/2, 44 * [answers count]) style:UITableViewStylePlain];
      tableView.scrollEnabled = FALSE; 
      tableView.delegate = self;
      tableView.dataSource = self;
      [self addSubview:tableView];
      height += tableView.frame.size.height;
      
    }else{
    // pick none, default

      if(answers){        
        NSMutableString *txt = [[[NSMutableString alloc] init] autorelease];
        for (NSDictionary *answer in answers) {
          if ([answer valueForKey:@"text"] || [answer valueForKey:@"help"]) {
            UILabel *answers_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 20)] autorelease];
            answers_label.text = [NSString stringWithFormat:@"%@%@", [answer valueForKey:@"text"] ? [answer valueForKey:@"text"] : @"", [answer valueForKey:@"help"] ? [NSString stringWithFormat:@" (%@)", [answer valueForKey:@"help"]] : @""];
            height += answers_label.frame.size.height;
            [self addSubview:answers_label];
          }
          
          if([@"text" isEqual:[answer valueForKey:@"type"]]){
            UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, height, frame.size.width/2, 128)];
            text.layer.borderWidth = 1;
            text.layer.borderColor = [[UIColor grayColor] CGColor];
            text.layer.shadowColor = [[UIColor grayColor] CGColor];
            text.delegate = dvc;
            [self addSubview:text];
            height += text.frame.size.height;
          }else if ([@"string" isEqual:[answer valueForKey:@"type"]]) {
            UITextField *string = [[UITextField alloc] initWithFrame:CGRectMake(0, height, frame.size.width/2, 31)];
            string.delegate = dvc;
            [self addSubview:string];
            string.borderStyle = UITextBorderStyleRoundedRect;
            height += string.frame.size.height;
          }else if([@"integer" isEqual:[answer valueForKey:@"type"]]){
            UITextField *integerResponse = [[UITextField alloc] initWithFrame:CGRectMake(0, height, frame.size.width/6, 31)];
            integerResponse.textAlignment = UITextAlignmentRight;
            integerResponse.delegate = dvc;
            [self addSubview:integerResponse];
            integerResponse.keyboardType = UIKeyboardTypeNumberPad;
            integerResponse.borderStyle = UITextBorderStyleRoundedRect;
            height += integerResponse.frame.size.height;
          }else if([@"float" isEqual:[answer valueForKey:@"type"]]){
            UITextField *floatResponse = [[UITextField alloc] initWithFrame:CGRectMake(0, height, frame.size.width/4, 31)];
            floatResponse.textAlignment = UITextAlignmentRight;
            floatResponse.delegate = dvc;
            [self addSubview:floatResponse];
            floatResponse.keyboardType = UIKeyboardTypeDecimalPad;
            floatResponse.borderStyle = UITextBorderStyleRoundedRect;
            height += floatResponse.frame.size.height;
          }
          
          if ([answer valueForKey:@"post_text"]) {
            UILabel *answers_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 20)] autorelease];
            answers_label.text = [answer valueForKey:@"post_text"];
            height += answers_label.frame.size.height;
            [self addSubview:answers_label];
          }
        }
      }
    }    
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+10.0);

  }
  return self;
}

- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json controller:(DetailViewController *)dvc{
  self = [super initWithFrame:frame];
  if (self) {
    float height = 0.0;
    if ([json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *q_text = [[[UILabel alloc] init] autorelease];
      q_text.lineBreakMode = UILineBreakModeWordWrap;
      q_text.numberOfLines = 0;
      q_text.text = [NSString stringWithFormat:@"%d) %@", [[self class] nextNumber], [json valueForKey:@"text"]];
      height = [q_text.text sizeWithFont:q_text.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
      q_text.frame = CGRectMake(0, 0, frame.size.width, height);
      //    q_text.backgroundColor = [UIColor blueColor];
      [self addSubview:q_text];
    }    
    
    if([json objectForKey:@"questions"]){
      for (NSDictionary *question in [json objectForKey:@"questions"]) {
        UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 10) json:question controller:dvc showNumber:false] autorelease];
        [self addSubview:q_view];
        height += q_view.frame.size.height;
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
  [answers release];
  [super dealloc];
}

@end
