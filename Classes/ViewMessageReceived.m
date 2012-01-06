//
//  ViewMessageReceived.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewMessageReceived.h"
#import "MyLineView.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CurrentTeamTabs.h"
#import "PracticeTabs.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "ViewDetailMessageReplies.h"
#import "MessageThreadInbox.h"
#import "FastActionSheet.h"
#import "MessageReply.h"
#import "SendPrivateMessage.h"
#import "Player.h"

@implementation ViewMessageReceived
@synthesize subject, body, receivedDate, displayDate, displayBody, displaySubject, teamId, eventId, eventType, wasViewed, threadId,
senderName, senderId, displaySender, userRole, replyButton, myToolbar, replySuccess, replyMessage, viewMoreDetailButton,
confirmationsLabel, confirmStatus, individualReplies, messageNumber, messageArray, upDown,
currentMessageNumber, teamLabel, teamName, origTeamId, isAlert, fromClass;

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

	UIBarButtonItem *tmp = [[UIBarButtonItem alloc] initWithCustomView: self.upDown];
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
	self.displayDate.text = [self getDateLabel:self.receivedDate];
	self.displaySubject.text = self.subject;
	self.displayBody.text = self.body;
	self.teamLabel.text = self.teamName;
	
    bool removed = false;
	if ((self.senderName == nil) || [self.senderName isEqualToString:@""]) {
        
        self.displaySender.text = @"rTeam";
  
        removed = true;
		NSMutableArray *items = [self.myToolbar.items mutableCopy];
		[items removeObject: self.replyButton];
		self.myToolbar.items = items;
	}else {
		self.displaySender.text = self.senderName;
	}
    
   
	if (!removed) {
        
        if ([self.userRole isEqualToString:@"fan"]){
            NSMutableArray *items = [self.myToolbar.items mutableCopy];
            [items removeObject: self.replyButton];
            self.myToolbar.items = items;

        }
    }
	
}


-(void)updateWasViewed{

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            if (self.teamId == nil) {
                self.teamId = self.origTeamId;
            }
            NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :@"" :@"true" :@"" :@"" :@""];
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
        

    }
	
	
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
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.createdDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				
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
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.createdDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				
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
	
    UINavigationController *tmpController = [[UINavigationController alloc] init];
    SendPrivateMessage *tmp = [[SendPrivateMessage alloc] init];
    
    tmp.teamId = self.teamId;
    
    [tmpController pushViewController:tmp animated:NO];
    
    tmp.isReply = true;
    
    Player *newPlayer = [[Player alloc] init];
    newPlayer.firstName = self.senderName;
    newPlayer.memberId = self.senderId;
    
    NSArray *tmpArray = [NSArray arrayWithObject:newPlayer];
    
    tmp.recipientObjects = [NSArray arrayWithArray:tmpArray];
    
    [self.navigationController presentModalViewController:tmpController animated:YES];

}

-(void)deleteMessage{
    
    //[self.respondingActivity startAnimating];
    [self performSelectorInBackground:@selector(deleteAction) withObject:nil];
	
}

-(void)deleteAction{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		if (self.teamId == nil) {
			self.teamId = self.origTeamId;
		}
		
		NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :@"" :@"" :@"" :@"archived" :@""];
		NSString *status1 = [response valueForKey:@"status"];
		
		if ([status1 isEqualToString:@"100"]){
			
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
		
        [self performSelectorOnMainThread:@selector(doneDelete) withObject:nil waitUntilDone:NO];
	}
    
}

-(void)doneDelete{
    
    //[self.respondingActivity stopAnimating];
    self.fromClass.fromPost = true;
    [self.navigationController popViewControllerAnimated:NO];
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
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)getThreadInfo{
 
    @autoreleasepool {
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
        

    }
		
}


//Sends back the dateLabel (5 minutes ago, 3 days ago, etc) of the post from the created date
-(NSString *)getDateLabel:(NSString *)dateCreated{
    //date created format: yyyy-MM-dd HH:mm  
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate *createdDateOrig = [dateFormatter dateFromString:dateCreated];
    
    NSTimeInterval interval = [todaysDate timeIntervalSinceDate:createdDateOrig];
    
    if (interval <  3600) {
        //Less than an hour, do minutes
        
        int minutes = floor(interval/60.0);
        
        if (minutes == 0) {
            return @"< 1 minute ago";
        }
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
        
    }else if (interval < 86400){
        //less than a day, do hours
        
        int hours = floor(interval/3600.0);
        
        if (hours == 1) {
            return @"1 hour ago";
        }
        return [NSString stringWithFormat:@"%d hours ago", hours];
        
    }else{
        //do days
        
        int days = floor(interval/86400.0);
        
        if (days == 1) {
            return @"1 day ago";
        }
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    
}

-(void)viewDidUnload{
	

	displayDate = nil;
	displayBody = nil;
	displaySubject = nil;
	replyButton = nil;
	myToolbar = nil;
	replyMessage = nil;
	viewMoreDetailButton = nil;
	confirmationsLabel = nil;
	messageNumber = nil;
	upDown = nil;
	teamLabel = nil;
	individualReplies = nil;

	[super viewDidUnload];

	
}


@end
