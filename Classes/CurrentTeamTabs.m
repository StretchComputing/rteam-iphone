//
//  CurrentTeamTabs.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CurrentTeamTabs.h"
#import "Players.h"
#import "Fans.h"
#import "SendMessage.h"
#import "EventList.h"
#import "MessagesInbox.h"
#import "TeamMessages.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TeamActivity.h"
#import "TeamHome.h"
#import "Home.h"
#import "FastActionSheet.h"

@implementation CurrentTeamTabs
//@synthesize navBar, tabBar;
@synthesize teamId, teamName, userRole, toTeam, recipients, sport, messageSuccess, messageCount, newActivity, tookPicture;


-(void)viewDidAppear:(BOOL)animated{
	
	if (self.tookPicture) {
		self.tookPicture = false;
	}else {
		[self becomeFirstResponder];
	}
	
}

-(void)viewWillAppear:(BOOL)animated{
		
	[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	[self.navigationItem setHidesBackButton:YES];
	
	int index = self.selectedIndex;
	
		
	if (index == 11) {
		//TeamActivity *tmp = [self.viewControllers objectAtIndex:1];
		//[tmp viewWillAppear:NO];
	}else if (index == 1) {
		Players *tmp = [self.viewControllers objectAtIndex:1];
		[tmp viewWillAppear:NO];
	}else if (index == 2) {
		EventList *tmp = [self.viewControllers objectAtIndex:2];
		[tmp viewWillAppear:NO];
	}else if (index == 4) {
		//TeamMessages *tmp = [self.viewControllers objectAtIndex:4];
		//[tmp viewWillAppear:NO];
	}else {
		//OBJECT AT INDEX 0
		TeamHome *tmp = [self.viewControllers objectAtIndex:0];
		[tmp viewWillAppear:NO];
	}

	
}


- (void)viewDidLoad {
	
	self.title = self.teamName;

	
	TeamHome *tab1 =  
	[[[TeamHome alloc] init] autorelease];  
	TeamActivity *tab2 =  
	[[[TeamActivity alloc] init] autorelease];  
	Players *tab3 =  
	[[[Players alloc] init] autorelease]; 
	EventList *tab4 =  
	[[[EventList alloc] init] autorelease]; 
	TeamMessages *tab5 = [[[TeamMessages alloc] init] autorelease];
	
	tab1.title = @"Team";
	//tab1.userRole = self.userRole;
	//tab1.teamId = self.teamId;
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsHomepage.png"];
	
	tab2.title = @"Activity";
	//tab2.teamId = self.teamId;
	//tab2.userRole = self.userRole;
	tab2.tabBarItem.image =[UIImage imageNamed:@"tabsChatter.png"];
	
	tab3.title = @"People";
	tab3.teamId = self.teamId;
	tab3.userRole = self.userRole;
	tab3.tabBarItem.image =[UIImage imageNamed:@"tabsPeople.png"];
	
	tab4.title = @"Events";
	tab4.teamId = self.teamId;
	tab4.userRole = self.userRole;
	tab4.sport = self.sport;
	tab4.tabBarItem.image =[UIImage imageNamed:@"tabsEvents.png"];
	
	tab5.title = @"Messages";
	tab5.teamId = self.teamId;
	tab5.userRole = self.userRole;
	//tab5.tabBarItem.badgeValue = @"!";
	tab5.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab3, tab4, nil]; 
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
	[self.navigationItem setRightBarButtonItem:addButton];
	[addButton release];
	
	self.delegate = self;
	
	if (self.selectedIndex == 4) {
		self.title = @"Messages";
	}
	
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Team" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;

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
	
	if ([viewController class] == [TeamActivity class]) {
		TeamActivity *tmp = (TeamActivity *)viewController;
		[tmp viewWillAppear:NO];
		
		TeamHome *teamHome = (TeamHome *)[self.viewControllers objectAtIndex:0];
		[teamHome viewWillDisappear:NO];

		Players *players = (Players *)[self.viewControllers objectAtIndex:2];
		[players viewWillDisappear:NO];
		EventList *eventList = (EventList *)[self.viewControllers objectAtIndex:3];
		[eventList viewWillDisappear:NO];
		//TeamMessages *teamMessages = (TeamMessages *)[self.viewControllers objectAtIndex:4];
		//[teamMessages viewWillDisappear:NO];
		
		
	}else if ([viewController class] == [TeamHome class]) {
		TeamHome *tmp = (TeamHome *)viewController;
		[tmp viewWillAppear:NO];
		
	
		//TeamActivity *teamActivity = (TeamActivity *)[self.viewControllers objectAtIndex:1];
		//[teamActivity viewWillDisappear:NO];
		Players *players = (Players *)[self.viewControllers objectAtIndex:1];
		[players viewWillDisappear:NO];
		EventList *eventList = (EventList *)[self.viewControllers objectAtIndex:2];
		[eventList viewWillDisappear:NO];
		///TeamMessages *teamMessages = (TeamMessages *)[self.viewControllers objectAtIndex:4];
		//[teamMessages viewWillDisappear:NO];
		
	}else if ([viewController class] == [TeamMessages class]) {
		TeamMessages *tmp = (TeamMessages *)viewController;
		[tmp viewWillAppear:NO];
		
		TeamHome *teamHome = (TeamHome *)[self.viewControllers objectAtIndex:0];
		[teamHome viewWillDisappear:NO];
		//TeamActivity *teamActivity = (TeamActivity *)[self.viewControllers objectAtIndex:1];
		//[teamActivity viewWillDisappear:NO];
		Players *players = (Players *)[self.viewControllers objectAtIndex:1];
		[players viewWillDisappear:NO];
		EventList *eventList = (EventList *)[self.viewControllers objectAtIndex:2];
		[eventList viewWillDisappear:NO];
	
	}else if ([viewController class] == [Players class]) {
		Players *tmp = (Players *)viewController;
		[tmp viewWillAppear:NO];
		
		TeamHome *teamHome = (TeamHome *)[self.viewControllers objectAtIndex:0];
		[teamHome viewWillDisappear:NO];
		//TeamActivity *teamActivity = (TeamActivity *)[self.viewControllers objectAtIndex:1];
		//[teamActivity viewWillDisappear:NO];

		EventList *eventList = (EventList *)[self.viewControllers objectAtIndex:2];
		[eventList viewWillDisappear:NO];
		//TeamMessages *teamMessages = (TeamMessages *)[self.viewControllers objectAtIndex:4];
		//[teamMessages viewWillDisappear:NO];
		
	}else if ([viewController class] == [EventList class]) {
		
		EventList *tmp = (EventList *)viewController;
		[tmp viewWillAppear:NO];
		
		TeamHome *teamHome = (TeamHome *)[self.viewControllers objectAtIndex:0];
		[teamHome viewWillDisappear:NO];
		//TeamActivity *teamActivity = (TeamActivity *)[self.viewControllers objectAtIndex:1];
		//[teamActivity viewWillDisappear:NO];
		Players *players = (Players *)[self.viewControllers objectAtIndex:1];
		[players viewWillDisappear:NO];

		//TeamMessages *teamMessages = (TeamMessages *)[self.viewControllers objectAtIndex:4];
		//[teamMessages viewWillDisappear:NO];
		
	}

}

-(void)done{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
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
		
		
		NSDictionary *response = [ServerAPI getMessageThreadCount:token :self.teamId :@"" :@"" :@""];
		
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
		TeamMessages *tmpItem = [self.viewControllers objectAtIndex:4];
	
		if (self.messageCount > 0){
		
			tmpItem.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.messageCount];
		}else {
			tmpItem.tabBarItem.badgeValue = nil;

		}
         */
		
		TeamActivity *tmpAct = [self.viewControllers objectAtIndex:1];
		if (self.newActivity) {
			tmpAct.tabBarItem.badgeValue = @"!";
		}else {
			tmpAct.tabBarItem.badgeValue = nil;
		}


		
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
	
    [super viewDidUnload];
}

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[teamId release];
	[teamName release];
	[userRole release];
	[recipients release];
	[sport release];

	[super dealloc];
}



@end
