//
//  FastActionSheetHome.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastActionSheetHome.h"
#import "rTeamAppDelegate.h"
#import "FastUpdateStatus.h"
#import "FastRequestStatus.h"
#import "FastChangeEventStatus.h"

@implementation FastActionSheetHome

- (id) init {
    self = [super init];
	if (self){
		
		self =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Update My Status", @"Request Member Status", @"Update Event Status", @"Send Message", @"Happening Now", nil];
		
		
	}
	return self;
}


+(void)doAction:(UIViewController *)sender :(int)buttonIndex{
	
	if (buttonIndex == 0) {
		FastUpdateStatus *tmp = [[FastUpdateStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 1) {
		
		FastRequestStatus *tmp = [[FastRequestStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 2) {
		FastChangeEventStatus *tmp = [[FastChangeEventStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 3){
		//FastSendMessage *tmp = [[FastSendMessage alloc] init];
		//[sender.navigationController pushViewController:tmp animated:NO];
		
	}
	
	
	
	
	
}

@end
