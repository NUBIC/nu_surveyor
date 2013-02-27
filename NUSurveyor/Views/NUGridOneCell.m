//
//  NUGridOneCell.m
//  NUSurveyoriOS
//
//  Created by Mark Yoon on 1/24/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUGridOneCell.h"
#import "UILabel+NUResize.h"
#import "UIColor+NUAdditions.h"

@interface NUGridOneCell()
@property (nonatomic, assign) BOOL configuringSegments;
- (void) resetContent;
- (NSIndexPath *)myIndexPathWithQuestion:(NSIndexPath *)q Answer:(NSUInteger)a;
@end
@implementation NUGridOneCell
@synthesize sectionTVC = _sectionTVC, label = _label, postLabel = _postLabel, segments = _segments, answers = _answers, configuringSegments = _configuringSegments;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      //  DLog(@"finishConstruction %@", [super.class reuseIdentifier] );
      [self.textLabel setHidden:YES];
      
      CGFloat fontSize = [[self class] fontSize];
      UIColor *groupedBackgroundColor = [UIColor groupedBackgroundColor];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      self.label = [[self class] preTextLabel];
      self.segments = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: nil]];
      self.postLabel = [[UILabel alloc] init];
      
      // (pre) text
      [self.contentView addSubview:self.label];
      
      // segments
      [self.contentView addSubview:self.segments];
      [self.segments addTarget:self
                        action:@selector(segmentChanged:)
              forControlEvents:UIControlEventValueChanged];
      self.segments.apportionsSegmentWidthsByContent = YES;
      
      // (post) text
      [self.postLabel setUpCellLabelWithFontSize:fontSize];
      //  self.postLabel.backgroundColor = [UIColor blueColor];
      self.postLabel.backgroundColor = groupedBackgroundColor;;
      self.postLabel.autoresizingMask = UIViewAutoresizingNone;
      [self.contentView addSubview:self.postLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - NUCell

- (NSString *)accessibilityLabel{
  return [NSString stringWithFormat:@"NUGridOneCell %@", self.answers];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  // need this to prevent: [segments setSelectedSegmentIndex:i]
  // from triggering segmentChanged during setup
  self.configuringSegments = YES;
  [self resetContent];
  
  self.answers = [dataObject objectForKey:@"answers"];
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];  
  
  // (pre) text
  if ([dataObject objectForKey:@"text"] == nil || [[dataObject objectForKey:@"text"] isEqualToString:@""]) {
    [self.label setHidden:YES];
  } else {
    self.label.text = [self.sectionTVC renderMustacheFromString:[dataObject objectForKey:@"text"]];
  }
  
  // input
  for (NSDictionary *answer in self.answers) {
    [self.segments insertSegmentWithTitle:[answer objectForKey:@"text"] atIndex:[self.segments numberOfSegments] animated:NO];
  }
  // look up existing response, select corresponding segment
  for (int i = 0; i < [self.answers count]; i++) {
    if ([[self.sectionTVC responsesForIndexPath:[self myIndexPathWithQuestion:indexPath Answer:i]] lastObject]) {
      [self.segments setSelectedSegmentIndex:i];
    }
  }
  // (post) text
  if ([dataObject objectForKey:@"post_text"] == nil || [[dataObject objectForKey:@"post_text"] isEqualToString:@""]) {
    [self.postLabel setHidden:YES];
  } else {
    self.postLabel.text = [self.sectionTVC renderMustacheFromString:[dataObject objectForKey:@"post_text"]];
  }
  
  self.configuringSegments = NO;

}
- (void)selectedinTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
  
}


- (NSIndexPath *)myIndexPathWithQuestion:(NSIndexPath *)q Answer:(NSUInteger)a {
  NSUInteger indexArr[] = {[q indexAtPosition:0],[q indexAtPosition:1],a};
  //  DLog(@"myIndexPathWithQuestion: %@", [NSIndexPath indexPathWithIndexes:indexArr length:3]);
  return [NSIndexPath indexPathWithIndexes:indexArr length:3];
}
- (NSIndexPath *)myIndexPathWithAnswer:(NSUInteger)a {
  NSUInteger indexArr[] = {[(UITableView *)self.sectionTVC.tableView indexPathForCell:self].section,[(UITableView *)self.sectionTVC.tableView indexPathForCell:self].row,a};
  //  DLog(@"myIndexPathWithAnswer: %@", [NSIndexPath indexPathWithIndexes:indexArr length:3]);
  return [NSIndexPath indexPathWithIndexes:indexArr length:3];
}

- (void) resetContent {
  [self.label setHidden:NO];
  [self.postLabel setHidden:NO];
  
  self.label.text = nil;
  [self.segments removeAllSegments];
  self.postLabel.text = nil;
  
}

static CGFloat widthSlice = 88.0f;
static CGFloat widthPadding = 8.0f;
static CGFloat heightPadding = 4.0f;
static CGFloat preTextCellPercentage = 0.15f;

- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat groupedCellWidth = self.frame.size.width - widthSlice;
	CGFloat height = self.contentView.frame.size.height - heightPadding * 2;
	CGFloat width = groupedCellWidth - widthPadding * 2;
  
  self.label.frame = CGRectMake(widthPadding, heightPadding, preTextCellPercentage * width, height);
  self.segments.frame = CGRectMake(widthPadding + (.15 * width) + widthPadding, heightPadding, .7 * width -  (2 * widthPadding), 44 - (heightPadding * 2));
  self.postLabel.frame = CGRectMake(widthPadding + (.85 * width), heightPadding, .15 * width, height);
  
  if ([self.label isHidden]) {
    self.segments.frame = CGRectMake(self.label.frame.origin.x, 
                                self.label.frame.origin.y, 
                                self.segments.frame.origin.x - self.label.frame.origin.x + self.segments.frame.size.width, 
                                self.segments.frame.size.height);
  }
  if ([self.postLabel isHidden]) {
    self.segments.frame = CGRectMake(self.segments.frame.origin.x, 
                                self.segments.frame.origin.y, 
                                self.postLabel.frame.size.width + self.segments.frame.size.width, 
                                self.segments.frame.size.height);
  }
  
}
- (void)segmentChanged:(UISegmentedControl *)segmentedControl {
  if (self.configuringSegments) {
    return;
  }
  //  DLog(@"%@", aSegmentedControl);
  NSInteger selectedSegment = [segmentedControl selectedSegmentIndex];
  for (int i = 0; i < [self.answers count]; i++) {
    NSIndexPath *j = [self myIndexPathWithAnswer:i];
    [self.sectionTVC deleteResponseForIndexPath:j];
    //    DLog(@"delete");
    if (i == selectedSegment) {
      [self.sectionTVC newResponseForIndexPath:j];
      //      DLog(@"create");
    }
  }
  [self.sectionTVC showAndHideDependenciesTriggeredBy:[self myIndexPathWithAnswer:selectedSegment]];
}

+ (CGFloat)cellHeightForQuestion:(NSDictionary *)question contentWidth:(CGFloat)contentWidth {
    NSString* text = [question objectForKey:@"text"];
    CGFloat width = (contentWidth - widthSlice - (widthPadding * 2)) * preTextCellPercentage;
    
    CGFloat calculatedHeight = [text sizeWithFont:[[self class] preTextLabel].font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height + (heightPadding * 2);
    
    return calculatedHeight;
}

+ (CGFloat)fontSize {
    return [UIFont labelFontSize] - 2;
}

+ (UILabel*)preTextLabel {
    UILabel *label = [UILabel new];
    [label setUpCellLabelWithFontSize:[self fontSize]];
    label.textAlignment = UITextAlignmentRight;
    label.backgroundColor = [UIColor groupedBackgroundColor];
    label.autoresizingMask = UIViewAutoresizingNone;
    return label;
}

@end
