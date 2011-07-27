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
@property (nonatomic, retain) NSManagedObjectID *responseSetId;
@property (nonatomic,retain) NSArray* answers;
@property (nonatomic,retain) NSString* pick;

- (NSArray *) responsesForQuestion;
- (QuestionResponse *) initWithJson:(NSDictionary *)dict responseSetId:(NSManagedObjectID *)nsmoid;

@end
