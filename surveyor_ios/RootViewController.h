//
//  RootViewController.h
//  surveyor_two
//
//  Created by Mark Yoon on 3/28/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
  DetailViewController *detailViewController;
	NSDictionary *dict;
  NSManagedObjectID *responseSetId;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) NSManagedObject *responseSet;

@end
