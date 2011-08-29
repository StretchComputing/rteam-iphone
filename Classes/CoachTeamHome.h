//
//  CoachTeamHome.h
//  iCoach
//
//  Created by Nick Wroblewski on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CoachTeamHome : SecondLevelViewController {

	NSArray *teams;
	IBOutlet UIView *header;
	IBOutlet UIView *footer;
	NSString *didLoad;
	NSString *didRegister;
	int deleteRow;
	int teamsStored;
	int numMemberTeams;
	
	UIAlertView *alertOne;
	UIAlertView *alertTwo;
}

@property (nonatomic, retain) NSArray *teams;
@property (nonatomic, retain) UIView *header;
@property (nonatomic, retain) UIView *footer;
@property (nonatomic, retain) NSString *didLoad;
@property (nonatomic, retain) NSString *didRegister;
@property int deleteRow;
@property int teamsStored;
@property int numMemberTeams;

-(IBAction)create;
- (IBAction) EditTable:(id)sender;

@end
