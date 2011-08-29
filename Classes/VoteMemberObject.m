//
//  VoteMemberObject.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VoteMemberObject.h"


@implementation VoteMemberObject
@synthesize memberName, memberId, numVotes;

-(void)dealloc{
	
	[memberName release];
	[memberId release];
	[super dealloc];
	
}

@end
