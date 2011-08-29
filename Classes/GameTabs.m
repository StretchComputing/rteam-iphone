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
#import "GameMessages.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "TeamActivity.h"
#import "Fans.h"
#import "Home.h"
#import "FastActionSheet.h"
#import "Vote.h"
#import "GameChatter.h"

@implementation GameTabs

@synthesize startDate, endDate, timeZone, gameId, teamId, description, latitude, longitude, opponent, userRole, messageCount, messageSuccess,
teamName, newActivity, fromHome;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
	
	
	
	//[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	
	int index = self.selectedIndex;
	
	if (index == 100) {
		//GameChatter *tmp = [self.viewControllers objectAtIndex:1];
		//[tmp viewWillAppear:NO];
	}else if (index == 1) {
		GameAttendance *tmp = [self.viewControllers objectAtIndex:1];
		[tmp viewWillAppear:NO];
	}else if (index == 33) {
		GameMessages *tmp = [self.viewControllers objectAtIndex:3];
		[tmp viewWillAppear:NO];
	}else if (index == 2) {
		Vote *tmp = [self.viewControllers objectAtIndex:2];
		[tmp viewWillAppear:NO];
	}else {
		//OBJECT AT INDEX 0
		Gameday *tmp = [self.viewControllers objectAtIndex:0];
		[tmp viewWillAppear:NO];
		self.navigationItem.title = self.teamName;
	}
	
	if (self.fromHome) {
		UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
		[self.navigationItem setLeftBarButtonItem:homeButton];
		[homeButton release];
	}
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}
- (void)viewDidLoad {

	
	self.tabBar.backgroundColor = [UIColor greenColor];
	self.title = @"GameDay";
	
	Gameday *tab1 =  
	[[[Gameday alloc] init] autorelease]; 
	TeamActivity *tab2 =  
	[[[TeamActivity alloc] init] autorelease];  
	GameAttendance *tab3 =  
	[[[GameAttendance alloc] init] autorelease]; 
	//GameMessages *tab4 =  
	//[[[GameMessages alloc] init] autorelease]; 
	Vote *tab5 =  
	[[[Vote alloc] init] autorelease]; 
	GameChatter *tab6 =  
	[[[GameChatter alloc] init] autorelease]; 
	
	tab1.teamId = self.teamId;
	tab1.gameId = self.gameId;
	tab1.userRole = self.userRole;
	tab1.title = @"Game Day";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsGameday.png"];
	
	//tab2.teamId = self.teamId;
	//tab2.gameId = self.gameId;
	tab2.title = @"Activity";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabsChatter.png"];
	
	tab3.teamId = self.teamId;
	tab3.gameId = self.gameId;
	//tab3.startDate = self.startDate;
	tab3.title = @"Attendance";
	tab3.tabBarItem.image = [UIImage imageNamed:@"attendance.png"];
	
	tab6.teamId = self.teamId;
	tab6.gameId = self.gameId;
	tab6.title = @"Messages";
	tab6.userRole = self.userRole;
	tab6.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	
	//tab5.teamId = self.teamId;
	//tab5.gameId = self.gameId;
	tab5.title = @"Vote";
	tab5.tabBarItem.image = [UIImage imageNamed:@"fans.png"];

	
	
	
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
	}else if ([viewController class] == [GameChatter class]) {
		//GameChatter *tmp = (GameChatter *)viewController;
		//[tmp viewWillAppear:NO];
	}else if ([viewController class] == [GameAttendance class]) {
		GameAttendance *tmp = (GameAttendance *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [TeamActivity class]) {
		TeamActivity *tmp = (TeamActivity *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [Vote class]) {
		Vote *tmp = (Vote *)viewController;
		[tmp viewWillAppear:NO];
	}

	
}

-(void)getMessageThreadCount{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreadCount:token :self.teamId :self.gameId :@"game" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.messageSuccess = true;
			
			self.messageCount = [[response valueForKey:@"count"] intValue];
			
			self.newActivity = [[response valueForKey:@"newActivity"] boolValue];

		}else{
			self.messageSuccess = false;
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
		
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(finishedMessageCount)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
	
	
}

-(void)finishedMessageCount{
	
	if (self.messageSuccess) {
		
		/*
		GameChatter *tmpItem = [self.viewControllers objectAtIndex:1];
		
		if (self.messageCount > 0){
			
			tmpItem.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.messageCount];
		}else {
			tmpItem.tabBarItem.badgeValue = nil;

		}
*/
	
	}
	
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
		[actionSheet release];
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
	[teamName release];
	[super dealloc];
	
}

@end
