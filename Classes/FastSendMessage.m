//
//  FastSendMessage.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastSendMessage.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "MessageTabs.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "FastSelectRecipients.h"
#import "Player.h"

#import "MessageAssocEvent.h"
#import "FastSelectRecipientsTeam.h"
#import "Team.h"
#import "CurrentTeamTabs.h"
#import "ViewMessageReceived.h"
#import "Fan.h"

@implementation FastSendMessage
@synthesize activity, sendButton, subjectField, messageField, teamId, createSuccess, errorMessage, eventId, eventType, origLoc, subject, recipients,
toTeam, recipientLabel, isReply, replyTo, replyToId, userRole, eventAssocLabel, eventAssocButton, chosenEvent, chosenEventType,
chosenEventDate, fromWhere, sendTeamId, confirmationControl, includeFans, fansOnly, sendWithAlertButton, sendAlert, errorString, recipActivity,
selectRecipButton, keyboardToolbar;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	
	self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    self.keyboardToolbar.barStyle = UIBarStyleBlack;
    self.keyboardToolbar.translucent = YES;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *doneKeyboard =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self action:@selector(doneKeyboard)];
    
    
	NSArray *items1 = [NSArray arrayWithObjects:flexibleSpace, doneKeyboard, nil];
	self.keyboardToolbar.items = items1;
    
    
    
    [self.view addSubview:self.keyboardToolbar];
  
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

-(void)doneKeyboard{
    
    [self.messageField resignFirstResponder];
    [self becomeFirstResponder];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	[self.recipActivity stopAnimating];
	self.selectRecipButton.hidden = NO;
	
	self.title = @"Send Message";
	[self.chosenEvent setHidden:YES];
	
	if ([self.eventId length] > 0) {
		
		
		if ([self.chosenEventDate length] > 0) {
			if ([self.eventType isEqualToString:@"game"]) {
				self.chosenEventType = @"Game";
			}else if ([self.eventType isEqualToString:@"practice"]) {
				self.chosenEventType = @"Practice";
				
			}else{
				self.chosenEventType = @"Event";
			}
			self.chosenEvent.text = [[[@"Chosen Event: " stringByAppendingString:self.chosenEventType] stringByAppendingString:@" "] stringByAppendingString:self.chosenEventDate];
			self.chosenEvent.textAlignment = UITextAlignmentCenter;
			[self.chosenEvent setHidden:NO];
			[self.eventAssocLabel setHidden:YES];
			[self.eventAssocButton setHidden:NO];
		}else {
			[self.eventAssocLabel setHidden:YES];
			[self.eventAssocButton setHidden:YES];
		}
		
		
	}
	
	if (self.subject != nil) {
		self.subjectField.text = self.subject;
	}
	self.messageField.delegate = self;
	
	if (self.isReply) {
		self.recipientLabel.text = self.replyTo;
	}else {
		self.recipientLabel.text = [self buildRecipientList];
	}
	
	UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 32, 320, 1)];
	line1.backgroundColor = [UIColor grayColor];
	[self.view addSubview:line1];
    [line1 release];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 82, 320, 1)];
	line2.backgroundColor = [UIColor grayColor];
	[self.view addSubview:line2];
    [line2 release];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.sendButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.eventAssocButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.sendWithAlertButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	
	if ((self.teamId == nil) || [self.teamId isEqualToString:@""]) {
		self.eventAssocLabel.hidden = YES;
		self.eventAssocButton.hidden = YES;
	}
	
}



-(NSString *)buildRecipientList{
	
	NSString *list = @"";
	
	if (self.fansOnly) {
		self.fansOnly = false;
		return @"Fans Only";
	}
	
	if (self.toTeam && [self.includeFans isEqualToString:@""]	) {
		return @"Everyone";
	}else if (self.toTeam && [self.includeFans isEqualToString:@"false"]){
		return @"Team Only";
	}else if ([self.recipients count] > 0) {
		//build list
		NSString *tmpList = @"";
		for (int i = 0; i < [self.recipients count]; i++) {
			
			if ([[self.recipients objectAtIndex:i] class] == [Player class]) {
				Player *tmp = [self.recipients objectAtIndex:i];
				
				tmpList = [[tmpList stringByAppendingString:tmp.firstName] stringByAppendingString:@", "];
			}else {
				Fan *tmp = [self.recipients objectAtIndex:i];
				
				tmpList = [[tmpList stringByAppendingString:tmp.firstName] stringByAppendingString:@", "];
			}
			
			
			
		}
		list = [tmpList substringToIndex:[tmpList length]-2];
	}
	
	return list;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    /* Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[self becomeFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    For any other character return TRUE so that the text gets added to the view
     */ 
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.messageField.text isEqualToString:@"Enter your message here..."]){
		self.messageField.text = @"";
	}
}


-(void)send:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	self.sendAlert = @"";
	int intTag = tmp.tag;
	
	if (intTag == 0) {
		self.sendAlert = @"false";
	}else {
		self.sendAlert = @"true";
	}
	
	self.errorMessage.text = @"";
	if (self.toTeam || [self.recipients count] > 0 || self.isReply) {
		
		if (![self.subjectField.text isEqualToString:@""] && ![self.messageField.text isEqualToString:@""] &&
			![self.messageField.text isEqualToString:@"Enter your message here..."]) {
			
			[activity startAnimating];
			
			//Disable the UI buttons and textfields while registering
			
			[sendButton setEnabled:NO];
			[self.navigationItem.leftBarButtonItem setEnabled:NO];
			[self.subjectField setEnabled:NO];
			[self.messageField setEditable:NO];
			
			//Create the team in a background thread
			
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		}else {
			self.errorMessage.text = @"*You must enter a Subject and a Message";
		}
		
	}else {
		self.errorMessage.text = @"*You must choose at least one recipient";
	}
	
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
	
	if (self.eventId == nil){
		self.eventId = @"";
	}
	
	if (self.eventType == nil) {
		self.eventType = @"";
	}
	
	NSDictionary *response = [NSDictionary dictionary];
	NSMutableArray *mutableMemberIds = [NSMutableArray array];
	NSArray *recipientMemberIds = [NSArray array];
	
	
	if (self.isReply) {
		[mutableMemberIds addObject:self.replyToId];
		recipientMemberIds = mutableMemberIds;
	}else if(!self.toTeam){
		
		for (int i = 0; i < [self.recipients count]; i++) {
			Player *tmpPlayer = [self.recipients objectAtIndex:i];
			
			[mutableMemberIds addObject:tmpPlayer.memberId];
		}
		recipientMemberIds = mutableMemberIds;
	}
	
	NSString *messageType = @"plain";
	
	if (self.confirmationControl.selectedSegmentIndex == 0) {
		messageType = @"confirm";
	}
	
	if (![token isEqualToString:@""]){	
		
		response = [ServerAPI createMessageThread:token :self.sendTeamId :self.subjectField.text :self.messageField.text :messageType :self.eventId 
												 :self.eventType :self.sendAlert :[NSArray array] :recipientMemberIds :@"" :self.includeFans :@""];	
		
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

-(void)cancel{
	
	[self.navigationController popViewControllerAnimated:NO];
	
}


- (void)didFinish{
	
	//When background thread is done, return to main thread
	[activity stopAnimating];
	
	if (self.createSuccess){
		
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
		
		self.errorMessage.text = @"Message Sent!";
		self.errorMessage.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0f blue:0.00 alpha:1.0];
		[self performSelector:@selector(cancel) withObject:nil afterDelay:1];		
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send messages.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			self.errorMessage.text = self.errorString;
			self.errorMessage.textColor = [UIColor redColor];
		}
		
		[sendButton setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		self.errorMessage.textColor = [UIColor redColor];
		
		[self.messageField setEditable:YES];
		[self.subjectField setEnabled:YES];
	}
}

-(void)selectRecipients{
	
	self.selectRecipButton.hidden = YES;
	[self.recipActivity startAnimating];
	[self performSelectorInBackground:@selector(checkTeams) withObject:nil];
	
	
}

-(void)checkTeams{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	self.isReply = false;
	self.errorString = @"";
	if (self.teamId == nil || [self.teamId isEqualToString:@""]) {
		
		NSString *token = @"";
		NSArray *teamArray = [NSArray array];
		
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if (mainDelegate.token != nil){
			token = mainDelegate.token;
		}
		
		
		//If there is a token, do a DB lookup to find the teams associated with this coach:
		if (![token isEqualToString:@""]){
			
			NSDictionary *response = [ServerAPI getListOfTeams:token];
			
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				teamArray = [response valueForKey:@"teams"];
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
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
					default:
						//should never get here
						self.errorString = @"*Error connecting to server";
						break;
				}
			}
			
			
		}
		
		if ([teamArray count] == 1) {
			Team *tmpTeam = [teamArray objectAtIndex:0];
			FastSelectRecipients *tmp = [[FastSelectRecipients alloc] init];
			tmp.fromWhere = @"MessagesTabs";
			tmp.messageOrPoll = @"message";
			tmp.teamId = tmpTeam.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if ([teamArray count] > 1) {
			FastSelectRecipientsTeam *tmp = [[FastSelectRecipientsTeam alloc] init];
			tmp.teamArray = teamArray;
			tmp.fromWhere = @"MessagesTabs";
			tmp.messageOrPoll = @"message";
			[self.navigationController pushViewController:tmp animated:YES];
		}else {
			//********************************** NO TEAMS, WHAT NOW?
			self.errorString = @"*You must create or join at least 1 team to send a message.";
		}
		
		
		
	}else {
		FastSelectRecipients *tmp = [[FastSelectRecipients alloc] init];
		tmp.teamId = self.teamId;
		tmp.fromWhere = @"ButtonTabs";
		tmp.messageOrPoll = @"message";
		[self.navigationController pushViewController:tmp animated:YES];
	}
	
	[self performSelectorOnMainThread:@selector(finishedRecip) withObject:nil waitUntilDone:NO];
	[pool drain];
	
}

-(void)finishedRecip{
	
	self.selectRecipButton.hidden = NO;
	[self.recipActivity stopAnimating];
	self.errorMessage.text = self.errorString;
	
}

-(void)associateEvent{
	
	//Add event associate code
	MessageAssocEvent *tmp = [[MessageAssocEvent alloc] init];
	tmp.teamId = self.teamId;
	[self.navigationController pushViewController:tmp animated:YES];
	
}
-(void)endText{
	[self becomeFirstResponder];
	
}



-(void)viewDidUnload{
	
	activity = nil;
	sendButton = nil;
	subjectField = nil;
	messageField = nil;
	//teamId = nil;
	errorMessage = nil;
	//eventId = nil;
	//eventType = nil;
	//origLoc = nil;
	//subject = nil;
	//recipients = nil;
	recipientLabel = nil;
	//replyTo = nil;
	//userRole = nil;
	//replyToId = nil;
	eventAssocLabel = nil;
	eventAssocButton = nil;
	chosenEvent = nil;
	//chosenEventType = nil;
	//chosenEventDate = nil;
	//sendTeamId = nil;
	confirmationControl = nil;
	//includeFans = nil;
	sendWithAlertButton = nil;
	//sendAlert = nil;
	//errorString = nil;
	//fromWhere = nil;
	recipActivity = nil;
	selectRecipButton = nil;
	[super viewDidUnload];
	

	
}

-(void)dealloc{
	
	[activity release];
	[sendButton release];
	[subjectField release];
	[messageField release];
	[teamId release];
	[errorMessage release];
	[eventId release];
	[eventType release];
	[origLoc release];
	[subject release];
	[recipients release];
	[recipientLabel release];
	[replyTo release];
	[userRole release];
	[replyToId release];
	[eventAssocLabel release];
	[eventAssocButton release];
	[chosenEvent release];
	[chosenEventType release];
	[chosenEventDate release];
	[sendTeamId release];
	[confirmationControl release];
	[includeFans release];
	[sendWithAlertButton release];
	[sendAlert release];
	[errorString release];
	[fromWhere release];
	[recipActivity release];
	[selectRecipButton release];
    [keyboardToolbar release];
	[super dealloc];
	
}


@end