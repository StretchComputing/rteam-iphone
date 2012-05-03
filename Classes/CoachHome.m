//
//  CoachHome.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoachHome.h"
#import "Register.h"
#import "rTeamAppDelegate.h"
#import "Team.h"
#import "ServerAPI.h"
#import "Home.h"
#import "SettingsTabs.h"
#import "TraceSession.h"

@implementation CoachHome
@synthesize logout;
-(void)viewWillAppear:(BOOL)animated{
	
    [TraceSession addEventToSession:@"CoachHome - View Will Appear"];

	NSString *token = @"";
	//If there is already a valid token and teams created, go straight to team page
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	if (![token isEqualToString:@""]){
		
		if ([token isEqualToString:@"logout"]) {
			mainDelegate.token = @"";
			self.logout = true;
		}else {
			SettingsTabs *nextController = [[SettingsTabs alloc] init];
			nextController.fromRegisterFlow = @"true";
			nextController.didRegister = @"false";
			[self.navigationController  pushViewController:nextController animated:NO];
		}
		
	}else{
		
		Register *nextController = [[Register alloc] init];
		[self.navigationController  pushViewController:nextController animated:NO]; 
		
		
	}
	
	
}

-(void)viewDidAppear:(BOOL)animated{
	
	if (self.logout) {
		Register *nextController = [[Register alloc] init];
		[self.navigationController  pushViewController:nextController animated:NO]; 
	}
	
}
- (void)viewDidLoad {
	
    self.title = @"";
	
    
}




-(IBAction)userRegister {
	
    Register *nextController = [[Register alloc] init];
    [self.navigationController  pushViewController:nextController animated:YES]; 
    
}


- (void)viewDidUnload {
	
	[super viewDidUnload];
}



@end
