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
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "FastActionSheet.h"

@implementation PracticeTabs
@synthesize startDate, endDate, timeZone, practiceId, teamId, description, latitude, longitude, location, userRole, messageCount, messageSuccess, fromHome;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
		
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
	}
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (void)viewDidLoad {
	
	self.delegate = self;
	PracticeNotes *tab1 =  
	[[PracticeNotes alloc] init];  
 
	PracticeAttendance *tab3 =  
	[[PracticeAttendance alloc] init]; 
	 
	
	tab1.teamId = self.teamId;
	tab1.practiceId = self.practiceId;
	tab1.title = @"PracticeDay";
	tab1.tabBarItem.image = [UIImage imageNamed:@"pday.png"];
	
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

	
}


@end
