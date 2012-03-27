//
//  NUResponsetSetTest.h
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface NUResponeSetTest : SenTestCase

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coord;
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;

@end
