//
//  NewPractice.m
//  iCoach
//
//  Created by Nick Wroblewski on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewPractice.h"
#import "NewPractice2.h"

@implementation NewPractice
@synthesize teamId, startDate;

-(void)viewDidLoad{
	
	self.title = @"New Practice:";
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
	
	NewPractice2 *nextController = [[NewPractice2 alloc] init];
	nextController.teamId = self.teamId;
	nextController.start = self.startDate.date;
	[self.navigationController pushViewController:nextController animated:YES];
	
}

@end

