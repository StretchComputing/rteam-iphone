//
//  MessageThread.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageThreadInbox : UIViewController {
	//Messages
	NSString *threadId;
	NSString *teamId;
	IBOutlet NSString *displaySubject;
	NSString *subject;
	
	NSString *body;
	NSString *messageType;
	NSString *status;
	NSString *isReminder;
	BOOL wasViewed;
	NSArray *pollChoices;
	NSString *followUp;
	
	NSString *senderName;
	NSString *senderId;
	
	NSString *teamName;
	
	//Threads
	int numberOfMessages;
	NSString *eventId;
	NSString *eventType;
	NSArray *subThreadIds;
	NSString *eventDate;
	
	//Both
	bool threadingUsed;
	NSString *receivedDate;   //date of most recent message if threading
    
    NSString *participantRole;


}
@property (nonatomic, retain) NSString *participantRole;
@property (nonatomic, retain) NSString *eventDate;
@property (nonatomic, retain) NSArray *subThreadIds;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventId;
@property bool threadingUsed;
@property int numberOfMessages;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *receivedDate;
@property (nonatomic, retain) NSString *isReminder;
@property BOOL wasViewed;
@property (nonatomic, retain) NSArray *pollChoices;
@property (nonatomic, retain) NSString *followUp;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *senderId;

@end
