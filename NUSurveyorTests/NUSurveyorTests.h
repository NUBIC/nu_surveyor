//
//  NUSurveyorTests.h
//  NUSurveyorTests
//
//  Created by Mark Yoon on 9/26/2011.
//  Copyright (c) 2011-2012 Northwestern University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface NUSurveyorTests : SenTestCase

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coord;
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;

@end
