//
//  NewGamePractice.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewGamePractice.h"
#import "NewGame2.h"
#import "NewPractice2.h"
#import "NewEvent2.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "RecurringEventSelection.h"

@implementation NewGamePractice
@synthesize teamId, startDate, practiceOrGame, createButton, recurringEventButton, singleLabel;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"New Event";
	
	self.singleLabel.text = @"Single Game Date/Time";
	NSDate *minDate = [NSDate date];
	
	//self.startDate.minimumDate = minDate;
	minDate = [minDate dateByAddingTimeInterval:300];
	
	[self.startDate setDate:minDate];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.select.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.createButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.recurringEventButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.recurringEventButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
	
	
}

-(void)nextScreen{
	
	if (self.practiceOrGame.selectedSegmentIndex == 0) {
		//Game
		NewGame2 *nextController = [[NewGame2 alloc] init];
		nextController.teamId = self.teamId;
		nextController.start = self.startDate.date;
		[self.navigationController pushViewController:nextController animated:YES];
	}else if (self.practiceOrGame.selectedSegmentIndex == 1) {
		//Practice
		NewPractice2 *nextController = [[NewPractice2 alloc] init];
		nextController.teamId = self.teamId;
		nextController.start = self.startDate.date;
		[self.navigationController pushViewController:nextController animated:YES];
	}else {
		NewEvent2 *nextController = [[NewEvent2 alloc] init];
		nextController.teamId = self.teamId;
		nextController.start = self.startDate.date;
		[self.navigationController pushViewController:nextController animated:YES];
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


-(void)recurringEvent{
	
	RecurringEventSelection *tmp = [[RecurringEventSelection alloc] init];
	tmp.teamId = self.teamId;
	if (self.practiceOrGame.selectedSegmentIndex == 0) {
		tmp.eventType = @"game";

	}else if (self.practiceOrGame.selectedSegmentIndex == 1) {
		tmp.eventType = @"practice";

	}else {
		tmp.eventType = @"generic";
	}
	
	
	[self.navigationController pushViewController:tmp animated:YES];
}


-(void)segmentSelect:(id)sender{
	
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection = [segmentedControl selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			
			self.singleLabel.text = @"Single Game Date/Time";
			[self.recurringEventButton setTitle:@"Add Multiple Games" forState:UIControlStateNormal];
			
			break;
		case 1:
	
			self.singleLabel.text = @"Single Practice Date/Time";
			[self.recurringEventButton setTitle:@"Add Multiple Practices" forState:UIControlStateNormal];

			break;
			
		case 2:
			
			self.singleLabel.text = @"Single Event Date/Time";
			[self.recurringEventButton setTitle:@"Add Multiple Events" forState:UIControlStateNormal];


			break;
		default:
			break;
	}
	
	
}


-(void)viewDidUnload{
	//teamId = nil;
	startDate = nil;
	practiceOrGame = nil;
	createButton = nil;
	singleLabel = nil;
	recurringEventButton = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	[teamId release];
	[startDate release];
	[practiceOrGame release];
	[createButton release];
	[recurringEventButton release];
	[singleLabel release];
	[super dealloc];
}


@end
