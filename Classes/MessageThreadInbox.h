//
//  MessageThread.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageThreadInbox : UIViewController {
        
}
@property (nonatomic, strong) NSString *participantRole;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSArray *subThreadIds;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property bool threadingUsed;
@property int numberOfMessages;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *isReminder;
@property BOOL wasViewed;
@property (nonatomic, strong) NSArray *pollChoices;
@property (nonatomic, strong) NSString *followUp;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderId;

@end
