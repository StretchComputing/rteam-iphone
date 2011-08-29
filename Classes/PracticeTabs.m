//
//  PracticeTabs.m
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "PracticeMessages.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "FastActionSheet.h"
#import "PracticeChatter.h"

@implementation PracticeTabs
@synthesize startDate, endDate, timeZone, practiceId, teamId, description, latitude, longitude, location, userRole, messageCount, messageSuccess, fromHome;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
	
	//[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	
	int index = self.selectedIndex;
	
	if (index == 1) {
		PracticeAttendance *tmp = [self.viewControllers objectAtIndex:1];
		[tmp viewWillAppear:NO];
	}else if (index == 22){
		//PracticeChatter *tmp = [self.viewControllers objectAtIndex:2];
		//[tmp viewWillAppear:NO];
	
	}else {
		//OBJECT AT INDEX 0
		PracticeNotes *tmp = [self.viewControllers objectAtIndex:0];
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
	PracticeNotes *tab1 =  
	[[[PracticeNotes alloc] init] autorelease];  
	PracticeChatter *tab2 =  
	[[[PracticeChatter alloc] init] autorelease];  
	PracticeAttendance *tab3 =  
	[[[PracticeAttendance alloc] init] autorelease]; 
	 
	
	tab1.teamId = self.teamId;
	tab1.practiceId = self.practiceId;
	tab1.title = @"PracticeDay";
	tab1.tabBarItem.image = [UIImage imageNamed:@"pday.png"];
	
	tab2.teamId = self.teamId;
	tab2.practiceId = self.practiceId;
	tab2.userRole = self.userRole;
	tab2.title = @"Messages";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	
	tab3.teamId = self.teamId;
	tab3.practiceId = self.practiceId;
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
	
	
	if ([viewController.tabBarItem.title isEqualToString:@"PracticeDay"]) {
		self.navigationItem.title = @"Practice Day";
	}else {
		self.navigationItem.title = viewController.tabBarItem.title;
	}
	
	if ([viewController class] == [PracticeNotes class]) {
		PracticeNotes *tmp = (PracticeNotes *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [PracticeAttendance class]) {
		PracticeAttendance *tmp = (PracticeAttendance *)viewController;
		[tmp viewWillAppear:NO];
	}else if ([viewController class] == [PracticeChatter class]) {
		//PracticeChatter *tmp = (PracticeChatter *)viewController;
		//[tmp viewWillAppear:NO];
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
		
		
		NSDictionary *response = [ServerAPI getMessageThreadCount:token :self.teamId :self.practiceId :@"practice" :@""];
		
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
		
		/*
		PracticeChatter *tmpItem = [self.viewControllers objectAtIndex:2];
		
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
	practiceId = nil;
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
	[practiceId release];
	[teamId release];
	[description release];
	[latitude release];
	[longitude release];
	[location release];
	[userRole release];
	[super dealloc];
	
}


@end
