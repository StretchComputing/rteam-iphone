//
//  Notes.m
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Gameday.h"
#import "GameMessages.h"
#import "GameAttendance.h"

@implementation Game
@synthesize startDate, endDate, timeZone, gameId, teamId, description, latitude, longitude, opponent, userRole, scoreUs, scoreThem, interval, 
sport, teamName, location, mvp, hasMvp;



- (void)dealloc {
    [startDate release];
	[endDate release];
	[timeZone release];
	[gameId release];
	[teamId release];
	[description release];
	[latitude release];
	[longitude release];
	[opponent release];
	[userRole release];
	[scoreUs release];
	[scoreThem release];
	[interval release];
	[sport release];
	[teamName release];
	[location release];
	[mvp release];
	[super dealloc];
	
}

@end
