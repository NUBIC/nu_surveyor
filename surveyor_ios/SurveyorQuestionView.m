//
//  SurveyorQuestionView.m
//  surveyor_two
//
//  Created by Mark Yoon on 4/14/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SurveyorQuestionView.h"

@implementation SurveyorQuestionView
+ (void) initialize{
  qCount = 0;
}
+ (int) nextNumber{
  qCount++;
  return qCount;
}
+ (void) resetNumber{
  qCount = 0;
}

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json showNumber:(BOOL)showNumber{
  self = [super initWithFrame:frame];
  if (self) {
    float height = 0.0;
    if ([json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *q_text = [[[UILabel alloc] init] autorelease];
      q_text.lineBreakMode = UILineBreakModeWordWrap;
      q_text.numberOfLines = 0;
      q_text.text = showNumber ? [NSString stringWithFormat:@"%d) %@", [[self class] nextNumber], [json valueForKey:@"text"]] : [json valueForKey:@"text"];
      height = [q_text.text sizeWithFont:q_text.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
      q_text.frame = CGRectMake(0, 0, frame.size.width, height);
      //    q_text.backgroundColor = [UIColor blueColor];
      [self addSubview:q_text];
    }
    
    
    NSString *pick = [json valueForKey:@"pick"];
    if ([pick isEqualToString:@"one"] && [json valueForKey:@"answers"]) {
      // pick one (radio buttons)
      NSArray *answers = [json valueForKey:@"answers"];
      UILabel *answers_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 20)] autorelease];
      answers_label.text = [[answers valueForKey:@"text"] componentsJoinedByString:@", "];
      height += answers_label.frame.size.height;

      [self addSubview:answers_label];
    }else if([pick isEqualToString:@"many"]){
      // pick may (checkboxes)
      NSArray *answers = [json valueForKey:@"answers"];
      
      UILabel *answers_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 20)] autorelease];
      answers_label.text = [[answers valueForKey:@"text"] componentsJoinedByString:@", "];
      height += answers_label.frame.size.height;
//      answers_label.backgroundColor = [UIColor greenColor];
      
      [self addSubview:answers_label];
    }else{
      // the default, pick none
      NSArray *answers = [json valueForKey:@"answers"];
      if(answers){
        
        NSMutableString *answers_label_text = [NSMutableString stringWithCapacity:0];
        for (NSDictionary *answer in answers) {
          if ([answers_label_text length] > 0) {
            [answers_label_text appendString:@", "];
          }
          [answers_label_text appendString:[answer valueForKey:@"text"] ? [answer valueForKey:@"text"] : [answer valueForKey:@"type"]];
        }
        UILabel *answers_label = [[[UILabel alloc] initWithFrame:CGRectMake(0, height, frame.size.width, 20)] autorelease];
        answers_label.text = answers_label_text;// [[answers valueForKey:@"text"] componentsJoinedByString:@","];
        height += answers_label.frame.size.height;
        //      answers_label.backgroundColor = [UIColor greenColor];
        [self addSubview:answers_label];

      }
    }
//    [self layoutSubviews];
    
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+10.0);
//    NSLog(@"originy: %f", frame.origin.y);
//    NSLog(@"height: %f", height);

  }
  return self;
}

- (id)initGroupWithFrame:(CGRect)frame json:(NSDictionary *)json{
  self = [super initWithFrame:frame];
  if (self) {
    float height = 0.0;
    if ([json valueForKey:@"text"]) {
      // Question text label wraps and expands height to fit
      UILabel *q_text = [[[UILabel alloc] init] autorelease];
      q_text.lineBreakMode = UILineBreakModeWordWrap;
      q_text.numberOfLines = 0;
      q_text.text = [NSString stringWithFormat:@"%d) %@", [[self class] nextNumber], [json valueForKey:@"text"]];
      height = [q_text.text sizeWithFont:q_text.font constrainedToSize:CGSizeMake(frame.size.width, 9999) lineBreakMode:UILineBreakModeWordWrap].height;
      q_text.frame = CGRectMake(0, 0, frame.size.width, height);
      //    q_text.backgroundColor = [UIColor blueColor];
      [self addSubview:q_text];
    }    
    
    if([json objectForKey:@"questions"]){
      for (NSDictionary *question in [json objectForKey:@"questions"]) {
        UIView *q_view = [[[SurveyorQuestionView alloc] initWithFrame:CGRectMake(0, height, frame.size.width-40, 10) json:question showNumber:false] autorelease];
        [self addSubview:q_view];
        height += q_view.frame.size.height;
      }
    }

    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height+10.0);
    
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

@end
