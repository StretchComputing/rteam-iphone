//
//  SendPoll.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SendPoll.h"
#import "SendPollOptions.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "MessageTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "MessagesTabs.h"
#import "CurrentTeamTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@implementation SendPoll
@synthesize doneButton, activity, pollQuestion, pollType, errorMessage, pollSubject, teamId, createSuccess, eventId, eventType, origLoc, recipients,
toTeam, userRole, displayResults, includeFans, errorString, pollActionSheet;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"Send Poll";
	self.pollQuestion.text = @"Enter your poll question here...";
	self.pollQuestion.delegate = self;
	self.pollType.selectedSegmentIndex = 0;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.doneButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    self.pollQuestion.layer.masksToBounds = YES;
    self.pollQuestion.layer.cornerRadius = 5.0;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[self becomeFirstResponder];

        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.pollQuestion.text isEqualToString:@"Enter your poll question here..."]){
		self.pollQuestion.text = @"";
	}
}

-(void)sendPoll{
	
	self.errorMessage.text = @"";
	if ([self.pollQuestion.text isEqualToString:@"Enter your poll question here..."] || 
		[self.pollQuestion.text isEqualToString:@""]){
	    self.errorMessage.text = @"*You must enter a poll question";
		self.errorMessage.textAlignment = UITextAlignmentCenter;
	}else{
		
	if (self.pollType.selectedSegmentIndex == 0){
		//YesNo poll, verify with popup, then hit server
		self.pollActionSheet =  [[UIActionSheet alloc] initWithTitle:@"Send a Yes/No poll with this question?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
		self.pollActionSheet.delegate = self;
		[self.pollActionSheet showInView:self.view];
	
		
	}else if (self.pollType.selectedSegmentIndex == 1){
		//Options poll, send to SendPollOptions
		
		SendPollOptions *nextController = [[SendPollOptions alloc] init];
		nextController.questionText = self.pollQuestion.text;
		nextController.teamId = self.teamId;
		nextController.pollSubject = self.pollSubject.text;
		nextController.eventId = self.eventId;
		nextController.eventType = self.eventType;
		nextController.origLoc = self.origLoc;
		nextController.recipients = self.recipients;
		nextController.toTeam = self.toTeam;
		//nextController.includeFans = self.includeFans;
		
		if (self.displayResults.selectedSegmentIndex == 0) {
			nextController.displayResults = @"true";
		}else {
			nextController.displayResults = @"false";
		}

		[self.navigationController pushViewController:nextController animated:YES];
	}else{
	   //error
		self.errorMessage.textAlignment = UITextAlignmentCenter;
		self.errorMessage.text = @"*Please select a Poll Type";
	}
	}
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	

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
	
	NSArray *choices = [NSArray arrayWithObjects:@"Yes", @"No", nil];
	
	
	if (self.eventId == nil){
		self.eventId = @"";
	}
	
	if (self.eventType == nil) {
		self.eventType = @"";
	}
	
	NSString *dispResults = @"";
	if (self.displayResults.selectedSegmentIndex == 0) {
		dispResults = @"true";
	}else {
		dispResults = @"false";
	}
	
	NSArray *recip = [NSArray array];
	
	if (!self.toTeam) {
		recip = self.recipients;
	}

	
	NSDictionary *response = [NSDictionary dictionary];
	if (![token isEqualToString:@""]){	
	    response = [ServerAPI createMessageThread:token :self.teamId :self.pollSubject.text :self.pollQuestion.text :@"poll" :self.eventId 
												 :self.eventType :@"false" :choices :recip :dispResults :self.includeFans :@""];
				
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.createSuccess = true;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			self.createSuccess = false;
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorString = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.errorString = @"*Error connecting to server";
					break;
				case 207:
					//error connecting to server
					self.errorString = @"*Fans cannot send polls.";
					break;
				case 208:
					self.errorString = @"NA";
					break;

				default:
					//should never get here
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
	
	//When background thread is done, return to main thread
	[activity stopAnimating];
	
	if (self.createSuccess){
		
		//team, sent, inbox, game or pracitce
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 3;
		
		if ([self.origLoc isEqualToString:@"MessagesTabs"]) {
			
			if ([[tempCont objectAtIndex:tempNum] class] == [MessagesTabs class]) {
				MessagesTabs *cont = [tempCont objectAtIndex:tempNum];
				cont.selectedIndex = 1;
				
				
				
				[self.navigationController popToViewController:cont animated:YES];
			}else if ([[tempCont objectAtIndex:tempNum - 1] class] == [MessagesTabs class]) {
				MessagesTabs *cont = [tempCont objectAtIndex:tempNum-1];
				cont.selectedIndex = 1;
			
				[self.navigationController popToViewController:cont animated:YES];
			}
		}
		
		if ([self.origLoc isEqualToString:@"CurrentTeamTabs"]) {
			
			if ([[tempCont objectAtIndex:tempNum] class] == [CurrentTeamTabs class]) {
				CurrentTeamTabs *cont = [tempCont objectAtIndex:tempNum];
				cont.teamId = self.teamId;
				cont.selectedIndex = 4;
				cont.userRole = self.userRole;
	
				
				[self.navigationController popToViewController:cont animated:YES];
			}else if ([[tempCont objectAtIndex:tempNum - 1] class] == [CurrentTeamTabs class]) {
				CurrentTeamTabs *cont = [tempCont objectAtIndex:tempNum-1];
				cont.selectedIndex = 4;
				cont.teamId = self.teamId;
				cont.userRole = self.userRole;
				
				
				
				[self.navigationController popToViewController:cont animated:YES];
			}
		}
		
		if ([self.origLoc isEqualToString:@"GameTabs"]) {
			
			if ([[tempCont objectAtIndex:tempNum] class] == [GameTabs class]) {
				GameTabs *cont = [tempCont objectAtIndex:tempNum];
				cont.teamId = self.teamId;
				cont.selectedIndex = 3;
				cont.userRole = self.userRole;
				
				
				[self.navigationController popToViewController:cont animated:YES];
			}else if ([[tempCont objectAtIndex:tempNum - 1] class] == [GameTabs class]) {
				GameTabs *cont = [tempCont objectAtIndex:tempNum-1];
				cont.selectedIndex = 3;
				cont.teamId = self.teamId;
				
			
				[self.navigationController popToViewController:cont animated:YES];
			}
		}
		
		if ([self.origLoc isEqualToString:@"PracticeTabs"]) {
			
			if ([[tempCont objectAtIndex:tempNum] class] == [PracticeTabs class]) {
				PracticeTabs *cont = [tempCont objectAtIndex:tempNum];
				cont.teamId = self.teamId;
				cont.selectedIndex = 1;
				cont.userRole = self.userRole;
				
				
				[self.navigationController popToViewController:cont animated:YES];
			}else if ([[tempCont objectAtIndex:tempNum - 1] class] == [PracticeTabs class]) {
				PracticeTabs *cont = [tempCont objectAtIndex:tempNum-1];
				cont.selectedIndex = 1;
				cont.teamId = self.teamId;
				cont.userRole = self.userRole;
				
				[self.navigationController popToViewController:cont animated:YES];
			}
		}
		
		
		
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send polls.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            [alert release];
		}else {
			self.errorMessage.text = self.errorString;
			self.errorMessage.textColor = [UIColor redColor];
		}
		
		[doneButton setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		[self.pollQuestion setEditable:YES];
		[self.pollSubject setEnabled:YES];
	}
}


-(void)endText{
	[self becomeFirstResponder];

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
	
	
	if (actionSheet == self.pollActionSheet){
		
		if (buttonIndex == 0) {
			
			[activity startAnimating];
			
			//Disable the UI buttons and textfields while registering
			
			[doneButton setEnabled:NO];
			[self.navigationItem.leftBarButtonItem setEnabled:NO];
			[self.pollSubject setEnabled:NO];
			[self.pollQuestion setEditable:NO];
			
			//Create the team in a background thread
			
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
			
		}
		
	}else {
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
}



- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)viewDidUnload{
	
	doneButton = nil;
	activity = nil;
	pollQuestion = nil;
	pollType = nil;
	errorMessage = nil;
	pollSubject = nil;
	//origLoc = nil;
	//eventId = nil;
	//eventType = nil;
	//recipients = nil;
	//userRole = nil;
	displayResults = nil;
	//includeFans = nil;
	//errorString = nil;
	//teamId = nil;
	pollActionSheet = nil;
	[super viewDidUnload];

}

-(void)dealloc{
	
	[doneButton release];
	[activity release];
	[pollQuestion release];
	[pollType release];
	[errorMessage release];
	[pollSubject release];
	[eventId release];
	[eventType release];
	[origLoc release];
	[recipients release];
	[userRole release];
	[displayResults release];
	[includeFans release];
	[errorString release];
	[teamId release];
	[pollActionSheet release];
	[super dealloc];
}

@end
