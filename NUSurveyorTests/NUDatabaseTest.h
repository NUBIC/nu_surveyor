//
//  NUDatabaseTest.h
//  
//
//  Created by John Dzak on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface NUDatabaseTest : SenTestCase

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coord;
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;

- (void)setUp;
- (void)tearDown;

@end
