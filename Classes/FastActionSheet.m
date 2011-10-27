//
//  FastActionSheet.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastActionSheet.h"
#import "rTeamAppDelegate.h"
#import "FastUpdateStatus.h"
#import "FastRequestStatus.h"
#import "FastChangeEventStatus.h"

@implementation FastActionSheet

- (id) init {
    self = [super init];
	if (self){
		
		self =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Home", @"Update My Status", @"Request Member Status", @"Update Event Status", @"Send Message", @"Happening Now", nil];

	
	}
	return self;
}


+(void)doAction:(UIViewController *)sender :(int)buttonIndex{
	
	if (buttonIndex == 0) {
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
		mainDelegate.returnHome = YES;
		[[sender parentViewController] dismissModalViewControllerAnimated:NO];
		[sender.navigationController popToRootViewControllerAnimated:NO];
		
		
	}else if (buttonIndex == 1) {
		FastUpdateStatus *tmp = [[FastUpdateStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 2) {
			
		FastRequestStatus *tmp = [[FastRequestStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 3) {
		FastChangeEventStatus *tmp = [[FastChangeEventStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 4){
			//FastSendMessage *tmp = [[FastSendMessage alloc] init];
			//[sender.navigationController pushViewController:tmp animated:NO];
		
	}

	

	
	
}

@end
