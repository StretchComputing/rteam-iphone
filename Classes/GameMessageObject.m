//
//  GameMessageObject.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameMessageObject.h"


@implementation GameMessageObject
@synthesize threadId, teamId, subject, body, status, messageDate, senderName, senderId, teamName;

-(void)dealloc{
	
	[teamId release];
	[threadId release];
	[subject release];
	[body release];
	[status release];
	[messageDate release];
	[senderName release];
	[senderId release];
	[teamName release];
	[super dealloc];
}

@end
