//
//  NewEvent.m
//  iCoach
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewEvent.h"
#import "NewEvent2.h"

@implementation NewEvent
@synthesize teamId, startDate;

-(void)viewDidLoad{
	
	self.title = @"New Game:";
	NSDate *minDate = [NSDate date];
	
	self.startDate.minimumDate = minDate;
	minDate = [minDate dateByAddingTimeInterval:300];
	[self.startDate setDate:minDate];
	
}

-(void)viewDidUnload{
	teamId = nil;
	startDate = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	[teamId release];
	[startDate release];
	[super dealloc];
}

-(void)nextScreen{
	
	NewEvent2 *nextController = [[NewEvent2 alloc] init];
	nextController.teamId = self.teamId;
	nextController.start = self.startDate.date;
	[self.navigationController pushViewController:nextController animated:YES];
	
}

@end
