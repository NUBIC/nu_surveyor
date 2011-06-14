//
//  PickerViewController.h
//  surveyor_ios
//
//  Created by Mark Yoon on 6/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PickerViewController : UIViewController {
  UIPickerView *picker;
  UINavigationItem *bar;
}
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UINavigationItem *bar;

-(void)setupDelegate:(id)delegate withTitle:(NSString *)title;

@end
