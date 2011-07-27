//
//  QuestionResponse.m
//  surveyor_ios
//
//  Created by Mark Yoon on 7/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuestionResponse.h"

@interface QuestionResponse ()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic,retain) UITableViewCell* selectedCell;
@end

@implementation QuestionResponse

// public properties
@synthesize json, UUID, responseSetId, answers, pick;
// private properties
@synthesize selectedCell;

- (QuestionResponse *) initWithJson:(NSDictionary *)dict responseSetId:(NSManagedObjectID *)nsmoid {
  self = [super init];
  if (self) {
    self.json = dict;
    self.responseSetId = nsmoid;
//    DLog(@"initWithJson responseSetId: %@", self.responseSetId);
    self.answers = [self.json valueForKey:@"answers"];
//    DLog(@"%@", self.answers);
    self.pick  = [self.json valueForKey:@"pick"];
//    DLog(@"%@", self.pick);
  }
  return self;
}

- (NSArray *) responsesForQuestion {
	// setup fetch request
	NSError *error = nil;
	NSFetchRequest *fetch = [UIAppDelegate.managedObjectModel
                           fetchRequestFromTemplateWithName:@"responsesForQuestion"
                                      substitutionVariables:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.responseSetId, self.UUID, nil]
                                                                                        forKeys:[NSArray arrayWithObjects: @"responseSetId", @"questionUUID", nil]]];
	
	NSArray *sortDescriptors = [NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:@"startedOn" ascending:YES] autorelease], nil];
	[fetch setSortDescriptors:sortDescriptors];
	
	// http://coderslike.us/2009/05/05/finding-freeddeallocated-instances-of-objects/
	// execute fetch request
	NSArray *results = [UIAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
	if (!results) {
    /*
     Replace this implementation with code to handle the error appropriately.
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */
    NSLog(@"Unresolved responsesForQuestion fetch error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return results;
}
- (NSManagedObject *) responseForQuestion:(NSString *)qid answer:(NSString *)aid{
//  DLog(@"responseForQuestion %@ answer %@", qid, aid);
  // setup fetch request
	NSError *error = nil;
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  [request setEntity:entity];
  // Set example predicate and sort orderings...
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"(Answer == %@) AND (Question == %@)", aid, qid];
  [request setPredicate:predicate];

  // http://coderslike.us/2009/05/05/finding-freeddeallocated-instances-of-objects/
  NSArray *results = [[UIAppDelegate managedObjectContext] executeFetchRequest:request error:&error];
  if (results == nil)
  {
    /*
     Replace this implementation with code to handle the error appropriately.
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */
    NSLog(@"Unresolved responseForQuestion answer fetch error %@, %@", error, [error userInfo]);
    abort();
  }
//  DLog(@"responseForQuestion result: %@", [results lastObject]);
  return [results lastObject];
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
  
  NSManagedObject *existingResponse = [self responseForQuestion:[json valueForKey:@"uuid"] answer:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"]];
  if (existingResponse) {
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
  if ([@"one" isEqual:pick]) {
    if (selectedCell) {
      selectedCell.imageView.image = [UIImage imageNamed:@"undotted.png"];
      NSManagedObject *existingResponse = [self responseForQuestion:[json valueForKey:@"uuid"] answer:[[answers objectAtIndex:[[aTableView indexPathForCell:selectedCell] row]] valueForKey:@"uuid"]];
      [UIAppDelegate.managedObjectContext deleteObject:existingResponse];
    }
    cell.imageView.image = [UIImage imageNamed:@"dotted.png"];
    selectedCell = cell;
    
    NSManagedObject *newResponse = [NSEntityDescription insertNewObjectForEntityForName:@"Response" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
    [newResponse setValue:[NSDate date] forKey:@"CreatedAt"];
    [newResponse setValue:[json valueForKey:@"uuid"] forKey:@"Question"];
    [newResponse setValue:[[answers objectAtIndex:[indexPath row]] valueForKey:@"uuid"] forKey:@"Answer"];
    NSError *error = nil;
    NSManagedObject *responseSet = [[UIAppDelegate managedObjectContext] existingObjectWithID:responseSetId error:&error];
    [newResponse setValue:responseSet forKey:@"responseSet"];

    // Save the context.
    [UIAppDelegate saveContext:@"QuestionResponse tableView didSelectRowAtIndexPath"];
    
  } else {
    Boolean checked = cell.imageView.image == [UIImage imageNamed:@"checked.png"];  
    cell.imageView.image = checked ? [UIImage imageNamed:@"unchecked.png"] : [UIImage imageNamed:@"checked.png"];
  }
}

@end
