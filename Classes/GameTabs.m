//
//  GameTabs.m
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameTabs.h"
#import "GameAttendance.h"
#import "Gameday.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Home.h"
#import "FastActionSheet.h"
#import "Vote.h"
#import "TraceSession.h"

@implementation GameTabs

@synthesize startDate, endDate, timeZone, gameId, teamId, description, latitude, longitude, opponent, userRole, messageCount, messageSuccess,
teamName, newActivity, fromHome, fromActivity;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
	
    [TraceSession addEventToSession:@"GameTabs - View Will Appear"];

	int index = self.selectedIndex;
	
	if (index == 100) {
		//GameChatter *tmp = [self.viewControllers objectAtIndex:1];
		//[tmp viewWillAppear:NO];
	}else if (index == 1) {
		//GameAttendance *tmp = [self.viewControllers objectAtIndex:1];
		//[tmp viewWillAppear:NO];
	}else if (index == 2) {
		//Vote *tmp = [self.viewControllers objectAtIndex:2];
		//[tmp viewWillAppear:NO];
	}else {
		//OBJECT AT INDEX 0
		Gameday *tmp = [self.viewControllers objectAtIndex:0];
        tmp.teamName = self.teamName;
		[tmp viewWillAppear:NO];
		self.navigationItem.title = self.teamName;
	}
	
	if (self.fromHome) {
		UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
		[self.navigationItem setLeftBarButtonItem:homeButton];
	}
    
    if (self.fromActivity) {
        //self.fromActivity = false;
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Activity" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
		[self.navigationItem setLeftBarButtonItem:homeButton];
    }
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}
- (void)viewDidLoad {
	
	self.tabBar.backgroundColor = [UIColor greenColor];
	self.title = @"GameDay";
	
	Gameday *tab1 =  
	[[Gameday alloc] init]; 

	GameAttendance *tab3 =  
	[[GameAttendance alloc] init]; 
	//GameMessages *tab4 =  
	//[[[GameMessages alloc] init] autorelease]; 
	Vote *tab5 =  
	[[Vote alloc] init]; 

	
	//tab1.teamId = self.teamId;
	//tab1.gameId = self.gameId;
	tab1.userRole = self.userRole;
	tab1.title = @"Game Day";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsGameday.png"];

	
	tab3.teamId = self.teamId;
	tab3.gameId = self.gameId;
	//tab3.startDate = self.startDate;
	tab3.title = @"Attendance";
	tab3.tabBarItem.image = [UIImage imageNamed:@"tabsAttendance.png"];
	

	//tab5.teamId = self.teamId;
	//tab5.gameId = self.gameId;
	tab5.title = @"Vote";
	tab5.tabBarItem.image = [UIImage imageNamed:@"tabsVote.png"];

	
	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab3, tab5, nil]; 
	
	self.delegate = self;


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComeBack:) 
												 name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)didComeBack:(id)sender{
	
	
	if (self == self.navigationController.visibleViewController) {
		
		[self viewWillAppear:NO];
	}
	
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
		self.navigationItem.title = self.teamName;
	
	if ([viewController class] == [Gameday class]) {
		Gameday *tmp = (Gameday *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [GameAttendance class]) {
		GameAttendance *tmp = (GameAttendance *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [Vote class]) {
		Vote *tmp = (Vote *)viewController;
		[tmp viewWillAppear:NO];
	}

	
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewDidUnload {
	/*
	startDate = nil;
	endDate = nil;
	timeZone = nil;
	gameId = nil;
	teamId = nil;
	description = nil;
	latitude = nil;
	longitude = nil;
	opponent = nil;
	userRole = nil;
	teamName = nil;
	 */
	[super viewDidUnload];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
   	
}

@end
