//
//  NUPickerVC.m
//  NUSurveyor
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import "NUPickerVC.h"

@implementation NUPickerVC
@synthesize picker, datePicker, toolBar, nowButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
  self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 216.0)];
  self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  self.picker.showsSelectionIndicator = YES;
  self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 216.0)];
  self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 216.0, 768.0, 44.0)];
  self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  [self.view addSubview:self.picker];
  [self.view addSubview:self.datePicker];
  [self.view addSubview:self.toolBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES; // Any orientation
}

#pragma mark - Setup
- (void)setupDelegate:(id)delegate withTitle:(NSString *)title date:(Boolean)isDate{
  self.navigationItem.title = title;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:delegate action:@selector(pickerCancel)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:delegate action:@selector(pickerDone)];
  
  if (isDate) {
    self.nowButton = [[UIBarButtonItem alloc] initWithTitle:@"    Now    " style:UIBarButtonItemStyleBordered target:delegate action:@selector(nowPressed)];
    self.toolBar.items = [[NSArray alloc] initWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], 
                          nowButton, 
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], nil];
    [self.toolBar setHidden:NO];
    [self.picker setHidden:YES];
    [self.datePicker setHidden:NO];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
  }else {
    [self.toolBar setHidden:YES];
    [self.picker setHidden:NO];
    [self.datePicker setHidden:YES];
    self.picker.delegate = delegate;
    self.picker.dataSource = delegate;
  }
}

@end
