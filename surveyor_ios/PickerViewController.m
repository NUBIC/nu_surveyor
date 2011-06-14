//
//  PickerViewController.m
//  surveyor_ios
//
//  Created by Mark Yoon on 6/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"

@implementation PickerViewController

@synthesize picker, bar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Setup
-(void)setupDelegate:(id)delegate withTitle:(NSString *)title
{
  self.picker.delegate = delegate;
  self.picker.dataSource = delegate;
  self.bar.rightBarButtonItem.target = delegate;
  self.bar.rightBarButtonItem.action = @selector(pickerDone);
  self.bar.leftBarButtonItem.target = delegate;
  self.bar.leftBarButtonItem.action = @selector(pickerCancel);
  self.bar.title = title;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);
    self.bar.title = @"hi";
    // Do any additional setup after loading the view from its nib.
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
	return YES;
}

@end
