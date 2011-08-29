//
//  ViewMessagesSent.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewMessageSent.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "MessagesTabs.h"
#import "CurrentTeamTabs.h"
#import "PracticeTabs.h"
#import "GameTabs.h"
#import "ViewDetailMessageReplies.h"
#import "MessageThreadOutbox.h"
#import "FastActionSheet.h"

@implementation ViewMessageSent
@synthesize subject, body, createdDate, displayDate, displayBody, displaySubject, teamId, eventId, eventType, threadId, recipients,
individualReplies, viewMoreDetailButton, confirmString, confirmStringLabel, messageNumber, messageArray, currentMessageNumber, upDown,
teamName, teamNameLabel, origTeamId, messageInfo, loadingActivity, loadingLabel, deleteButton, errorLabel, errorString;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}


-(void)viewWillAppear:(BOOL)animated{
	
	if (self.currentMessageNumber == ([self.messageArray count] - 1)) {
		[self.upDown setEnabled:NO forSegmentAtIndex:1];
	}
	
	if (self.currentMessageNumber == 0) {
		[self.upDown setEnabled:NO forSegmentAtIndex:0];
	}
	
}

-(void)viewDidLoad{
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.viewMoreDetailButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	[self initMessageInfo];
	
	self.upDown.selectedSegmentIndex = -1;
	[self.upDown addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *tmp = [[[UIBarButtonItem alloc] initWithCustomView: self.upDown] autorelease];
	[self.navigationItem setRightBarButtonItem:tmp];
	
	int msg = self.currentMessageNumber + 1;
	int total = [self.messageArray count];
	
	self.messageNumber.text = [NSString stringWithFormat:@"Msg %d of %d", msg, total];
	
}


-(void)segmentSelect:(id)sender{
	
	int selection = [self.upDown selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			self.upDown.selectedSegmentIndex = -1;
			
			if (self.currentMessageNumber != 0) {
				//Go up one message
				[self.upDown setEnabled:YES forSegmentAtIndex:1];

				self.currentMessageNumber--;
				
				MessageThreadOutbox *message = [self.messageArray objectAtIndex:self.currentMessageNumber];
				
				self.subject = message.subject;
				self.body = message.body;
				self.threadId = message.threadId;
				self.createdDate = message.createdDate;
				//self.teamId = message.teamId;
				self.teamName = message.teamName;
				
				NSString *recipients1 = message.numRecipients;
				NSString *replies = message.numReplies;
				
				
				if (recipients1 == nil) {
					recipients1 = @"0";
				}
				if (replies == nil) {
					replies = @"0";
				}
				
				if (self.currentMessageNumber == 0) {
					[self.upDown setEnabled:NO forSegmentAtIndex:0];
				}
				
				NSString *replyString = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients1] stringByAppendingString:@" people have confirmed."];
				
				self.confirmString = replyString;
				
				[self initMessageInfo];
				
			}
			
			break;
		case 1:
			self.upDown.selectedSegmentIndex = -1;
			
			if (self.currentMessageNumber != ([self.messageArray count] - 1)) {
				//Go down one messages
				[self.upDown setEnabled:YES forSegmentAtIndex:0];

				self.currentMessageNumber++;
				
				MessageThreadOutbox *message = [self.messageArray objectAtIndex:self.currentMessageNumber];
				
				self.subject = message.subject;
				self.body = message.body;
				self.threadId = message.threadId;
				self.createdDate = message.createdDate;
				self.teamId = message.teamId;
				self.teamName = message.teamName;
				
				NSString *recipients1 = message.numRecipients;
				NSString *replies = message.numReplies;
				
				
				if (recipients1 == nil) {
					recipients1 = @"0";
				}
				if (replies == nil) {
					replies = @"0";
				}
				
				NSString *replyString = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients1] stringByAppendingString:@" people have confirmed."];
				
				self.confirmString = replyString;
				
				if (self.currentMessageNumber == ([self.messageArray count] - 1)) {
					[self.upDown setEnabled:NO forSegmentAtIndex:1];
				}
				
				[self initMessageInfo];
			}
			break;
		default:
			break;
	}
	
	int msg = self.currentMessageNumber + 1;
	int total = [self.messageArray count];
	
	self.messageNumber.text = [NSString stringWithFormat:@"Msg %d of %d", msg, total];
	
}




-(void)initMessageInfo{
	
	self.loadingLabel.hidden = NO;
	[self.loadingActivity startAnimating];
	self.displayBody.hidden = YES;
	self.viewMoreDetailButton.hidden = YES;
	self.deleteButton.enabled = NO;
	self.confirmStringLabel.hidden = YES;
	
	self.recipients.hidden = YES;
	self.displaySubject.hidden = YES;
	self.displayDate.hidden = YES;
	self.teamNameLabel.hidden = YES;
	
	self.errorLabel.text = @"";
	
	[self performSelectorInBackground:@selector(getMessageInfo) withObject:nil];	
	
}

-(void)getMessageInfo{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	NSDictionary *response = [NSDictionary dictionary];
	if (![token isEqualToString:@""]){
		
		if (self.teamId == nil) {
			self.teamId = self.origTeamId;
		}
		response = [ServerAPI getMessageThreadInfo:token :self.teamId :self.threadId];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.messageInfo = [NSDictionary dictionary];
			
			self.messageInfo = [response valueForKey:@"messageThreadInfo"];
			
			self.errorString = @"";
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorString = @"*Error retrieving message info.";
					break;
				case 1:
					//error connecting to server
					self.errorString = @"*Error retrieving message info.";
					break;
				default:
					//log status code
					self.errorString = @"*Error retrieving message info.";
					break;
			}
		}
		
	}
	
	

	[self performSelectorOnMainThread:@selector(doneInfo) withObject:nil waitUntilDone:NO];
	[pool drain];
	
}

-(void)doneInfo{
	
	[self.loadingActivity stopAnimating];
	self.loadingLabel.hidden = YES;
	
	if ([self.errorString isEqualToString:@""]) {
	
	self.displayBody.hidden = NO;
	self.viewMoreDetailButton.hidden = NO;
	self.deleteButton.enabled = YES;
	self.confirmStringLabel.hidden = NO;
	
	self.recipients.hidden = NO;
	self.displaySubject.hidden = NO;
	self.displayDate.hidden = NO;
	self.teamNameLabel.hidden = NO;
	
	NSArray *recip = [NSArray array];

	recip = [self.messageInfo valueForKey:@"members"];
	
	NSString *type = @"";
	
	if ([self.messageInfo valueForKey:@"type"] != nil) {
		type = [self.messageInfo valueForKey:@"type"];
	}
	
	
	if ([type isEqualToString:@"confirm"]) {
		self.confirmStringLabel.text = self.confirmString;
		[self.viewMoreDetailButton setHidden:NO];
		[self.confirmStringLabel setHidden:NO];
	}else {
		[self.viewMoreDetailButton setHidden:YES];
		[self.confirmStringLabel setHidden:YES];
	}
	
	self.individualReplies = recip;
	self.title = @"Sent Message";
	self.displayDate.text = self.createdDate;
	self.displaySubject.text = self.subject;
	self.displayBody.text = self.body;
	self.teamNameLabel.text = self.teamName;
	
	NSString *recipNames = @"";
	
	for (int i = 0; i < [recip count]; i++) {
		NSDictionary *tmp = [recip objectAtIndex:i];
		
		NSString *name = [tmp valueForKey:@"memberName"];
		
		if (![recipNames isEqualToString:@""]) {
			recipNames = [[recipNames stringByAppendingFormat:@", "] stringByAppendingString:name];
		}else {
			recipNames = name;
		}
		
	}
	
	recipients.text = recipNames;
		
	}else {
		self.errorLabel.text = self.errorString;
		self.errorLabel.hidden = NO;
	}

}

-(void)deleteMessage{
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :@"" :@"" :@"" :@"archived"];
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			NSArray *temp = [self.navigationController viewControllers];
			int num = [temp count];
			num -= 2;
			
			
			//Could be "MessageTabs", "GameTabs", "PracticeTabs", or "CurrentTeamTabs"
			
			if ([[temp objectAtIndex:num] class] == [MessagesTabs class]) {
				MessagesTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 2;
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
			int statusCode = [status intValue];
			
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


-(void)ViewDetailMessageReplies{
	
	ViewDetailMessageReplies *tmp = [[ViewDetailMessageReplies alloc] init];
	tmp.replyArray = self.individualReplies;
	tmp.teamId = self.teamId;
	tmp.getInfo = false;
	tmp.isSender = true;
	
	[self.navigationController pushViewController:tmp animated:YES];
	 
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
	
	//subject = nil;
	//body = nil;
	//createdDate = nil;
	displayDate = nil;
	displayBody = nil;
	displaySubject = nil;
	//teamId = nil;
	//eventId = nil;
	//eventType = nil;
	//threadId = nil;
	viewMoreDetailButton = nil;
	//confirmString = nil;
	confirmStringLabel = nil;
	messageNumber = nil;
	//messageArray = nil;
	upDown = nil;
	//teamName = nil;
	teamNameLabel = nil;
	//origTeamId = nil;
	//individualReplies = nil;
	//messageInfo = nil;
	loadingActivity = nil;
	loadingLabel = nil;
	deleteButton = nil;
	errorLabel = nil;
	//errorString = nil;

	
	[super viewDidUnload];
}
	
-(void)dealloc{
	
	[subject release];
	[body release];
	[createdDate release];
	[displayDate release];
	[displayBody release];
	[displaySubject release];
	[teamId release];
	[eventId release];
	[eventType release];
	[threadId release];
	[viewMoreDetailButton release];
	[confirmString release];
	[confirmStringLabel release];
	[messageNumber release];
	[messageArray release];
	[upDown release];
	[teamName release];
	[teamNameLabel release];
	[origTeamId release];
	[individualReplies release];
	[messageInfo release];
	[loadingActivity release];
	[loadingLabel release];
	[deleteButton release];
	[errorLabel release];
	[errorString release];
	[super dealloc];

	
}

@end
