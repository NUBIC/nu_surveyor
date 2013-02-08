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
@property (nonatomic, strong) UIButton *mustache;
@property (nonatomic, strong) UIButton *pbj;
@property (nonatomic, strong) UIButton *sesame;
@property (nonatomic, strong) UIButton *blankMustache;
@property (nonatomic, strong) UIButton *statesAndDates;
@property (nonatomic, strong) UIButton *animals;
@property (nonatomic, strong) UIButton *shoes;
@property (nonatomic, strong) UIButton *redGreen;
- (void) loadKitchenSink;
- (void) loadComplexResponses;
- (void) loadMustache;
- (void) loadPbj;
- (void) loadStatesAndDates;
- (void) loadAnimals;
- (void) loadShoes;
- (void) loadDependencyToolbox;
@end

@implementation NUSpyVC
@synthesize delegate = _delegate,
            surveyTVC = _surveyTVC, 
            sectionTVC = _sectionTVC;
@synthesize responseSetCount = _responseSetCount, 
            kitchenSink = _kitchenSink, 
            complexResponses = _complexResponses, 
            mustache = _mustache, 
            pbj = _pbj, 
            sesame = _sesame, 
            blankMustache = _blankMustache,
            statesAndDates = _statesAndDates,
            redGreen = _redGreen;

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
  
  self.mustache = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.mustache.frame = CGRectMake(10, 10.0 + 3*36.0 + 3*10.0, 400.0, 36.0);
  self.mustache.accessibilityLabel = @"loadMustache";
  [self.mustache setTitle:@"Load Mustache" forState:UIControlStateNormal];
  [self.mustache addTarget:self action:@selector(loadMustache) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.mustache];

  self.pbj = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.pbj.frame = CGRectMake(10, 10.0 + 4*36.0 + 4*10.0, 400.0, 36.0);
  self.pbj.accessibilityLabel = @"loadPbj";
  [self.pbj setTitle:@"Load PBJ" forState:UIControlStateNormal];
  [self.pbj addTarget:self action:@selector(loadPbj) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.pbj];
  
  self.sesame = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.sesame.frame = CGRectMake(10, 10.0 + 5*36.0 + 5*10.0, 400.0, 36.0);
  self.sesame.accessibilityLabel = @"loadSesame";
  [self.sesame setTitle:@"Load Sesame" forState:UIControlStateNormal];
  [self.sesame addTarget:self action:@selector(loadSesame) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.sesame];
  
  self.blankMustache = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.blankMustache.frame = CGRectMake(10, 10.0 + 6*36.0 + 6*10.0, 400.0, 36.0);
  self.blankMustache.accessibilityLabel = @"loadBlankMustache";
  [self.blankMustache setTitle:@"Load Blank Mustache" forState:UIControlStateNormal];
  [self.blankMustache addTarget:self action:@selector(loadBlankMustache) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.blankMustache];
  
  self.statesAndDates = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.statesAndDates.frame = CGRectMake(10, 10.0 + 7*36.0 + 7*10.0, 400.0, 36.0);
  self.statesAndDates.accessibilityLabel = @"loadStatesAndDates";
  [self.statesAndDates setTitle:@"Load States And Dates" forState:UIControlStateNormal];
  [self.statesAndDates addTarget:self action:@selector(loadStatesAndDates) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.statesAndDates];
    
  self.animals = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.animals.frame = CGRectMake(10, 10.0 + 8*36.0 + 8*10.0, 400.0, 36.0);
  self.animals.accessibilityLabel = @"loadAnimals";
  [self.animals setTitle:@"Load Animals" forState:UIControlStateNormal];
  [self.animals addTarget:self action:@selector(loadAnimals) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.animals];
    
  self.shoes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.shoes.frame = CGRectMake(10, 10.0 + 9*36.0 + 9*10.0, 400.0, 36.0);
  self.shoes.accessibilityLabel = @"loadShoes";
  [self.shoes setTitle:@"Load Shoes" forState:UIControlStateNormal];
  [self.shoes addTarget:self action:@selector(loadShoes) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.shoes];
    
    self.shoes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shoes.frame = CGRectMake(10, 10.0 + 10*36.0 + 10*10.0, 400.0, 36.0);
    self.shoes.accessibilityLabel = @"loadDependencyToolbox";
    [self.shoes setTitle:@"Load Dependency Toolbox" forState:UIControlStateNormal];
    [self.shoes addTarget:self action:@selector(loadDependencyToolbox) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shoes];
    
    self.redGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.redGreen.frame = CGRectMake(10, 15.0 + 11*36.0 + 11*10.0, 400.0, 36.0);
    self.redGreen.accessibilityLabel = @"loadRedGreen";
    [self.redGreen setTitle:@"Load Red Green (Repeater Conditions)" forState:UIControlStateNormal];
    [self.redGreen addTarget:self action:@selector(loadRedGreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.redGreen];

}
- (void) loadKitchenSink{
  [self.delegate loadSurvey:@"kitchen-sink-survey"];
}
- (void) loadComplexResponses{
  [self.delegate loadSurvey:@"complex-responses"];
}
- (void) loadMustache{
  // thanks to http://www.americanmustacheinstitute.org/mustache-information/styles/
  [self.delegate loadSurvey:@"mustache" renderContext:[NSDictionary dictionaryWithObjectsAndKeys:@"Jake", @"name", @"Northwestern", @"site", nil]];
}
- (void) loadBlankMustache{
  // thanks to http://www.americanmustacheinstitute.org/mustache-information/styles/
  [self.delegate loadSurvey:@"mustache"];
}

- (void) loadPbj{
  [self.delegate loadSurvey:@"pbj"];
}
- (void) loadSesame{
  [self.delegate loadSurvey:@"sesame"];  
}
- (void) loadStatesAndDates {
  [self.delegate loadSurvey:@"states-and-dates"];
}
- (void) loadAnimals {
  [self.delegate loadSurvey:@"animals"];
}
- (void) loadShoes {
  [self.delegate loadSurvey:@"shoes"];
}

- (void) loadDependencyToolbox {
    [self.delegate loadSurvey:@"dependencyToolbox"];
}

- (void) loadRedGreen {
    [self.delegate loadSurvey:@"red-green"];
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
