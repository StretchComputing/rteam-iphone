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
#import "EventList.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TeamHome.h"
#import "Home.h"
#import "FastActionSheet.h"

@implementation CurrentTeamTabs
//@synthesize navBar, tabBar;
@synthesize teamId, teamName, userRole, toTeam, recipients, sport, messageSuccess, messageCount, newActivity, tookPicture, fromHome;


-(void)viewDidAppear:(BOOL)animated{
	
	if (self.tookPicture) {
		self.tookPicture = false;
	}else {
		[self becomeFirstResponder];
	}
	
}

-(void)viewWillAppear:(BOOL)animated{
		
    if (self.fromHome) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
        [self.navigationItem setLeftBarButtonItem:addButton];
    }
	//[self.navigationItem setHidesBackButton:YES];
	
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
	[[TeamHome alloc] init];  

	Players *tab3 =  
	[[Players alloc] init]; 
	EventList *tab4 =  
	[[EventList alloc] init]; 
	
	tab1.title = @"Team";
	//tab1.userRole = self.userRole;
	//tab1.teamId = self.teamId;
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsHomepage.png"];
	
	tab3.title = @"People";
	tab3.teamId = self.teamId;
	tab3.userRole = self.userRole;
	tab3.tabBarItem.image =[UIImage imageNamed:@"tabsPeople.png"];
	
	tab4.title = @"Events";
	tab4.teamId = self.teamId;
	tab4.userRole = self.userRole;
	tab4.sport = self.sport;
	tab4.tabBarItem.image =[UIImage imageNamed:@"tabsEvents.png"];
	

	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab3, tab4, nil]; 

	
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
	
	if ([viewController class] == [TeamHome class]) {
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
	
    [super viewDidUnload];
}

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}



@end
