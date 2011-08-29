//
//  MessageThreadOutbox.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageThreadOutbox : UIViewController {
	
	NSString *threadId;
	NSString *subject;
	NSString *body;
	NSString *messageType; //poll, message
	NSString *status;      //active, all
	NSString *numRecipients;
	NSString *numReplies;
	NSString *followUp;
	NSString *teamId;
	NSString *teamName;
	
	//Threads
	int numberOfMessages;
	NSString *eventId;
	NSString *eventType;
	NSArray *subThreadIds;
	NSString *eventDate;
	
	//Both
	bool threadingUsed;
	NSString *createdDate;   //date of most recent message if threading
	

}
@property (nonatomic, retain) NSString *eventDate;
@property (nonatomic, retain) NSArray *subThreadIds;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventId;
@property int numberOfMessages;
@property bool threadingUsed;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *createdDate;
@property (nonatomic, retain) NSString *numRecipients;
@property (nonatomic, retain) NSString *numReplies;
@property (nonatomic, retain) NSString *followUp;

@end
