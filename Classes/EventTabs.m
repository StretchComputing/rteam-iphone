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
#import "EventMessages.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation EventTabs
@synthesize startDate, endDate, timeZone, eventId, teamId, description, latitude, longitude, location, userRole, messageCount, messageSuccess, fromHome;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
	
	[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	
	int index = self.selectedIndex;
	
	if (index == 1) {
		EventAttendance *tmp = [self.viewControllers objectAtIndex:1];
		[tmp viewWillAppear:NO];
	}else {
		//OBJECT AT INDEX 0
		EventNotes *tmp = [self.viewControllers objectAtIndex:0];
		[tmp viewWillAppear:NO];
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
	
	self.delegate = self;
	EventNotes *tab1 =  
	[[[EventNotes alloc] init] autorelease];  
	EventMessages *tab2 =  
	[[[EventMessages alloc] init] autorelease];  
	EventAttendance *tab3 =  
	[[[EventAttendance alloc] init] autorelease]; 
	
	
	tab1.teamId = self.teamId;
	tab1.eventId = self.eventId;
	tab1.title = @"Event Day";
	tab1.tabBarItem.image = [UIImage imageNamed:@"eventDay.png"];
	
	tab2.teamId = self.teamId;
	tab2.eventId = self.eventId;
	tab2.userRole = self.userRole;
	tab2.title = @"Messages";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	
	tab3.teamId = self.teamId;
	tab3.eventId = self.eventId;
	tab3.title = @"Attendance";
	tab3.tabBarItem.image = [UIImage imageNamed:@"attendance.png"];
	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab3, nil]; 

	
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
		
		
		NSDictionary *response = [ServerAPI getMessageThreadCount:token :self.teamId :self.eventId :@"practice" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.messageSuccess = true;
			
			self.messageCount = [[response valueForKey:@"count"] intValue];
			
			
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
		
		
		EventMessages *tmpItem = [self.viewControllers objectAtIndex:1];
		
		if (self.messageCount > 0){
			
			tmpItem.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.messageCount];
		}else {
			tmpItem.tabBarItem.badgeValue = nil;

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
	/*
	startDate = nil;
	endDate = nil;
	timeZone = nil;
	eventId = nil;
	teamId = nil;
	description = nil;
	latitude = nil;
	longitude = nil;
	location = nil;
	userRole = nil;
	 */
	[super viewDidUnload];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
	[super dealloc];
	
}


@end
