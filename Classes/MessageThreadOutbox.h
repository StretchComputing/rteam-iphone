//
//  MessageThreadOutbox.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageThreadOutbox : UIViewController {
	

	
    
}
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSArray *subThreadIds;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property int numberOfMessages;
@property bool threadingUsed;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *numRecipients;
@property (nonatomic, strong) NSString *numReplies;
@property (nonatomic, strong) NSString *followUp;

@end
