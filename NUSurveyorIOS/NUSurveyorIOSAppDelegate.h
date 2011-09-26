//
//  NUSurveyorIOSAppDelegate.h
//  NUSurveyorIOS
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright 2011 NUBIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NUSurveyVC;

@class NUSectionVC;

@interface NUSurveyorIOSAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) saveContext:(NSString *)triggeredBy;
- (void) errorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet NUSurveyVC *surveyController;
@property (nonatomic, retain) IBOutlet NUSectionVC *sectionController;

@end
