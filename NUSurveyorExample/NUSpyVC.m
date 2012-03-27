//
//  NUSpyVC.m
//  NUSurveyor
//
//  Created by Mark Yoon on 3/26/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NUSpyVC.h"

@interface NUSpyVC()
@property (nonatomic, strong) UILabel *responseSetCount;
@property (nonatomic, strong) UIButton *kitchenSink;
@property (nonatomic, strong) UIButton *complexResponses;
- (void) loadKitchenSink;
- (void) loadComplexResponses;
@end

@implementation NUSpyVC
@synthesize delegate = _delegate, surveyTVC = _surveyTVC, sectionTVC = _sectionTVC;
@synthesize responseSetCount = _responseSetCount, kitchenSink = _kitchenSink, complexResponses = _complexResponses;

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
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  self.responseSetCount = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 100.0, 36.0)];
  [self.view addSubview:self.responseSetCount];
  
  self.kitchenSink = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.kitchenSink.frame = CGRectMake(10.0, 10.0 + 36.0 + 10.0, 400.0, 36.0);
  self.kitchenSink.accessibilityLabel = @"loadKitchenSink";
  [self.kitchenSink setTitle:@"Load Kitchen Sink" forState:UIControlStateNormal];
  [self.kitchenSink addTarget:self action:@selector(loadKitchenSink) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.kitchenSink];
  
  self.complexResponses = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.complexResponses.frame = CGRectMake(10, 10.0 + 2*36.0 + 2*10.0, 400.0, 36.0);
  self.complexResponses.accessibilityLabel = @"loadComplexResponses";
  [self.complexResponses setTitle:@"Load Complex Responses" forState:UIControlStateNormal];
  [self.complexResponses addTarget:self action:@selector(loadComplexResponses) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.complexResponses];
}
- (void) loadKitchenSink{
  [self.delegate loadSurvey:@"kitchen-sink-survey"];
}
- (void) loadComplexResponses{
  [self.delegate loadSurvey:@"complex-responses"];
}

- (void)viewWillAppear:(BOOL)animated {
  self.responseSetCount.text = [NSString stringWithFormat:@"%d %@", [self.sectionTVC.responseSet responseCount], ([self.sectionTVC.responseSet responseCount] == 1 ? @"response" : @"responses")];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
