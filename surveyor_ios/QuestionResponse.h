//
//  QuestionResponse.h
//  surveyor_ios
//
//  Created by Mark Yoon on 7/26/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionResponse : NSObject <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
}
@property (nonatomic, retain) NSDictionary *json;
@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSArray* answers;
@property (nonatomic, retain) NSString* pick;
@property (nonatomic, retain) NSManagedObject *responseSet;

- (QuestionResponse *) initWithJson:(NSDictionary *)dict responseSet:(NSManagedObject *)nsmo;
- (NSManagedObject *) responseForAnswer:(NSString *)aid;
- (void) newResponseForAnswer:(NSString *)aid;
@end
