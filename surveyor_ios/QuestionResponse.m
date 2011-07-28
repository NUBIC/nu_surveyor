//
//  QuestionResponse.m
//  surveyor_ios
//
//  Created by Mark Yoon on 7/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QuestionResponse.h"
#import "UUID.h"
#import "PickerViewController.h"

@interface QuestionResponse ()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic,retain) UITableViewCell* selectedCell;
@property (nonatomic,retain) PickerViewController* pickerContent;
@property (nonatomic,retain) UIPopoverController* popover;
@property (nonatomic,assign) NSInteger pickedRow;
@property (nonatomic,retain) UIToolbar* surveyorKeyboardAccessory;
@property (nonatomic,retain) NSMutableDictionary *textFieldsAndViews;

- (UIToolbar *)surveyorKeyboardAccessory;
@end

@implementation QuestionResponse

// public properties
@synthesize json, UUID, answers, pick, responseSet, pickerButton, detailViewController;
// private properties
@synthesize selectedCell, pickerContent, popover, pickedRow, surveyorKeyboardAccessory, textFieldsAndViews;

- (QuestionResponse *) initWithJson:(NSDictionary *)dict responseSet:(NSManagedObject *)nsmo {
  self = [super init];
  if (self) {
    self.json = dict;
    self.responseSet = nsmo;
//    DLog(@"initWithJson responseSetId: %@", self.responseSetId);
    self.answers = [json valueForKey:@"answers"];
//    DLog(@"%@", self.answers);
    self.pick  = [json valueForKey:@"pick"];
    self.UUID = [json valueForKey:@"uuid"];
//    DLog(@"%@", self.pick);
    if ([pick isEqualToString:@"one"] && [@"dropdown" isEqual:[json valueForKey:@"type"]]) {
      self.pickerContent = [[PickerViewController alloc] init];
      self.popover = [[UIPopoverController alloc] initWithContentViewController:pickerContent];
      [self.pickerContent setupDelegate:self withTitle:[json valueForKey:@"text"]];
      self.popover.delegate = self;
    }
    self.textFieldsAndViews = [[NSMutableDictionary alloc] init];
  }
  return self;
}

#pragma mark -
#pragma mark Core Data

- (NSManagedObject *) responseForAnswer:(NSString *)aid{
//  DLog(@"responseForQuestion %@ answer %@", qid, aid);
  // setup fetch request
	NSError *error = nil;
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [request setEntity:entity];
  
  // Set predicate
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"(responseSet == %@) AND (Question == %@) AND (Answer == %@)", self.responseSet, self.UUID, aid];
  [request setPredicate:predicate];

  NSArray *results = [[UIAppDelegate managedObjectContext] executeFetchRequest:request error:&error];
  if (results == nil)
  {
    /*
     Replace this implementation with code to handle the error appropriately.
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */
    NSLog(@"Unresolved responseForAnswer fetch error %@, %@", error, [error userInfo]);
    abort();
  }
//  DLog(@"responseForAnswer: %@ result: %@", aid, [results lastObject]);
//  DLog(@"responseForAnswer #:%d", [results count]);
  return [results lastObject];
}

- (void) newResponseForAnswer:(NSString *)aid{
  NSManagedObject *newResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [newResponse setValue:self.responseSet forKey:@"responseSet"];
  [newResponse setValue:self.UUID forKey:@"Question"];
  [newResponse setValue:aid forKey:@"Answer"];

  [newResponse setValue:[NSDate date] forKey:@"CreatedAt"];
  [newResponse setValue:[UUID generateUuidString] forKey:@"UUID"];
  
  // Save the context.
  [UIAppDelegate saveContext:@"QuestionResponse newResponseForAnswer"];
  
//  DLog(@"newResponseForAnswer: %@", newResponse);
}

- (void) newResponseForAnswer:(NSString *)aid value:(NSString *)value{
  NSManagedObject *newResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [newResponse setValue:self.responseSet forKey:@"responseSet"];
  [newResponse setValue:self.UUID forKey:@"Question"];
  [newResponse setValue:aid forKey:@"Answer"];
  [newResponse setValue:value forKey:@"Value"];
  
  [newResponse setValue:[NSDate date] forKey:@"CreatedAt"];
  [newResponse setValue:[UUID generateUuidString] forKey:@"UUID"];
  
  // Save the context.
  [UIAppDelegate saveContext:@"QuestionResponse newResponseForAnswerValue"];
  
//  DLog(@"newResponseForAnswerValue: %@", newResponse);
  
}

#pragma mark -
#pragma mark Pick Button

- (UIButton *) setupPickerButton {
//  DLog(@"setupPickerButton");
  self.pickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [pickerButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
  [pickerButton setTitleColor:[UIColor colorWithRed:0.0 green:0.37 blue:0.90 alpha:1.0] forState:UIControlStateSelected];
  [pickerButton addTarget:self action:@selector(pickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [pickerButton setTitle:@"Pick one" forState:UIControlStateNormal];
  
  for (NSDictionary *answer in answers) {
    NSManagedObject *existingResponse = [self responseForAnswer:[answer valueForKey:@"uuid"]];
    if (existingResponse) {
      self.pickerButton.selected = true;
      [pickerButton setTitle:[answer valueForKey:@"text"] forState:UIControlStateNormal];
      [pickerContent.picker selectRow:[answers indexOfObject:answer] inComponent:0 animated:FALSE];
    }
  }
  
  return pickerButton;
}

- (void) pickButtonPressed:(id) sender {
  if ([sender isKindOfClass:[UIButton class]]) {
    UIButton* myButton = (UIButton*)sender;
    [self.popover presentPopoverFromRect:myButton.frame inView:pickerButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
  }
}
- (void) pickerDone{
  [popover dismissPopoverAnimated:NO];
  if ([pickerContent.picker selectedRowInComponent:0] != -1) {
    self.pickerButton.selected = true;
    
    NSManagedObject *existingResponse = [self responseForAnswer:[[answers objectAtIndex:[pickerContent.picker selectedRowInComponent:0]] valueForKey:@"uuid"]];
    if (existingResponse) {
      //        DLog(@"tableViewdidSelectRowAtIndexPath removing: %@", existingResponse);
      [UIAppDelegate.managedObjectContext deleteObject:existingResponse];
      // Save the context.
      [UIAppDelegate saveContext:@"tableViewdidSelectRowAtIndexPath removing"];
    }
    
    [self newResponseForAnswer:[[answers objectAtIndex:[pickerContent.picker selectedRowInComponent:0]] valueForKey:@"uuid"]];
    
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
  
  NSManagedObject *existingResponse = [self responseForAnswer:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"]];
  if (existingResponse) {
//    DLog(@"tableViewcellForRowAtIndexPath: %@", existingResponse);
    cell.imageView.image = [UIImage imageNamed:[pick isEqual:@"one"] ? @"dotted" : @"checked.png"];
    selectedCell = cell;
  }
  
  // Configure the cell.
  //  cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
  
  cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
  cell.textLabel.text = [[answers objectAtIndex:indexPath.row] objectForKey:@"text"];
  //	cell.textLabel.text = @"foo";
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
  if ([@"one" isEqualToString:pick]) {
    if (selectedCell) {
      selectedCell.imageView.image = [UIImage imageNamed:@"undotted.png"];
      NSManagedObject *existingResponse = [self responseForAnswer:[[answers objectAtIndex:[[aTableView indexPathForCell:selectedCell] row]] valueForKey:@"uuid"]];
      if (existingResponse) {
//        DLog(@"tableViewdidSelectRowAtIndexPath removing: %@", existingResponse);
        [UIAppDelegate.managedObjectContext deleteObject:existingResponse];
        // Save the context.
        [UIAppDelegate saveContext:@"tableViewdidSelectRowAtIndexPath removing"];
      }
    }
    cell.imageView.image = [UIImage imageNamed:@"dotted.png"];
    selectedCell = cell;
    
    [self newResponseForAnswer:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"]];
    
  } else {
    
    Boolean checked = cell.imageView.image == [UIImage imageNamed:@"checked.png"];  
    cell.imageView.image = checked ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
    if (checked) {
      NSManagedObject *existingResponse = [self responseForAnswer:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"]];
      if (existingResponse) {
        [UIAppDelegate.managedObjectContext deleteObject:existingResponse];
        [UIAppDelegate saveContext:@"tableViewdidSelectRowAtIndexPath removing"];
      }
    } else{
      [self newResponseForAnswer:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"]];
    }
  }
}

#pragma mark -
#pragma mark UITextView and UITextField Delegate

- (UITextField *) setupTextFieldWithFrame:(CGRect)frame forAnswer:(NSDictionary *)answer{
//  DLog(@"QuestionResponse setupTextFieldWithFrame forAnswer %@", answer);
  
  UITextField *textField = [[[UITextField alloc] initWithFrame:frame] autorelease];
  textField.delegate = self;
  textField.returnKeyType = UIReturnKeyDone;
  textField.inputAccessoryView = [self surveyorKeyboardAccessory];
  [detailViewController.editViews addObject:textField];
  [textFieldsAndViews setValue:textField forKey:[answer valueForKey:@"uuid"]];
  
  NSManagedObject *existingResponse = [self responseForAnswer:[answer valueForKey:@"uuid"]];
  if (existingResponse) {
    textField.text = (NSString *)[existingResponse valueForKey:@"value"];
  }
  
  textField.font = [UIFont systemFontOfSize:16.0];
  textField.borderStyle = UITextBorderStyleRoundedRect;
  

//  DLog(@"%@", textFieldsAndViews);
  return textField;
}
- (UITextView *) setupTextViewWithFrame:(CGRect)frame forAnswer:(NSDictionary *)answer{
//  DLog(@"QuestionResponse setupTextViewWithFrame forAnswer %@", answer);
  
  UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
  textView.delegate = self;
  textView.returnKeyType = UIReturnKeyDefault;
  textView.inputAccessoryView = [self surveyorKeyboardAccessory];
  [detailViewController.editViews addObject:textView];
  [textFieldsAndViews setValue:textView forKey:[answer valueForKey:@"uuid"]];
  
  NSManagedObject *existingResponse = [self responseForAnswer:[answer valueForKey:@"uuid"]];
  if (existingResponse) {
    textView.text = (NSString *)[existingResponse valueForKey:@"value"];
  }
  
  textView.font = [UIFont systemFontOfSize:16.0];            
  textView.layer.cornerRadius = 8.0;
  textView.layer.borderWidth = 1.0;
  textView.layer.borderColor = [[UIColor grayColor] CGColor];
//  DLog(@"%@", textFieldsAndViews);
  return textView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//  DLog(@"QuestionResponse textFieldShouldReturn");

  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//  DLog(@"QuestionResponse textFieldDidEndEditing");

  NSManagedObject *existingResponse = [self responseForAnswer:[[textFieldsAndViews allKeysForObject:textField] lastObject]];
  if (existingResponse) {
//    DLog(@"existingResponse");
    [existingResponse setValue:textField.text forKey:@"value"];
    [UIAppDelegate saveContext:@"textFieldShouldReturn"];
  }else{
    [self newResponseForAnswer:[[textFieldsAndViews allKeysForObject:textField] lastObject] value:textField.text];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//  DLog(@"QuestionResponse textViewDidEndEditing");

  NSManagedObject *existingResponse = [self responseForAnswer:[[textFieldsAndViews allKeysForObject:textView] lastObject]];
  if (existingResponse) {
//    DLog(@"existingResponse");
    [existingResponse setValue:textView.text forKey:@"value"];
    [UIAppDelegate saveContext:@"textFieldShouldReturn"];
  }else{
    [self newResponseForAnswer:[[textFieldsAndViews allKeysForObject:textView] lastObject] value:textView.text];
  }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//  DLog(@"QuestionResponse textFieldShouldBeginEditing");

  return [detailViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//  DLog(@"QuestionResponse textViewShouldBeginEditing");

  return [detailViewController textViewShouldBeginEditing:textView];
}

#pragma mark -
#pragma mark Input accessory view
- (UIToolbar *)surveyorKeyboardAccessory {
  if (!surveyorKeyboardAccessory) {
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 44.0);
    surveyorKeyboardAccessory = [[UIToolbar alloc] initWithFrame:accessFrame];
    surveyorKeyboardAccessory.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:detailViewController action:@selector(prevField)];
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:detailViewController action:@selector(nextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:detailViewController action:@selector(editViewResignFirstResponder)];
    surveyorKeyboardAccessory.items = [NSArray arrayWithObjects:prev, next, space, doneButton, nil];
    
  }
  return surveyorKeyboardAccessory;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [json release];
  [UUID release];
  [answers release];
  [pick release];
  [responseSet release];
  [pickerButton release];
  detailViewController = nil;
  
  [selectedCell release];
  [pickerContent release];
  [popover release];
  pickedRow = 0;
  [surveyorKeyboardAccessory release];
  [textFieldsAndViews release];

  [super dealloc];
}

@end
