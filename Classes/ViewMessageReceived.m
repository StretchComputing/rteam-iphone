//
//  ViewMessageReceived.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewMessageReceived.h"
#import "MyLineView.h"
#import "SendMessage.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "MessagesTabs.h"
#import "CurrentTeamTabs.h"
#import "PracticeTabs.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "ViewDetailMessageReplies.h"
#import "MessageThreadInbox.h"
#import "FastActionSheet.h"
#import "MessageReply.h"

@implementation ViewMessageReceived
@synthesize subject, body, receivedDate, displayDate, displayBody, displaySubject, teamId, eventId, eventType, wasViewed, threadId,
senderName, senderId, displaySender, userRole, replyButton, myToolbar, replySuccess, replyMessage, viewMoreDetailButton,
confirmationsLabel, confirmStatus, individualReplies, messageNumber, messageArray, upDown,
currentMessageNumber, teamLabel, teamName, origTeamId, isAlert;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
    self.isAlert = false;
    [self performSelectorInBackground:@selector(getThreadInfo) withObject:nil];
    
	if (self.replySuccess) {
		self.replySuccess = false;
		self.replyMessage.text = @"*Reply sent successfully!";
		[self.replyMessage setHidden:NO];
	}else {
		[self.replyMessage setHidden:YES];
	}
	
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
	[self.viewMoreDetailButton setHidden:YES];
	[self.confirmationsLabel setHidden:YES];
	
	self.upDown.selectedSegmentIndex = -1;
	[self.upDown addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];

	UIBarButtonItem *tmp = [[[UIBarButtonItem alloc] initWithCustomView: self.upDown] autorelease];
	[self.navigationItem setRightBarButtonItem:tmp];
	
	int msg = self.currentMessageNumber + 1;
	int total = [self.messageArray count];
	
	self.messageNumber.text = [NSString stringWithFormat:@"Msg %d of %d", msg, total];
}


-(void)initMessageInfo{
	
	if (!self.wasViewed) {
		
		[self performSelectorInBackground:@selector(updateWasViewed) withObject:nil];	 	
	}
	
	self.title = @"Message";
	self.displayDate.text = self.receivedDate;
	self.displaySubject.text = self.subject;
	self.displayBody.text = self.body;
	self.teamLabel.text = self.teamName;
	
    bool removed = false;
	if ((self.senderName == nil) || [self.senderName isEqualToString:@""]) {
        
        self.displaySender.text = @"rTeam";
  
        removed = true;
		NSMutableArray *items = [[self.myToolbar.items mutableCopy] autorelease];
		[items removeObject: self.replyButton];
		self.myToolbar.items = items;
	}else {
		self.displaySender.text = self.senderName;
	}
    
   
	if (!removed) {
        
        if ([self.userRole isEqualToString:@"fan"]){
            NSMutableArray *items = [[self.myToolbar.items mutableCopy] autorelease];
            [items removeObject: self.replyButton];
            self.myToolbar.items = items;

        }
    }
	
}


-(void)updateWasViewed{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		if (self.teamId == nil) {
			self.teamId = self.origTeamId;
		}
		NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :@"" :@"true" :@"" :@""];
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			
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

	
	[pool drain];
	
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
				
				MessageThreadInbox *newMessage = [self.messageArray objectAtIndex:self.currentMessageNumber];
				
				self.wasViewed = newMessage.wasViewed;
				self.threadId = newMessage.threadId;
				self.subject = newMessage.subject;
				self.body = newMessage.body;
				self.senderName = newMessage.senderName;
				self.senderId = newMessage.senderId;
				self.confirmStatus = newMessage.status;
				self.teamName = newMessage.teamName;

				if (!((newMessage.teamId == nil) || ([newMessage.teamId isEqualToString:@""]))) {
					self.teamId = newMessage.teamId;
				}
				
                self.isAlert = false;
                [self performSelectorInBackground:@selector(getThreadInfo) withObject:nil];
                
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.receivedDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				[dateFormat release];
				
				if (self.currentMessageNumber == 0) {
					[self.upDown setEnabled:NO forSegmentAtIndex:0];
				}
				
				[self initMessageInfo];
				
			}
			
			break;
		case 1:
			self.upDown.selectedSegmentIndex = -1;
			
			if (self.currentMessageNumber != ([self.messageArray count] - 1)) {
				//Go down one messages
           
                
				[self.upDown setEnabled:YES forSegmentAtIndex:0];

				self.currentMessageNumber++;
				
				MessageThreadInbox *newMessage = [self.messageArray objectAtIndex:self.currentMessageNumber];
				
				self.wasViewed = newMessage.wasViewed;
				self.threadId = newMessage.threadId;
				self.subject = newMessage.subject;
				self.body = newMessage.body;
				self.senderName = newMessage.senderName;
				self.senderId = newMessage.senderId;
				self.confirmStatus = newMessage.status;
				self.teamName = newMessage.teamName;

				if (!((newMessage.teamId == nil) || ([newMessage.teamId isEqualToString:@""]))) {
					self.teamId = newMessage.teamId;
				}
				
                self.isAlert = false;
                [self performSelectorInBackground:@selector(getThreadInfo) withObject:nil];
                
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.receivedDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				[dateFormat release];
				
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


-(void)reply{
	
	//SendMessage *tmp = [[SendMessage alloc] init];
	
	MessageReply *tmp = [[MessageReply alloc] init];
	tmp.teamId = self.teamId;
	tmp.replyToName = self.senderName;
	tmp.replyToId = self.senderId;
	tmp.userRole = self.userRole;
	tmp.origMessage = self.body;
    
    if (self.isAlert) {
        tmp.replyAlert = true;
    }
	
	if (![[self.subject substringToIndex:3] isEqualToString:@"RE:"]) {
		
		if ([self.subject isEqualToString:@"(no subject)"]) {
			tmp.subject = self.subject;
		}else {
			tmp.subject = [@"RE: " stringByAppendingString:self.subject];
		}

	}else {
		tmp.subject = self.subject;
	}

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
	NSDate *tmpDate = [dateFormat dateFromString:self.receivedDate];
	[dateFormat setDateFormat:@"MM/dd"];
	tmp.origMessageDate = [dateFormat stringFromDate:tmpDate];
	[dateFormat release];
	
	
		
	[self.navigationController pushViewController:tmp animated:YES];
	
	
	/*//SendMessage *tmp = [[SendMessage alloc] init];
	 
	 MessageReply *tmp = [[MessageReply alloc] init];
	 tmp.teamId = self.teamId;
	 tmp.sendTeamId = self.teamId;
	 tmp.isReply = true;
	 tmp.replyTo = self.senderName;
	 tmp.replyToId = self.senderId;
	 tmp.origLoc = @"reply";
	 tmp.userRole = self.userRole;
	 tmp.includeFans = @"false";
	 
	 if (![[self.subject substringToIndex:3] isEqualToString:@"RE:"]) {
	 
	 if ([self.subject isEqualToString:@"(no subject)"]) {
	 tmp.subject = self.subject;
	 }else {
	 tmp.subject = [@"RE: " stringByAppendingString:self.subject];
	 }
	 
	 }else {
	 tmp.subject = self.subject;
	 }
	 
	 
	 [self.navigationController pushViewController:tmp animated:YES];
	 */
}

-(void)deleteMessage{
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		if (self.teamId == nil) {
			self.teamId = self.origTeamId;
		}
		
		NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :@"" :@"" :@"" :@"archived"];
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			NSArray *temp = [self.navigationController viewControllers];
			int num = [temp count];
			num -= 2;
			
			//Could be "MessageTabs", "GameTabs", "PracticeTabs", or "CurrentTeamTabs"
			
			if ([[temp objectAtIndex:num] class] == [MessagesTabs class]) {
				MessagesTabs *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 0;
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
			}else if ([[temp objectAtIndex:num] class] == [GameTabsNoCoord class]) {
				GameTabsNoCoord *cont = [temp objectAtIndex:num];
				cont.selectedIndex = 3;
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

-(void)viewMoreDetail{
	
	ViewDetailMessageReplies *tmp = [[ViewDetailMessageReplies alloc] init];
	tmp.teamId = self.teamId;
	tmp.threadId = self.threadId;
	tmp.replyArray = self.individualReplies;
	
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


-(void)getThreadInfo{
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		if (self.teamId == nil) {
			self.teamId = self.origTeamId;
		}
		
		NSDictionary *response = [ServerAPI getMessageThreadInfo:token :self.teamId :self.threadId];
		
		NSString *status1 = [response valueForKey:@"status"];
		
		if ([status1 isEqualToString:@"100"]){
			
			NSDictionary *threadInfo1 = [response valueForKey:@"messageThreadInfo"];
            
            NSString *alert = [threadInfo1 valueForKey:@"isAlert"];
                        
            if ([alert isEqualToString:@"true"]){
                self.isAlert = true;
            }
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status1 intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.errorString = @"*Error retrieving poll information.";
					break;
				case 1:
					//error connecting to server
					//self.errorString = @"*Error retrieving poll information.";
					break;
				default:
					//log status code
					//self.errorString = @"*Error retrieving poll information.";
					break;
			}
		}
		
	}
    
    [pool drain];
	
}

-(void)viewDidUnload{
	
	
	//subject = nil;
	//body = nil;
	//receivedDate = nil;
	displayDate = nil;
	displayBody = nil;
	displaySubject = nil;
	//teamId = nil;
	//eventId = nil;
	//eventType = nil;
	//threadId = nil;
	//senderId = nil;
	//senderName = nil;
	//userRole = nil;
	replyButton = nil;
	myToolbar = nil;
	replyMessage = nil;
	viewMoreDetailButton = nil;
	confirmationsLabel = nil;
	//confirmStatus = nil;
	//individualReplies = nil;
	messageNumber = nil;
	//messageArray = nil;
	upDown = nil;
	teamLabel = nil;
	//teamName = nil;
	//origTeamId = nil;
	
	individualReplies = nil;

	[super viewDidUnload];

	
}

-(void)dealloc{
	
	[subject release];
	[body release];
	[receivedDate release];
	[displayDate release];
	[displayBody release];
	[displaySubject release];
	[teamId release];
	[eventId release];
	[eventType release];
	[threadId release];
	[senderId release];
	[senderName release];
	[userRole release];
	[replyButton release];
	[myToolbar release];
	[replyMessage release];
	[viewMoreDetailButton release];
	[confirmationsLabel release];
	[confirmStatus release];
	[individualReplies release];
	[messageNumber release];
	[messageArray release];
	[upDown release];
	[teamLabel release];
	[teamName release];
	[origTeamId release];
	
	[individualReplies release];
	//[wasViewed release];
	[super dealloc];
	
}

@end
