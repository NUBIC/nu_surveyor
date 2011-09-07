//
//  RootViewController.h
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//@class DetailViewController;
@class SurveySectionViewController;

@interface RootViewController : UITableViewController {
//  DetailViewController *detailViewController;
  SurveySectionViewController *detailViewController;
	NSDictionary *dict;
  NSManagedObjectID *responseSetId;
  NSUInteger currentSection;
}

//@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet SurveySectionViewController *detailViewController;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NSManagedObject *responseSet;
@property (nonatomic, assign) NSUInteger currentSection;

- (void) nextSection;
- (void) prevSection;
- (NSInteger) numberOfSections;
- (void) showSection:(NSUInteger) index;
@end
