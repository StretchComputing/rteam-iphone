//
//  EventTabs.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventTabs.h"
#import "EventNotes.h"
#import "EventAttendance.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation EventTabs
@synthesize startDate, endDate, timeZone, eventId, teamId, description, latitude, longitude, location, userRole, messageCount, messageSuccess, fromHome;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
	
	
    [TraceSession addEventToSession:@"EventTabs - View Will Appear"];

	int index = self.selectedIndex;
	
	if (index == 1) {
		EventAttendance *tmp = (self.viewControllers)[1];
		[tmp viewWillAppear:NO];
	}else {
		//OBJECT AT INDEX 0
		EventNotes *tmp = (self.viewControllers)[0];
		[tmp viewWillAppear:NO];
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
	
	self.delegate = self;
	EventNotes *tab1 =  
	[[EventNotes alloc] init];  

	EventAttendance *tab3 =  
	[[EventAttendance alloc] init ]; 
	
	
	tab1.teamId = self.teamId;
	tab1.eventId = self.eventId;
	tab1.title = @"Event Day";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsEday.png"];
	

	
	tab3.teamId = self.teamId;
	tab3.eventId = self.eventId;
	tab3.title = @"Attendance";
	tab3.tabBarItem.image = [UIImage imageNamed:@"tabsAttendance.png"];
	
	
	self.viewControllers = @[tab1, tab3]; 

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComeBack:) 
												 name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)didComeBack:(id)sender{
	
	
	if (self == self.navigationController.visibleViewController) {
		
		[self viewWillAppear:NO];
	}
	
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
	self.navigationItem.title = viewController.tabBarItem.title;
	
	if ([viewController class] == [EventNotes class]) {
		EventNotes *tmp = (EventNotes *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [EventAttendance class]) {
		EventAttendance *tmp = (EventAttendance *)viewController;
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

	[super viewDidUnload];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
   
	
}


@end
