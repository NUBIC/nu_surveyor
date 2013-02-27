//
//  NUGridAnyCell.m
//  NUSurveyoriOS
//
//  Created by Mark Yoon on 1/24/2012.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUGridAnyCell.h"
#import "UILabel+NUResize.h"
#import "UIColor+NUAdditions.h"

@interface NUGridAnyCell()
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@property (nonatomic, assign) BOOL configuringButtons;
- (void)resetContent;
- (NSIndexPath *)myIndexPathWithQuestion:(NSIndexPath *)q Answer:(NSUInteger)a;
@end
@implementation NUGridAnyCell
@synthesize sectionTVC = _sectionTVC, label = _label, postLabel = _postLabel, buttons = _buttons, answers = _answers, selectedIndexes = _selectedIndexes, configuringButtons = _configuringButtons;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self.textLabel setHidden:YES];
      
      CGFloat fontSize = [[self class] fontSize];
      UIColor *groupedBackgroundColor = [UIColor groupedBackgroundColor];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      self.label = [[self class] preTextLabel];
      self.buttons = [[NUMultiButton alloc] init];
      self.postLabel = [[UILabel alloc] init];
      
      // (pre) text
      [self.contentView addSubview:self.label];
      
      // buttons
      
      [self.contentView addSubview:self.buttons];
      [self.buttons addTarget:self
                  action:@selector(buttonsChanged)
        forControlEvents:UIControlEventValueChanged];
      
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
  return [NSString stringWithFormat:@"NUGridAnyCell %@", self.answers];
}
- (void)configureForData:(id)dataObject tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

  self.configuringButtons = YES;
  [self resetContent];
  
  self.selectedIndexes = [[NSMutableIndexSet alloc] init];
  self.answers = [dataObject objectForKey:@"answers"];
  self.sectionTVC = (NUSectionTVC *)[tableView delegate];  
  
  // (pre) text
  if ([dataObject objectForKey:@"text"] == nil || [[dataObject objectForKey:@"text"] isEqualToString:@""]) {
    [self.label setHidden:YES];
  } else {
    self.label.text = [self.sectionTVC renderMustacheFromString:[dataObject objectForKey:@"text"]];
  }
  
  // input
  [self.buttons setItems:[self.answers valueForKey:@"text"]];
  
  // look up existing response, select corresponding segment
  for (int i = 0; i < [self.answers count]; i++) {
    if ([[self.sectionTVC responsesForIndexPath:[self myIndexPathWithQuestion:indexPath Answer:i]] lastObject]) {
      [self.selectedIndexes addIndex:i];
    }
  }
  [self.buttons selectIndexes:self.selectedIndexes];
  // (post) text
  if ([dataObject objectForKey:@"post_text"] == nil || [[dataObject objectForKey:@"post_text"] isEqualToString:@""]) {
    [self.postLabel setHidden:YES];
  } else {
    self.postLabel.text = [self.sectionTVC renderMustacheFromString:[dataObject objectForKey:@"post_text"]];
  }
  
  self.configuringButtons = NO;
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

- (void) buttonsChanged{
  if (self.configuringButtons) {
    return;
  }
  NSIndexSet *selectedIndexes = self.buttons.selectedIndexes;
  for (int i = 0; i < [self.answers count]; i++) {
    NSIndexPath *j = [self myIndexPathWithAnswer:i];
    [self.sectionTVC deleteResponseForIndexPath:j];
    //    DLog(@"delete");
    if ([selectedIndexes containsIndex:i]) {
      [self.sectionTVC newResponseForIndexPath:j];
      //      DLog(@"create");
    }
    [self.sectionTVC showAndHideDependenciesTriggeredBy:[self myIndexPathWithAnswer:i]];
  }
  //  DLog(@"buttonsChanged");
  //  DLog(@"indexes: %@", [buttons selectedIndexes]);
}
- (void) resetContent {
  [self.label setHidden:NO];
  [self.postLabel setHidden:NO];
  
  self.label.text = nil;
  self.postLabel.text = nil;
  
  self.selectedIndexes = nil;
  
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
  self.buttons.frame = CGRectMake(widthPadding + (.15 * width) + widthPadding, heightPadding, .7 * width -  (2 * widthPadding), height);
  self.postLabel.frame = CGRectMake(widthPadding + (.85 * width), heightPadding, .15 * width, height);
  
  if ([self.label isHidden]) {
    self.buttons.frame = CGRectMake(self.label.frame.origin.x, 
                               self.label.frame.origin.y, 
                               self.buttons.frame.origin.x - self.label.frame.origin.x + self.buttons.frame.size.width, 
                               self.buttons.frame.size.height);
  }
  if ([self.postLabel isHidden]) {
    self.buttons.frame = CGRectMake(self.buttons.frame.origin.x, 
                               self.buttons.frame.origin.y, 
                               self.postLabel.frame.size.width + self.buttons.frame.size.width, 
                               self.buttons.frame.size.height);
  }
  //  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, buttons.frame.size.height + 2 * heightPadding);
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
