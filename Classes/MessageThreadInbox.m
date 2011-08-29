//
//  MessageThread.m
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageThreadInbox.h"


@implementation MessageThreadInbox
@synthesize threadId, subject, body, messageType, status, receivedDate, isReminder, wasViewed, pollChoices, followUp, senderName, senderId,
teamId, teamName, threadingUsed, numberOfMessages, eventId, eventType, subThreadIds, eventDate, participantRole;



-(void)dealloc{
	
	[threadId release];
	[subThreadIds release];
	[subject release];
	[eventType release];
	[body release];
	[status release];
	[eventDate release];
	[messageType release];
	[receivedDate release];
	[isReminder release];
	//[wasViewed release];
	[pollChoices release];
	[followUp release];
	[senderId release];
	[senderName release];
	[teamId release];
	[teamName release];
	[eventId release];
    [participantRole release];
	[super dealloc];
	
}
@end
