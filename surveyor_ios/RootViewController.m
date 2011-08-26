//
//  RootViewController.m
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "JSON.h"
#import "UUID.h"

@implementation RootViewController

@synthesize detailViewController, dict, responseSet;


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	// JSON data
  //	responseData = [[NSMutableData alloc] init];
	NSError *strError;
	NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ks_with_uuid" ofType:@"json"];
//	DLog(@"%@", strPath);
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
//	NSLog(@"%@", strError);
//	NSLog(@"%@", responseString);
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  dict = [[parser objectWithString:responseString] retain];
//  DLog(@"%@", [parser errorTrace]);
//  DLog(@"%@", dict);
  //	NSLog(@"%@", [[dict objectForKey:@"survey"] objectForKey:@"title"]);
	self.navigationItem.title = @"Sections";
  detailViewController.detailDescriptionLabel.text = [[dict objectForKey:@"survey"] objectForKey:@"title"];
	detailViewController.dict = dict;
    
  NSManagedObject *rs = [NSEntityDescription insertNewObjectForEntityForName:@"ResponseSet" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  
  [rs setValue:[NSDate date] forKey:@"CreatedAt"];
  [rs setValue:[[dict objectForKey:@"survey"] objectForKey:@"title"] forKey:@"UUID"];
  [rs setValue:[UUID generateUuidString] forKey:@"UUID"];
  
  [UIAppDelegate saveContext:@"RootViewController viewDidLoad"];
  self.responseSet = rs;
  detailViewController.responseSet = rs;
  
  detailViewController.pageControl.numberOfPages = [self numberOfSections];
//  DLog(@"viewDidLoad responseSetId: %@", responseSetId);
	
  if ([[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:0]) {
    [detailViewController setDetailItem:[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:0]];
  }
  
	//	NSURL *url = [NSURL URLWithString:@"http://sb/dsl.json"];
  //	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  //	//NSLog(@"request");
  //	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    [responseData setLength:0];
//	//NSLog(@"response");
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [responseData appendData:data];
//	NSLog(@"data");
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//	NSDictionary *dict = [[SBJsonParser alloc] objectWithString:responseString];
//	
//	NSLog(@"finished");
//	self.navigationItem.title = [[dict objectForKey:@"survey"] objectForKey:@"title"];
//	self.detailViewController.detailDescriptionLabel.text = [[dict objectForKey:@"survey"] objectForKey:@"title"];
//}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
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
	
  return [self numberOfSections];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CellIdentifier";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Configure the cell.
  //    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
	cell.textLabel.text = [[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
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
  /*
   When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
   */
  // detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
  [detailViewController setDetailItem:[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:indexPath.row]];
  detailViewController.pageControl.currentPage = indexPath.row;
}

#pragma mark - Section navigation

- (NSInteger) numberOfSections {
  return [[[dict objectForKey:@"survey"] objectForKey:@"sections"] count];
}
- (void) nextSection{
  if (([self.tableView indexPathForSelectedRow].row + 1) < [[[dict objectForKey:@"survey"] objectForKey:@"sections"] count]) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row + 1) inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [detailViewController setDetailItem:[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:indexPath.row]];
  }
  
}
- (void) prevSection{
  if (([self.tableView indexPathForSelectedRow].row) > 0) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row - 1) inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [detailViewController setDetailItem:[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:indexPath.row]];
  }
  
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [detailViewController release];
	[dict release];
  [responseSetId release];
  [super dealloc];
}


@end

