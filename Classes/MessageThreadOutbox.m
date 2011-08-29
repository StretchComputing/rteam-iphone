//
//  MessageThreadOutbox.m
//  iCoach
//
//  Created by Nick Wroblewski on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageThreadOutbox.h"


@implementation MessageThreadOutbox
@synthesize threadId, subject, body, messageType, status, createdDate, numRecipients, numReplies, followUp, teamId, teamName, eventId, numberOfMessages,
threadingUsed, eventType, subThreadIds, eventDate;


-(void)dealloc{
	
	[teamId release];
	[subThreadIds release];
	[eventType release];
	[threadId release];
	[eventId release];
	[subject release];
	[eventDate release];
	[body release];
	[status release];
	[messageType release];
	[createdDate release];
	[numRecipients release];
	[numReplies release];
	[followUp release];
	[teamName release];
	[super dealloc];
	
}
@end
