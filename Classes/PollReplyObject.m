//
//  PollReplyObject.m
//  iCoach
//
//  Created by Nick Wroblewski on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PollReplyObject.h"


@implementation PollReplyObject
@synthesize name, dateReplied, reply, memberId, teamId;

-(void)dealloc{
	[name release];
	[dateReplied release];
	[reply release];
	[memberId release];
	[teamId release];
	[super dealloc];
}

@end
