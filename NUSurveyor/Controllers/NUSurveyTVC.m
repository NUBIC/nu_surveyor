//
//  NUSurveyTVC.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUSurveyTVC.h"
#import "JSONKit.h"
#import "UUID.h"

@interface NUSurveyTVC()
// http://swish-movement.blogspot.com/2009/05/private-properties-for-iphone-objective.html
@property (nonatomic, strong) NSDictionary *surveyNSD;
@property (nonatomic, assign) NSUInteger currentSection;
- (NSInteger) numberOfSections;
- (void) showSection:(NSUInteger) index;
@end

@implementation NUSurveyTVC
@synthesize sectionTVC = _sectionTVC, survey = _survey, delegate = _delegate;
@synthesize surveyNSD = _surveyNSD, currentSection = _currentSection;

#pragma mark - Memory management

- (id)initWithSurvey:(NUSurvey *)survey responseSet:(NUResponseSet *)responseSet{
  return [self initWithSurvey:survey responseSet:responseSet renderContext:[NSDictionary dictionary]];
}
- (id)initWithSurvey:(NUSurvey *)survey responseSet:(NUResponseSet *)responseSet renderContext:(id)renderContext{
  // TODO trigger an error if survey or survey.jsonString or responseSet is blank
  
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.survey = survey;
    self.surveyNSD = [self.survey.jsonString objectFromJSONString];
    
    self.sectionTVC = [[NUSectionTVC alloc] initWithStyle:UITableViewStyleGrouped];
    self.sectionTVC.responseSet = responseSet;
    self.sectionTVC.delegate = self;
    self.sectionTVC.renderContext = renderContext;
    
    [self.sectionTVC.responseSet setValue:[self.surveyNSD objectForKey:@"uuid"] forKey:@"survey"];
		[self.sectionTVC.responseSet generateDependencyGraph:self.surveyNSD];
    [NUResponseSet saveContext:self.sectionTVC.responseSet.managedObjectContext withMessage:@"NUSurveyTVC initWithSurvey"];
  }
  return self;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

  // Setup view
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	self.navigationItem.title = @"Sections";

  self.sectionTVC.navigationItem.title = [self.surveyNSD objectForKey:@"title"];  
  self.sectionTVC.pageControl.numberOfPages = [self numberOfSections];
  self.tableView.accessibilityLabel = @"surveyTableView";
  
//	// Load survey
//	if(!self.surveyJson){
//		// Request JSON via HTTP
//		//	NSURL *url = [NSURL URLWithString:@"http://sb/dsl.json"];
//		//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//		//	//NSLog(@"request");
//		//	[[NSURLConnection alloc] initWithRequest:request delegate:self];
//		
//		// JSON data
//		NSError *strError;
//		NSString *strPath = [[NSBundle mainBundle] pathForResource:@"kitchen-sink-survey" ofType:@"json"];
//		self.surveyJson = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&strError];
//	}
//	SBJsonParser *parser = [[SBJsonParser alloc] init];  
//	self.surveyNSD = [parser objectWithString:self.surveyJson];
	
  if ([[self.surveyNSD objectForKey:@"sections"] objectAtIndex:0]) {
    [self showSection:0];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES; // Any orientation
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"NUSurveyVCCell";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Configure the cell.
	cell.textLabel.text = [[[self.surveyNSD objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
  cell.accessibilityLabel = [[[self.surveyNSD objectForKey:@"sections"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
	[self showSection:indexPath.row];
}

#pragma mark - Section navigation
- (NSInteger) numberOfSections {
  return [[self.surveyNSD objectForKey:@"sections"] count];
}
- (void) showSection:(NSUInteger)index {
  self.currentSection = index;
  self.sectionTVC.prevSectionTitle = (index == 0 ? nil : [[[self.surveyNSD objectForKey:@"sections"] objectAtIndex:index-1] objectForKey:@"title"]);
  self.sectionTVC.nextSectionTitle = (index == [[self.surveyNSD objectForKey:@"sections"] count] - 1 ? nil : [[[self.surveyNSD objectForKey:@"sections"] objectAtIndex:index+1] objectForKey:@"title"]);
  [self.sectionTVC setDetailItem:[[self.surveyNSD objectForKey:@"sections"] objectAtIndex:index]];
  [self.sectionTVC.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
  self.sectionTVC.pageControl.currentPage = index;
}
- (void) nextSection{
  if (([self.tableView indexPathForSelectedRow].row + 1) < [[self.surveyNSD objectForKey:@"sections"] count]) {
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
- (void) surveyDone{
  [self.delegate surveyDone];
}

@end
