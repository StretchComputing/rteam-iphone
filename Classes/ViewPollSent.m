//
//  ViewPollSent.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewPollSent.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "ViewDetailPollReplies.h"
#import "FinalizePoll.h"
#import "MessagesTabs.h"
#import "CurrentTeamTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "MessageThreadOutbox.h"
#import "FastActionSheet.h"

@implementation ViewPollSent
@synthesize messageThreadId, teamId, subject, body, numReply, option1, option2, option3, option4, option5, replyFraction, individualReplies,
finalizedMessage, status, finalizeButton, deletePollButton, viewMoreDetailButton, scrollView, followUp, downArrow, teamName, teamNameLabel,
upDown, currentPollNumber, pollArray, pollNumber, origTeamId, response, loadingActivity, loadingLabel, resultsLabel, errorLabel, errorString;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}


-(void)viewWillAppear:(BOOL)animated{
	
	if (self.currentPollNumber == ([self.pollArray count] - 1)) {
		[self.upDown setEnabled:NO forSegmentAtIndex:1];
	}
	
	if (self.currentPollNumber == 0) {
		[self.upDown setEnabled:NO forSegmentAtIndex:0];
	}
	
}


-(void)viewDidLoad{
	
	[self.scrollView setContentSize:CGSizeMake(320, 475)];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.finalizeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.viewMoreDetailButton setBackgroundImage:stretch forState:UIControlStateNormal];

	self.body.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];

	[self initPollInfo];
	
	self.title = @"Poll Sent";
	

	self.upDown.selectedSegmentIndex = -1;
	[self.upDown addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *tmp = [[[UIBarButtonItem alloc] initWithCustomView: self.upDown] autorelease];
	[self.navigationItem setRightBarButtonItem:tmp];
	
	int msg = self.currentPollNumber + 1;
	int total = [self.pollArray count];
	
	self.pollNumber.text = [NSString stringWithFormat:@"Poll %d of %d", msg, total];
	
}


-(void)segmentSelect:(id)sender{
	
	int selection = [self.upDown selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			self.upDown.selectedSegmentIndex = -1;
			
			if (self.currentPollNumber != 0) {
				//Go up one message
				[self.upDown setEnabled:YES forSegmentAtIndex:1];

				self.currentPollNumber--;
				
				MessageThreadOutbox *thread = [self.pollArray objectAtIndex:self.currentPollNumber];
				
				self.teamId = thread.teamId;
				self.messageThreadId = thread.threadId;
				self.teamName = thread.teamName;
				NSString *recipients = thread.numRecipients;
				NSString *replies = thread.numReplies;
				
				if (recipients == nil) {
					recipients = @"0";
				}
				if (replies == nil) {
					replies = @"0";
				}
				
				if ([thread.status isEqualToString:@"finalized"]) {
					self.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people replied."];
				}else {
					self.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
				}
				
				if (self.currentPollNumber == 0) {
					[self.upDown setEnabled:NO forSegmentAtIndex:0];
				}
				
				[self initPollInfo];
				
				
			}
			
			break;
		case 1:
			self.upDown.selectedSegmentIndex = -1;
			
			if (self.currentPollNumber != ([self.pollArray count] - 1)) {
				//Go down one messages
				[self.upDown setEnabled:YES forSegmentAtIndex:0];

				self.currentPollNumber++;
				
				MessageThreadOutbox *thread = [self.pollArray objectAtIndex:self.currentPollNumber];
								
				self.teamId = thread.teamId;
				self.messageThreadId = thread.threadId;
				self.teamName = thread.teamName;
				NSString *recipients = thread.numRecipients;
				NSString *replies = thread.numReplies;
				
				if (recipients == nil) {
					recipients = @"0";
				}
				if (replies == nil) {
					replies = @"0";
				}
				
				if ([thread.status isEqualToString:@"finalized"]) {
					self.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people replied."];
				}else {
					self.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
				}
				
				if (self.currentPollNumber == ([self.pollArray count] - 1)) {
					[self.upDown setEnabled:NO forSegmentAtIndex:1];
				}
				
				[self initPollInfo];
			}
			break;
		default:
			break;
	}
	
	int msg = self.currentPollNumber + 1;
	int total = [self.pollArray count];
	
	self.pollNumber.text = [NSString stringWithFormat:@"Poll %d of %d", msg, total];
	
}


-(void)initPollInfo{
	
	[self.loadingActivity startAnimating];
	self.loadingLabel.hidden = NO;
	
	
	self.subject.hidden = YES;
	self.finalizedMessage.hidden = YES;
	self.teamNameLabel.hidden = YES;
	self.body.hidden = YES;
	self.numReply.hidden = YES;
	self.option1.hidden = YES;
	self.option2.hidden = YES;
	self.option3.hidden = YES;
	self.option4.hidden = YES;
	self.option5.hidden = YES;
	self.finalizeButton.hidden = YES;
	self.viewMoreDetailButton.hidden = YES;
	self.deletePollButton.enabled = NO;
	self.downArrow.hidden = YES;
	self.resultsLabel.hidden = YES;
	
	self.errorLabel.text = @"";
	[self performSelectorInBackground:@selector(getInfo) withObject:nil];
}


-(void)getInfo{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (self.teamId == nil) {
		self.teamId = self.origTeamId;
	}
	NSDictionary *response1 = [ServerAPI getMessageThreadInfo:mainDelegate.token :self.teamId :self.messageThreadId];
	
	NSString *status1 = [response1 valueForKey:@"status"];
		
	NSLog(@"Get Status: %@", status1);
	
	if ([status1 isEqualToString:@"100"]){
		
		self.response = [NSDictionary dictionary];
		self.response = [response1 valueForKey:@"messageThreadInfo"];
		self.errorString = @"";
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				self.errorString = @"*Error retrieving poll info.";
				break;
			case 1:
				//error connecting to server
				self.errorString = @"*Error retrieving poll info.";
				break;
			default:
				//log status code
				self.errorString = @"*Error retrieving poll info.";
				break;
		}
	}
	
	
	[self performSelectorOnMainThread:@selector(doneInfo) withObject:nil waitUntilDone:NO];
	[pool drain];
	
}

-(void)doneInfo{
	
	[self.loadingActivity stopAnimating];
	self.loadingLabel.hidden = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
	self.subject.hidden = NO;
	self.teamNameLabel.hidden = NO;
	self.body.hidden = NO;
	self.numReply.hidden = NO;
	self.option1.hidden = NO;
	self.option2.hidden = NO;
	self.option3.hidden =  NO;
	self.option4.hidden = NO;
	self.option5.hidden = NO;
	self.viewMoreDetailButton.hidden = NO;
	self.deletePollButton.enabled = YES;
	self.resultsLabel.hidden = NO;
	self.finalizeButton.hidden = NO;
	self.teamNameLabel.text = self.teamName;

	
	if ([self.response valueForKey:@"followUpMessage"] != nil) {
		
		NSString *follow = [self.response valueForKey:@"followUpMessage"];
		
		UILabel *tmp = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 300, 20)];
		tmp.text = @"Follow Up Message:";
		tmp.font = [UIFont fontWithName:@"Helvetica" size:16];
		tmp.textColor = [UIColor blackColor];
		//[self.scrollView addSubview:tmp];
		
		self.followUp = [[UITextView alloc] initWithFrame:CGRectMake(10, 343, 300, 100)];
		self.followUp.text = [@"Follow up message: " stringByAppendingString:follow];
		self.followUp.font = [UIFont fontWithName:@"Helvetica" size:15];
		self.followUp.backgroundColor = [UIColor colorWithRed:.94 green:.94 blue:.94 alpha:1.0];
		self.followUp.editable = NO;
		
		[self.scrollView addSubview:self.followUp];
	}
	self.subject.text = [self.response objectForKey:@"subject"];
	self.body.text = [self.response objectForKey:@"body"];
	
	if (self.body.contentSize.height > 54) {
		[self.downArrow setHidden:NO];
	}else {
		[self.downArrow setHidden:YES];
	}
	
	self.numReply.text = self.replyFraction;
	
	[self.finalizedMessage setHidden:YES];
	self.status = [self.response objectForKey:@"status"];
	if ([self.status isEqualToString:@"finalized"]) {
		[self.finalizedMessage setHidden:NO];
		[self.finalizeButton setHidden:YES];
	}
	
	NSArray *pollChoices = [self.response objectForKey:@"pollChoices"];
		
		if ([pollChoices count] <= 4) {
			
			self.viewMoreDetailButton.frame = CGRectMake(166, 320, 144, 32);
			self.finalizeButton.frame = CGRectMake(9, 320, 144, 32);
			
		}else {
			self.viewMoreDetailButton.frame = CGRectMake(166, 346, 144, 32);
			self.finalizeButton.frame = CGRectMake(9, 346, 144, 32);
		}

	NSMutableArray *pollChoicesCount = [NSMutableArray array];
	for (int i = 0; i < [pollChoices count]; i++) {
		NSNumber *num = [[NSNumber alloc] initWithInt:0];
		[pollChoicesCount addObject:num];
		[num release];
	}
	
	self.individualReplies = [self.response objectForKey:@"members"];
	
	
	for (int i = 0; i < [self.individualReplies count]; i++) {
		
		NSDictionary *tmpDictionary = [self.individualReplies objectAtIndex:i];
		
		if ([tmpDictionary objectForKey:@"reply"] != nil) {
			
			NSString *reply = [tmpDictionary objectForKey:@"reply"];
			
			for (int j = 0; j < [pollChoices count]; j++) {
				
				NSString *thisChoice = [pollChoices objectAtIndex:j];
				
				if ([thisChoice isEqualToString:reply]) {
					
					NSNumber *tmpNum = [pollChoicesCount objectAtIndex:j];
					int tmpInt = [tmpNum intValue];
					
					tmpInt++;
					
					NSNumber *newNum = [[NSNumber alloc] initWithInt:tmpInt];
					[pollChoicesCount replaceObjectAtIndex:j withObject:newNum];
					[newNum release];
					
					
				}
			}
			
		}
		
	}
	
		self.option1.lineBreakMode = UILineBreakModeMiddleTruncation;
		self.option2.lineBreakMode = UILineBreakModeMiddleTruncation;
		self.option3.lineBreakMode = UILineBreakModeMiddleTruncation;
		self.option4.lineBreakMode = UILineBreakModeMiddleTruncation;
		self.option5.lineBreakMode = UILineBreakModeMiddleTruncation;

	NSNumber *num1 = [pollChoicesCount objectAtIndex:0];
	self.option1.text = [[[pollChoices objectAtIndex:0] stringByAppendingString:@":  "] stringByAppendingString:[num1 stringValue]];
	
	NSNumber *num2 = [pollChoicesCount objectAtIndex:1];
	self.option2.text = [[[pollChoices objectAtIndex:1] stringByAppendingString:@":  "] stringByAppendingString:[num2 stringValue]];
	
	if ([pollChoices count] > 2) {
		NSNumber *num3 = [pollChoicesCount objectAtIndex:2];
		self.option3.text = [[[pollChoices objectAtIndex:2] stringByAppendingString:@":  "] stringByAppendingString:[num3 stringValue]]; 
	}else {
		[self.option3 setHidden:YES];
	}
	
	
	if ([pollChoices count] > 3) {
		NSNumber *num4 = [pollChoicesCount objectAtIndex:3];
		self.option4.text = [[[pollChoices objectAtIndex:3] stringByAppendingString:@":  "] stringByAppendingString:[num4 stringValue]];
	}else {
		[self.option4 setHidden:YES];
	}
	
	
	if ([pollChoices count] > 4) {
		NSNumber *num5 = [pollChoicesCount objectAtIndex:4];
		self.option5.text = [[[pollChoices objectAtIndex:4] stringByAppendingString:@":  "] stringByAppendingString:[num5
																													 stringValue]];
	}else {
		[self.option5 setHidden:YES];
	}
	
		
	}else {
		self.errorLabel.text = self.errorString;
		self.errorLabel.hidden = NO;
	}

	
	
}

-(void)viewDetailReplies{
	
	ViewDetailPollReplies *tmp = [[ViewDetailPollReplies alloc] init];
	tmp.replyArray = self.individualReplies;
	tmp.teamId = self.teamId;
	tmp.isSender = true;
	
	if ([self.status isEqualToString:@"finalized"]) {
		tmp.finalized = true;
	}
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)finalizePoll{
	
	FinalizePoll *tmp = [[FinalizePoll alloc] init];
	tmp.teamId = self.teamId;
	tmp.messageThreadId = self.messageThreadId;
	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)deletePoll{

	NSString *message = @"Deleting this poll will remove if from the inbox of all recipients, and the results will be ignored.  Are you sure?";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete This Poll?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
    [alert release];
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 1) {
		
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		NSDictionary *response1 = [ServerAPI updateMessageThread:token :self.teamId :self.messageThreadId :@"" :@"" :@"" :@"archived"];
		NSString *status1 = [response1 valueForKey:@"status"];
		
		if ([status1 isEqualToString:@"100"]){
			
			NSArray *temp = [self.navigationController viewControllers];
			int num = [temp count];
			num -= 2;
			
			
			//Could be "MessageTabs", "GameTabs", "PracticeTabs", or "CurrentTeamTabs"
			
			if ([[temp objectAtIndex:num] class] == [MessagesTabs class]) {
				MessagesTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 1;
				[self.navigationController popToViewController:cont animated:YES];
				
			}else if ([[temp objectAtIndex:num] class] == [CurrentTeamTabs class]) {
				CurrentTeamTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 4;
				[self.navigationController popToViewController:cont animated:YES];
				
			}else if ([[temp objectAtIndex:num] class] == [GameTabs class]) {
				GameTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 3;
				[self.navigationController popToViewController:cont animated:YES];
				
			}else if ([[temp objectAtIndex:num] class] == [PracticeTabs class]) {
				PracticeTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 1;
				[self.navigationController popToViewController:cont animated:YES];
			}
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status1 intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error.text = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error.text = @"*Error connecting to server";
					break;
				default:
					//log status code
					//self.error.text = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
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
	
	//messageThreadId = nil;
	//teamId = nil;
	subject = nil;
	body = nil;
	numReply = nil;
	option1 = nil;
	option2 = nil;
	option3 = nil;
	option4 = nil;
	option5 = nil;
	//replyFraction = nil;
	//individualReplies = nil;
	finalizedMessage = nil;
	//status = nil;
	finalizeButton = nil;
	deletePollButton = nil;
	viewMoreDetailButton = nil;
	scrollView = nil;
	followUp = nil;
	downArrow = nil;
	pollNumber = nil;
	//pollArray = nil;
	upDown = nil;
	//teamName = nil;
	//origTeamId = nil;
	teamNameLabel = nil;
	//response = nil;
	loadingActivity = nil;
	loadingLabel = nil;
	resultsLabel = nil;
	errorLabel = nil;
	//errorString = nil;
	[super viewDidUnload];

	
	
}

-(void)dealloc{
	[messageThreadId release];
	[teamId release];
	[subject release];
	[body release];
	[numReply release];
	[option1 release];
	[option2 release];
	[option3 release];
	[option4 release];
	[option5 release];
	[replyFraction release];
	[individualReplies release];
	[finalizedMessage release];
	[status release];
	[finalizeButton release];
	[deletePollButton release];
	[viewMoreDetailButton release];
	[scrollView release];
	[followUp release];
	[downArrow release];
	[pollNumber release];
	[pollArray release];
	[upDown release];
	[teamName release];
	[origTeamId release];
	[teamNameLabel release];
	[response release];
	[loadingActivity release];
	[loadingLabel release];
	[resultsLabel release];
	[errorLabel release];
	[errorString release];
	
	[super dealloc];
	
}
	
@end
