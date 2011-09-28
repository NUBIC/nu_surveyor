//
//  NUSurveyVC.m
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import "NUSurveyVC.h"
#import "SBJson.h"
#import "UUID.h"

@implementation NUSurveyVC
@synthesize sectionController, dict, responseSet, currentSection;

#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
  [sectionController release];
	[dict release];
  [responseSet release];
  [super dealloc];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup view
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	self.navigationItem.title = @"Sections";
  
  // Request JSON via HTTP
//	NSURL *url = [NSURL URLWithString:@"http://sb/dsl.json"];
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//	//NSLog(@"request");
//	[[NSURLConnection alloc] initWithRequest:request delegate:self];

	// JSON data
	NSError *strError;
	NSString *strPath = [[NSBundle mainBundle] pathForResource:@"ks_with_uuid" ofType:@"json"];
  NSString *responseString = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
  SBJsonParser *parser = [[SBJsonParser alloc] init];  
  dict = [[parser objectWithString:responseString] retain];
    
  // Create a new response set
  NSManagedObject *rs = [NSEntityDescription insertNewObjectForEntityForName:@"ResponseSet" inManagedObjectContext:[UIAppDelegate managedObjectContext]];
  [rs setValue:[NSDate date] forKey:@"CreatedAt"];
  [rs setValue:[[dict objectForKey:@"survey"] objectForKey:@"title"] forKey:@"UUID"];
  [rs setValue:[UUID generateUuidString] forKey:@"UUID"];
  [UIAppDelegate saveContext:@"NUSurveyVC viewDidLoad new response set"];
  self.responseSet = rs;
  
	// Setup sectionController
  sectionController.responseSet = responseSet;
  sectionController.bar.title = [[dict objectForKey:@"survey"] objectForKey:@"title"];  
  sectionController.pageControl.numberOfPages = [self numberOfSections];
  if ([[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:0]) {
    [self showSection:0];
  }
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES; // Any orientation
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  // Return the number of sections.
  return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self numberOfSections];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"NUSurveyVCCell";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Configure the cell.
	cell.textLabel.text = [[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
  [self showSection:indexPath.row];
}

#pragma mark - Section navigation
- (NSInteger) numberOfSections {
  return [[[dict objectForKey:@"survey"] objectForKey:@"sections"] count];
}
- (void) showSection:(NSUInteger)index {
  self.currentSection = index;
  [sectionController setDetailItem:[[[dict objectForKey:@"survey"] objectForKey:@"sections"] objectAtIndex:index]];
  [sectionController refresh:self];
  sectionController.pageControl.currentPage = index;
}
- (void) nextSection{
  if (([self.tableView indexPathForSelectedRow].row + 1) < [[[dict objectForKey:@"survey"] objectForKey:@"sections"] count]) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row + 1) inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self showSection:indexPath.row];
  }
}
- (void) prevSection{
  if (([self.tableView indexPathForSelectedRow].row) > 0) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView indexPathForSelectedRow].row - 1) inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self showSection:indexPath.row];
  }
}

@end
