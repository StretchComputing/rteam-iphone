//
//  GameTabsNoCoord.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameTabsNoCoord.h"
#import "GameAttendance.h"
#import "Gameday.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Fans.h"
#import "Home.h"
#import "FastActionSheet.h"
#import "Vote.h"

@implementation GameTabsNoCoord

@synthesize startDate, endDate, timeZone, gameId, teamId, description, latitude, longitude, opponent, userRole, messageCount, messageSuccess, 
teamName, newActivity, fromHome;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{

	
	//[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	
	int index = self.selectedIndex;
	
	if (index == 1) {
		Vote *tmp = [self.viewControllers objectAtIndex:1];
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
	}
	
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (void)viewDidLoad {
	
	self.title = @"Game Info:";
	
	Gameday *tab1 =  
	[[Gameday alloc] init]; 

	Vote *tab4 =  
	[[Vote alloc] init]; 
	
	tab1.teamId = self.teamId;
	tab1.gameId = self.gameId;
	tab1.title = @"GameDay";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsGameday.png"];

	
	//tab5.teamId = self.teamId;
	//tab5.gameId = self.gameId;
	tab4.title = @"Vote";
	tab4.tabBarItem.image = [UIImage imageNamed:@"fans.png"];

	
	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab4, nil]; 
	
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
	
		self.navigationItem.title = self.navigationItem.title = self.teamName;

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

-(void)getMessageThreadCount{
	
	
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