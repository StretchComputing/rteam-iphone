//
//  ViewPollReceived.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.f
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewPollReceived.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CurrentTeamTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "PollResultsView.h"
#import "ViewDetailPollReplies.h"
#import "MessageThreadInbox.h"
#import "FastActionSheet.h"
#import "NewActivity.h"
#import "GANTracker.h"

@implementation ViewPollReceived
@synthesize subject, body, receivedDate, displayDate, displayBody, displaySubject, teamId, eventId, eventType, pollChoices, buttonOption1,
buttonOption2, buttonOption3, buttonOption4, buttonOption5, finalAnswer, threadId, wasViewed, displayFrom, from, status,
howToRespondMessage, finalizedMessage, displayResults, followUpMessage, ownReply, displayScroll, viewMoreDetailButton,
individualReplies, downArrow, pollArray, pollNumber, currentPollNumber, upDown, teamName, teamNameLabel, origTeamId, myPollResultsView, myLineView,
loadingActivity, loadingLabel, messageThreadInfo, deleteButton, errorLabel, errorString, respondingActivity, fromClass;

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
	
	self.loadingLabel.hidden = YES;
	
	self.myPollResultsView = [[PollResultsView alloc] init];
	self.myPollResultsView.view.frame = CGRectMake(0, 240, 320, 145);
	[self.displayScroll addSubview:self.myPollResultsView.view];
	self.myPollResultsView.view.hidden = YES;
	
	self.myLineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 362, 320, 1)];
	self.myLineView.backgroundColor = [UIColor grayColor];
	[self.displayScroll addSubview:self.myLineView];
	self.myLineView.hidden = YES;
	
	
	[self initPollInfo];
	

	self.upDown.selectedSegmentIndex = -1;
	[self.upDown addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *tmp = [[UIBarButtonItem alloc] initWithCustomView: self.upDown];
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
				
				MessageThreadInbox *newMessage = [self.pollArray objectAtIndex:self.currentPollNumber];
				
				self.wasViewed = newMessage.wasViewed;
				self.threadId = newMessage.threadId;
				self.subject = newMessage.subject;
				self.body = newMessage.body;
				self.from = newMessage.senderName;
				self.status = newMessage.status;
				self.pollChoices = newMessage.pollChoices;
				self.teamName = newMessage.teamName;

				if (!((newMessage.teamId == nil) || ([newMessage.teamId isEqualToString:@""]))) {
					self.teamId = newMessage.teamId;
				}
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.createdDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				
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
				
				MessageThreadInbox *newMessage = [self.pollArray objectAtIndex:self.currentPollNumber];
				
				self.wasViewed = newMessage.wasViewed;
				self.threadId = newMessage.threadId;
				self.subject = newMessage.subject;
				self.body = newMessage.body;
				self.from = newMessage.senderName;
				self.status = newMessage.status;
				self.pollChoices = newMessage.pollChoices;
				self.teamName = newMessage.teamName;
				
				if (!((newMessage.teamId == nil) || ([newMessage.teamId isEqualToString:@""]))) {
					self.teamId = newMessage.teamId;
				}
				
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *tmpDate = [dateFormat dateFromString:newMessage.createdDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				self.receivedDate = [dateFormat stringFromDate:tmpDate];
				
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
	
	self.individualReplies = [NSArray array];
	[self.ownReply setHidden:YES];
	self.displayResults = true;
	self.finalizedMessage.delegate = self;
	[self.followUpMessage setHidden:YES];
	
	self.teamNameLabel.text = self.teamName;
	
	self.displayBody.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.viewMoreDetailButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	[self.viewMoreDetailButton setHidden:YES];
	
	[self.displayScroll
	 setContentSize:CGSizeMake(320,500)];
	
	self.finalizedMessage.text = @"";
	if (!self.wasViewed) {
		
		[self performSelectorInBackground:@selector(updateWasViewed) withObject:nil];	 	
	}
	
	
	self.title = @"Poll";
	self.displayDate.text = self.receivedDate;
	self.displaySubject.text = self.subject;
	self.displayBody.text = self.body;
	
	if (self.displayBody.contentSize.height > 54) {
		[self.downArrow setHidden:NO];
	}else {
		[self.downArrow setHidden:YES];
	}
	
	self.displayFrom.text = [@"Poll From: " stringByAppendingString:self.from];

	[self.buttonOption1 setTitle:[self.pollChoices objectAtIndex:0] forState:UIControlStateNormal];
	self.buttonOption1.titleLabel.textAlignment = UITextAlignmentCenter;
	self.buttonOption1.hidden = NO;
	[self.buttonOption2 setTitle:[self.pollChoices objectAtIndex:1] forState:UIControlStateNormal];
	self.buttonOption2.titleLabel.textAlignment = UITextAlignmentCenter;
	self.buttonOption2.hidden = NO;
	
	int numChoices = [self.pollChoices count];
	self.howToRespondMessage.frame = CGRectMake(13, 307, 300, 51);

	if (numChoices > 2) {
		[self.buttonOption3 setTitle:[self.pollChoices objectAtIndex:2] forState:UIControlStateNormal];
		self.buttonOption3.titleLabel.textAlignment = UITextAlignmentCenter;
		self.buttonOption3.hidden = NO;
	}else {
		[self.buttonOption3 setHidden:YES];
	}
	
	if (numChoices > 3) {
		[self.buttonOption4 setTitle:[self.pollChoices objectAtIndex:3] forState:UIControlStateNormal];
		self.buttonOption4.titleLabel.textAlignment = UITextAlignmentCenter;
		self.buttonOption4.hidden = NO;
		self.howToRespondMessage.frame = CGRectMake(13, 332, 300, 51);

	}else {
		[self.buttonOption4 setHidden:YES];
	}
	
	if (numChoices > 4) {
		[self.buttonOption5 setTitle:[self.pollChoices objectAtIndex:4] forState:UIControlStateNormal];
		self.buttonOption5.titleLabel.textAlignment = UITextAlignmentCenter;
		self.buttonOption5.hidden = NO;
		self.howToRespondMessage.frame = CGRectMake(13, 375, 300, 51);
	}else {
		[self.buttonOption5 setHidden:YES];
	}
	
	[self.finalizedMessage setHidden:YES];
	
	self.errorLabel.text = @"";
        
	if ([self.status isEqualToString:@"replied"] || [self.status isEqualToString:@"finalized"]) {
		
		[self.buttonOption1 setHidden:YES];
		[self.buttonOption2 setHidden:YES];
		[self.buttonOption3 setHidden:YES];
		[self.buttonOption4 setHidden:YES];
		[self.buttonOption5 setHidden:YES];
		
		[self.howToRespondMessage setHidden:YES];
		
		self.loadingLabel.hidden = NO;
		[self.loadingActivity startAnimating];
		
		self.displayBody.hidden = YES;
		self.myPollResultsView.view.hidden = YES;
		self.deleteButton.enabled = NO;
		[self performSelectorInBackground:@selector(getMessageThreadInfo) withObject:nil];
		
	}else {
		self.myPollResultsView.view.hidden = YES;
		self.myLineView.hidden = YES;
		self.howToRespondMessage.hidden = NO;
	}

	
}


-(void)getMessageThreadInfo{

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
                
                self.messageThreadInfo = [NSDictionary dictionary];
                
                self.messageThreadInfo = [response valueForKey:@"messageThreadInfo"];
                
                self.errorString = @"";
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status1 intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.errorString = @"*Error retrieving poll information.";
                        break;
                    case 1:
                        //error connecting to server
                        self.errorString = @"*Error retrieving poll information.";
                        break;
                    default:
                        //log status code
                        self.errorString = @"*Error retrieving poll information.";
                        break;
                }
            }
            
        }
        
        
        [self performSelectorOnMainThread:@selector(doneInfo) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneInfo{
	[self.loadingActivity stopAnimating];
	self.loadingLabel.hidden = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
	//Show all views
	self.displayBody.hidden = NO;
	self.deleteButton.enabled = YES;
	
	NSString *message = @"";

	NSString *isPublic = [self.messageThreadInfo valueForKey:@"isPublic"];
	
	
	if ([isPublic isEqualToString:@"true"]) {
		self.displayResults = true;
		[self.viewMoreDetailButton setHidden:NO];
	}else {
		self.displayResults = false;
		[self.viewMoreDetailButton setHidden:YES];
	}
	
	
	
	if ([self.status isEqualToString:@"replied"]) {
		message =  @"You have already replied to this poll.";
		
		if (self.displayResults) {
			message = [message stringByAppendingString:@" The current results are displayed below:"];
		}
		
	}else {
		message = @"This poll has been marked as 'Completed' by the sender.";
		
		if (self.displayResults) {
			message = [message stringByAppendingString:@" The final results are displayed below:"];
		}
	}
	
	self.finalizedMessage.text = message;
	self.finalizedMessage.textAlignment = UITextAlignmentCenter;
	[self.finalizedMessage setHidden:NO];
	
	
	
	NSArray *pollOptions = [self.messageThreadInfo valueForKey:@"pollChoices"];
	
	self.myPollResultsView.o3 = @"";
	self.myPollResultsView.o4 = @"";
	self.myPollResultsView.o5 = @"";
	for (int i = 0; i < [pollOptions count]; i++) {
		
		if (i == 0) {
			self.myPollResultsView.o1 = [[pollOptions objectAtIndex:i] stringByAppendingString:@": "];
		}
		if (i == 1) {
			self.myPollResultsView.o2 = [[pollOptions objectAtIndex:i] stringByAppendingString:@": "];
		}
		if (i == 2) {
			self.myPollResultsView.o3 = [[pollOptions objectAtIndex:i] stringByAppendingString:@": "];
		}
		if (i == 3) {
			self.myPollResultsView.o4 = [[pollOptions objectAtIndex:i] stringByAppendingString:@": "];
		}
		if (i == 4) {
			self.myPollResultsView.o5 = [[pollOptions objectAtIndex:i] stringByAppendingString:@": "];
		}
	}
	
	NSArray *recip = [self.messageThreadInfo valueForKey:@"members"];
	
	
	self.individualReplies = recip;
	NSMutableArray *pollCounts = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
	for (int i = 0; i < [recip count]; i++) {
		NSDictionary *memberReplyInfo = [recip objectAtIndex:i];
		
		NSString *thisUser = [[memberReplyInfo valueForKey:@"belongsToUser"] stringValue];
		
		
		if ([thisUser isEqualToString:@"1"]) {
			self.ownReply.text = @"You did not reply.";
			[self.ownReply setHidden:NO];
		}
		
		if ([memberReplyInfo valueForKey:@"reply"] != nil) {
			
			NSString *reply = [memberReplyInfo valueForKey:@"reply"];
			
			if ([thisUser isEqualToString:@"1"]) {
				
				NSString *replyDate = [memberReplyInfo valueForKey:@"replyDate"];
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *formatedDate = [dateFormat dateFromString:replyDate];
				[dateFormat setDateFormat:@"MMM dd"];
				NSString *date = [dateFormat stringFromDate:formatedDate];
				[dateFormat setDateFormat:@"hh:mm aa"];
				NSString *time = [dateFormat stringFromDate:formatedDate];
				
				self.ownReply.text = [NSString stringWithFormat:@"Your reply was '%@', on %@ at %@", reply, date, time];
				self.ownReply.lineBreakMode = UILineBreakModeWordWrap;
				self.ownReply.numberOfLines = 2;
				self.ownReply.textColor = [UIColor blueColor];
				
				if (self.displayResults) {
					[self.ownReply setHidden:NO];
					
				}else {
					[self.ownReply setHidden:NO];
					self.ownReply.text = @"Results have been set to 'private'.";
				}
				
			}
			
			
			for (int j = 0; j < [pollOptions count]; j++) {
				NSString *tmpOption = [pollOptions objectAtIndex:j];
				if ([tmpOption isEqualToString:reply]) {
					
					NSString *tmpCount = [pollCounts objectAtIndex:j];
					int x = [tmpCount intValue];
					x++;
					NSString *newValue = [NSString stringWithFormat:@"%d", x];
					[pollCounts replaceObjectAtIndex:j withObject:newValue];
					
				}
			}
			
			
			
		}
	}
	
	self.myPollResultsView.no3 = @"";
	self.myPollResultsView.no4 = @"";
	self.myPollResultsView.no5 = @"";
	
	self.myPollResultsView.no1 = [pollCounts objectAtIndex:0];
	self.myPollResultsView.no2 = [pollCounts objectAtIndex:1];
	self.myPollResultsView.no3 = [pollCounts objectAtIndex:2];
	self.myPollResultsView.no4 = [pollCounts objectAtIndex:3];
	self.myPollResultsView.no5 = [pollCounts objectAtIndex:4];
	
	
	self.myPollResultsView.view.hidden = NO;
	self.myLineView.hidden = NO;
	[self.myPollResultsView setLabels];
	
	if ([self.messageThreadInfo valueForKey:@"followUpMessage"] != nil) {
		NSString *followUp = [self.messageThreadInfo valueForKey:@"followUpMessage"];
		
		if (![followUp isEqualToString:@"none"]) {
			
			self.followUpMessage.text = [@"Follow Up: " stringByAppendingString:followUp];
			[self.followUpMessage setHidden:NO];
			[self.view bringSubviewToFront:self.followUpMessage];
			
		}
	}
		
	}else {
		self.errorLabel.text = self.errorString;
		self.errorLabel.hidden = NO;
	}
	
	//self.myPollResultsView.view.hidden = YES;
	[self.view bringSubviewToFront:self.ownReply];
	[self.view bringSubviewToFront:self.viewMoreDetailButton];
	[self.view bringSubviewToFront:self.myLineView];
	
	if ([self.pollChoices count] == 5) {
		
		self.ownReply.frame = CGRectMake(13, 416, 300, 51);
		self.followUpMessage.frame = CGRectMake(13, 467, 303, 80);

		self.myLineView.frame = CGRectMake(0, 422, 320, 1);
		self.viewMoreDetailButton.frame = CGRectMake(88, 388, 144, 30);
		
		self.myPollResultsView.view.frame = CGRectMake(0, 240, 320, 145);
		
	}else if ([self.pollChoices count] == 4) {
		
		self.ownReply.frame = CGRectMake(13, 391, 300, 51);
		self.followUpMessage.frame = CGRectMake(13, 442, 303, 80);

		self.myLineView.frame = CGRectMake(0, 397, 320, 1);
		self.viewMoreDetailButton.frame = CGRectMake(88, 363, 144, 30);
		
		self.myPollResultsView.view.frame = CGRectMake(0, 240, 320, 115);
		
	}else {
		
		self.myPollResultsView.view.frame = CGRectMake(0, 240, 320, 85);
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
            
        }

    }

	
	
}

-(void)replyOption1{
	
	[self finalReply:[self.pollChoices objectAtIndex:0]];
}

-(void)replyOption2{
	[self finalReply:[self.pollChoices objectAtIndex:1]];
}

-(void)replyOption3{
	[self finalReply:[self.pollChoices objectAtIndex:2]];
}

-(void)replyOption4{
	[self finalReply:[self.pollChoices objectAtIndex:3]];
}

-(void)replyOption5{
	[self finalReply:[self.pollChoices objectAtIndex:4]];
}

-(void)finalReply:(NSString *)reply{
	
	self.finalAnswer = reply;
	NSString *confirm = [[@"Send poll response with the answer '" stringByAppendingString:reply] stringByAppendingString:@"'?"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:confirm message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
				
        [self.respondingActivity startAnimating];
        
        self.buttonOption1.enabled = NO;
        self.buttonOption2.enabled = NO;
        self.buttonOption5.enabled = NO;
        self.buttonOption3.enabled = NO;
        self.buttonOption4.enabled = NO;

        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Send Poll Response"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
        [self performSelectorInBackground:@selector(sendPollResponse) withObject:nil];
	}

}

-(void)sendPollResponse{

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
            
            NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :self.threadId :self.finalAnswer :@"" :@"" :@"" :@""];
            
            NSString *status1 = [response valueForKey:@"status"];
                        
            if ([status1 isEqualToString:@"100"]){
                
                self.errorString = @"";
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status1 intValue];
                
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
        
        [self performSelectorOnMainThread:@selector(doneSendResponse) withObject:nil waitUntilDone:NO];

    }
   
}

-(void)doneSendResponse{
    
    [self.respondingActivity stopAnimating];
    self.buttonOption1.enabled = YES;
    self.buttonOption2.enabled = YES;
    self.buttonOption5.enabled = YES;
    self.buttonOption3.enabled = YES;
    self.buttonOption4.enabled = YES;
    
    if ([self.errorString isEqualToString:@""]) {
        
        self.fromClass.fromPost = true;
        [self.navigationController popViewControllerAnimated:YES];
        
    
    }else{
        self.errorLabel.text = self.errorString;
    }

}
-(void)deletePoll{

    [self.respondingActivity startAnimating];
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
    
    [self.respondingActivity stopAnimating];
    self.fromClass.fromPost = true;
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewMoreDetail{
	
	ViewDetailPollReplies *tmp = [[ViewDetailPollReplies alloc] init];
	tmp.replyArray = self.individualReplies;
	tmp.teamId = self.teamId;
	
	
	if ([self.status isEqualToString:@"finalized"]) {
		tmp.finalized = true;
	}
	

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

-(void)viewDidUnload{
	
	displayDate = nil;
	displayBody = nil;
	displaySubject = nil;

	buttonOption1 = nil;
	buttonOption2 = nil;
	buttonOption3 = nil;
	buttonOption4 = nil;
	buttonOption5 = nil;
	displayFrom = nil;

	howToRespondMessage = nil;
    finalizedMessage = nil;
	followUpMessage = nil;
	ownReply = nil;
	displayScroll = nil;
	viewMoreDetailButton = nil;
	downArrow = nil;
	pollNumber = nil;
	upDown = nil;
	teamNameLabel = nil;
	myLineView = nil;
	myPollResultsView = nil;
	loadingActivity = nil;
	loadingLabel = nil;
	deleteButton = nil;
	errorLabel = nil;
    respondingActivity = nil;
	[super viewDidUnload];

	
}

@end
