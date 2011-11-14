//
//  TeamNavigation.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamNavigation.h"
#import "CurrentTeamTabs.h"
#import "Players.h"
#import "Fans.h"
#import "EventList.h"
#import "TeamHome.h"

@implementation TeamNavigation
@synthesize teamName, teamId, userRole, sport, teamUrl, fromHome;

-(void)viewDidLoad{
	
	CurrentTeamTabs *tmp = [[CurrentTeamTabs alloc] init];
	
    tmp.fromHome = true;
	NSArray *viewControllers = tmp.viewControllers;
	
	tmp.teamId = self.teamId;
	tmp.teamName = self.teamName;
	tmp.userRole = self.userRole;
	tmp.title = self.teamName;
	tmp.sport = self.sport;
	
	//UIViewController *teamPage = [viewControllers objectAtIndex:0];
	//teamPage.teamId = self.teamId;
	//teamPage.userRole = self.userRole;
	TeamHome *home = [viewControllers objectAtIndex:0];
	home.teamId = self.teamId;
	home.userRole = self.userRole;
	home.teamSport = self.sport;
	home.teamName = self.teamName;
	home.teamUrl = self.teamUrl;
    home.fromHome = self.fromHome;
	
	//TeamActivity *activity = [viewControllers objectAtIndex:1];
	//activity.teamId = self.teamId;
	//activity.userRole = self.userRole;
	
	Players *people = [viewControllers objectAtIndex:1];
	people.teamId = self.teamId;
	people.userRole = self.userRole;
	people.teamName = self.teamName;
	
	EventList *events = [viewControllers objectAtIndex:2];
	events.teamId = self.teamId;
	events.userRole = self.userRole;
	events.sport = self.sport;
	events.teamName = self.teamName;
	
	//TeamMessages *message = [viewControllers objectAtIndex:4];
	//message.teamId = self.teamId;
	//message.userRole = self.userRole;
	
	
	[self pushViewController:tmp animated:YES];
	
}

-(void)viewDidUnload{
	
	/*
     teamName = nil;
     teamId = nil;
     userRole = nil;
     sport = nil;
     teamUrl = nil;
	 */
	[super viewDidUnload];
}

@end
