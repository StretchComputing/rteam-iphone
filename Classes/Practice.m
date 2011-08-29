//
//  Web.m
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Practice.h"

@implementation Practice
@synthesize startDate, endDate, timeZone, practiceId, ppteamId, description, latitude, longitude, location, userRole, teamName, isCanceled;


- (void)dealloc {
    [startDate release];
	[endDate release];
	[timeZone release];
	[practiceId release];
	[ppteamId release];
	[description release];
	[latitude release];
	[longitude release];
	[location release];
	[userRole release];
	[teamName release];
	[super dealloc];

}


@end
