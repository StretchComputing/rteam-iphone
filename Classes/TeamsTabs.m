//
//  TeamsTabs.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamsTabs.h"
#import "MyTeams.h"
#import "InviteFan.h"
#import "CreateTeam.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation TeamsTabs
@synthesize quickCreate;



-(void)viewDidAppear:(BOOL)animated{
	
	if (self.quickCreate) {
		self.quickCreate = false;
		CreateTeam *tmp = [[CreateTeam alloc] init];
        tmp.fromHome = true;
		[self.navigationController pushViewController:tmp animated:NO];
		
	}
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (mainDelegate.returnHome) {
		mainDelegate.returnHome = NO;
		[self.navigationController popViewControllerAnimated:NO];
	}
	
	[self becomeFirstResponder];
    
    
}

- (void)viewDidLoad {
    
	self.title = @"My Teams";
	
	MyTeams *tab1 =  
	[[MyTeams alloc] init];  
	UIViewController *tab2 =  
	[[UIViewController alloc] init];  
    
	UIViewController *tab4 =  
	[[UIViewController alloc] init]; 
	InviteFan *tab5 = [[InviteFan alloc] init];
	
	tab1.title = @"My Teams";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabsMyTeams.png"];	
	tab2.title = @"Leagues";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabsLeagues.png"];
	tab4.title = @"Archived Teams";
	tab4.tabBarItem.image = [UIImage imageNamed:@"tabsArchivedTeams.png"];
	tab5.title = @"Invite A Fan";
	tab5.tabBarItem.image = [UIImage imageNamed:@"tabsInviteFan.png"];
	tab5.noRightButton = true;
	
	
	//self.viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab4, tab5, nil]; 
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab5, nil];
	
	
	self.delegate = self;
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
	/*
     self.navigationItem.title = viewController.tabBarItem.title;
     
     if ([viewController class] == [MyTeams class]) {
     MyTeams *tmp = (MyTeams *)viewController;
     [tmp viewWillAppear:NO];
     }else if ([viewController class] == [InviteFan class]) {
     InviteFan *tmp = (InviteFan *)viewController;
     [tmp viewWillAppear:NO];
     }
	 */
	
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


@end
