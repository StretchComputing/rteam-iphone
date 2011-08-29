//
//  Event.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize startDate, endDate, timeZone, eventId, teamId, description, latitude, longitude, location, userRole, eventName, teamName, isCanceled;


- (void)dealloc {
    [startDate release];
	[endDate release];
	[timeZone release];
	[eventId release];
	[teamId release];
	[description release];
	[latitude release];
	[longitude release];
	[location release];
	[userRole release];
	[eventName release];
	[teamName release];
	[super dealloc];
	
}


@end
