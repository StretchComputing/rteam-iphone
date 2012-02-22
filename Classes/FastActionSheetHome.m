//
//  FastActionSheetHome.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastActionSheetHome.h"
#import "rTeamAppDelegate.h"
#import "FastChangeEventStatus.h"
#import "ActivityPost.h"
#import "GANTracker.h"

@implementation FastActionSheetHome

- (id) init {
    self = [super init];
	if (self){
		
		self =  (FastActionSheetHome *)[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Update Event Status", @"Send Message", nil];
		
		
	}
	return self;
}


+(void)doAction:(UIViewController *)sender :(int)buttonIndex{
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"FAST Action Selected"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	if (buttonIndex == 0) {
        FastChangeEventStatus *tmp = [[FastChangeEventStatus alloc] init];
		[sender.navigationController pushViewController:tmp animated:NO];
		//FastUpdateStatus *tmp = [[FastUpdateStatus alloc] init];
		//[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 1) {
        
        UINavigationController *tmp = [[UINavigationController alloc] init];
        ActivityPost *act = [[ActivityPost alloc] init];
        [tmp pushViewController:act animated:NO];
        [sender.navigationController presentModalViewController:tmp animated:YES];
		//FastRequestStatus *tmp = [[FastRequestStatus alloc] init];
		//[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 2) {
		//FastChangeEventStatus *tmp = [[FastChangeEventStatus alloc] init];
		//[sender.navigationController pushViewController:tmp animated:NO];
	}else if (buttonIndex == 3){
		//FastSendMessage *tmp = [[FastSendMessage alloc] init];
		//[sender.navigationController pushViewController:tmp animated:NO];
		
	}
	
	
	
	
	
}

@end
