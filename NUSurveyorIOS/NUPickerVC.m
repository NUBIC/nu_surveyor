//
//  NUPickerVC.m
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import "NUPickerVC.h"


@implementation NUPickerVC
@synthesize bar, picker, datePicker, toolBar, nowButton;

#pragma mark - Memory management
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
  [bar dealloc];
  [picker dealloc];
  [datePicker dealloc];
  [toolBar dealloc];
  [nowButton dealloc];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Setup
-(void)setupDelegate:(id)delegate withTitle:(NSString *)title date:(Boolean)isDate 
{
  bar.title = title;
  bar.leftBarButtonItem.target = delegate;  
  bar.leftBarButtonItem.action = @selector(pickerCancel);  
  bar.rightBarButtonItem.target = delegate;
  bar.rightBarButtonItem.action = @selector(pickerDone);
  if (isDate) {
    nowButton.target = delegate;
    nowButton.action = @selector(nowPressed);
    [toolBar setHidden:NO];
    self.contentSizeForViewInPopover = CGSizeMake(384.0, 304.0);
  }else {
    [toolBar setHidden:YES];
    self.contentSizeForViewInPopover = CGSizeMake(384.0, 260.0);
  }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
