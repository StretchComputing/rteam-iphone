//
//  Team.m
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Team.h"

@implementation Team
@synthesize name, teamId, userRole, sport, useTwitter, teamUrl;



- (id) init {
    self = [super init];
	if (self){
		name = [[NSString alloc] init];
		teamId = [[NSString alloc] init];
		userRole = [[NSString alloc] init];
		sport = [[NSString alloc] init];
		teamUrl = [[NSString alloc] init];

	}
	
	return self;
}

- (void)dealloc {
	
	[name release];
	[teamId release];
	[userRole release];
	[sport release];
	[teamUrl release];
	[super dealloc];
}




@end
