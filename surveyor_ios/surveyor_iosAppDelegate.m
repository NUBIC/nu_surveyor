//
//  surveyor_iosAppDelegate.m
//  surveyor_ios
//
//  Created by Mark Yoon on 4/19/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "surveyor_iosAppDelegate.h"
#import "RootViewController.h"
@implementation surveyor_iosAppDelegate

@synthesize window=_window;
@synthesize splitViewController=_splitViewController;
@synthesize rootViewController=_rootViewController;
@synthesize detailViewController=_detailViewController;

- (void)awakeFromNib {  
//  RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
//  rootViewController.managedObjectContext = self.managedObjectContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  // Add the split view controller's view to the window and display.
  self.window.rootViewController = self.splitViewController;
  [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
  NSError *error = nil;
  if (managedObjectContext_ != nil) {
    if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
  
  if (managedObjectContext_ != nil) {
    return managedObjectContext_;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext_ = [[NSManagedObjectContext alloc] init];
    [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
  
  if (managedObjectModel_ != nil) {
    return managedObjectModel_;
  }
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"surveyor_ios_model" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath]; 
	DLog(@"Model path %@", modelPath);
  managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return managedObjectModel_;
}


BOOL RSRunningOnOS4OrBetter(void) {
  static BOOL didCheckIfOnOS4 = NO;
  static BOOL runningOnOS4OrBetter = NO;
  return runningOnOS4OrBetter;
  
  if(!didCheckIfOnOS4){
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSInteger majorSystemVersion = 3;
    if(systemVersion != nil && [systemVersion length] > 0){
      NSString *firstCharacter = [systemVersion substringToIndex:1];
      majorSystemVersion = [firstCharacter integerValue];
    }
    
    runningOnOS4OrBetter = (majorSystemVersion >= 4);
    didCheckIfOnOS4 = YES;
  }
  
  return runningOnOS4OrBetter;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator_ != nil) {
    return persistentStoreCoordinator_;
  }
  
  NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"surveyor_ios.sqlite"];
  NSURL *storeUrl = [NSURL fileURLWithPath:storePath ];
  
  NSError *error = nil;
  persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  // iOS 4 encryption
  if(RSRunningOnOS4OrBetter()){
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if(![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:storePath error:&error]){
      // Handle error
    }
  }
  
  return persistentStoreCoordinator_;
}
- (void) saveContext:(NSString *)triggeredBy {
	// Save the context.
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		[UIAppDelegate errorWithTitle:@"Save error" message:[NSString stringWithFormat:@"Unresolved %@ error %@, %@", triggeredBy, error, [error userInfo]]];
	}
}
- (void) errorWithTitle:(NSString *)errorTitle message:(NSString *)errorMessage{
	DLog(@"%@: %@", errorTitle, errorMessage);
	UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[errorAlert show];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc
{
  [_window release];
  [_splitViewController release];
  [_rootViewController release];
  [_detailViewController release];
    [super dealloc];
}

@end
