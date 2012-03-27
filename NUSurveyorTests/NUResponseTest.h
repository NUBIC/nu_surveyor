//
//  NUResponseTest.h
//  NUSurveyor
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface NUResponseTest : SenTestCase

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coord;
@property (nonatomic, strong) NSManagedObjectContext *ctx;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStore *store;

@end
