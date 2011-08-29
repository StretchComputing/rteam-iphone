//
//  FinalizePoll.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FinalizePoll.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "MessagesTabs.h"
#import "CurrentTeamTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "FastActionSheet.h"


@implementation FinalizePoll
@synthesize teamId, messageThreadId, followUpMessage, confirmButton, createSuccess, errorMessage, activity, errorString;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{

	self.title = @"Finalize Poll";
	self.followUpMessage.delegate = self;
	self.followUpMessage.text = @"Enter your follow up message here...";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.confirmButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.followUpMessage.text isEqualToString:@"Enter your follow up message here..."]){
		self.followUpMessage.text = @"";
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

-(void)confirm{
		
	self.errorMessage.text = @"";
		[activity startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[confirmButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.followUpMessage setEditable:NO];
		
		//Create the team in a background thread
		
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}



- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 

	
	NSString *followUp = @"";
	NSString *status = @"";
	
	if (self.followUpMessage.text != nil && ![self.followUpMessage.text isEqualToString:@"Enter your follow up message here..."] &&
		![self.followUpMessage.text isEqualToString:@""]) {
		
		followUp = self.followUpMessage.text;
	}else {
		followUp = @"none";
	}

	

	NSDictionary *response = [NSDictionary dictionary];
	if (![token isEqualToString:@""]){	
		
		
		response = [ServerAPI updateMessageThread:token :self.teamId :self.messageThreadId :@"" :@"" :followUp :status];
				
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.createSuccess = true;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			self.createSuccess = false;
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorString = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.errorString = @"*Error connecting to server";
					break;
				default:
					//log status code
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
	}
	
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinish{
	
	if (self.createSuccess) {
		//team, sent, inbox, game or pracitce
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 3;
		
			
		if ([[tempCont objectAtIndex:tempNum] class] == [MessagesTabs class]) {
			MessagesTabs *cont = [tempCont objectAtIndex:tempNum];
			cont.selectedIndex = 1;
				
			[self.navigationController popToViewController:cont animated:YES];
		}
		if ([[tempCont objectAtIndex:tempNum] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *cont = [tempCont objectAtIndex:tempNum];
			cont.selectedIndex = 4;
			
			[self.navigationController popToViewController:cont animated:YES];
		}
		if ([[tempCont objectAtIndex:tempNum] class] == [GameTabs class]) {
			GameTabs *cont = [tempCont objectAtIndex:tempNum];
			cont.selectedIndex = 3;
			
			[self.navigationController popToViewController:cont animated:YES];
		}
		if ([[tempCont objectAtIndex:tempNum] class] == [PracticeTabs class]) {
			PracticeTabs *cont = [tempCont objectAtIndex:tempNum];
			cont.selectedIndex = 1;
			
			[self.navigationController popToViewController:cont animated:YES];
		}
		
	}else {
		
		self.errorMessage.text = self.errorString;
		[activity stopAnimating];
		[confirmButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.followUpMessage setEditable:YES];
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

-(void)viewDidUnload{
	//teamId = nil;
	//messageThreadId = nil;
	followUpMessage = nil;
	confirmButton = nil;
	activity = nil;
	errorMessage = nil;
	//errorString = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[teamId release];
	[messageThreadId release];
	[followUpMessage release];
	[confirmButton release];
	[activity release];
	[errorMessage release];
	[errorString release];
    [super dealloc];
}


@end
