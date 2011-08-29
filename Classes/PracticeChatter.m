//
//  PracticeChatter.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PracticeChatter.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SendMessage.h"
#import "SendPoll.h"
#import "MessageThreadOutbox.h"
#import "MessageThreadInbox.h"
#import "ViewMessageSent.h"
#import "ViewMessageReceived.h"
#import "ViewPollSent.h"
#import "ViewPollReceived.h"
#import "SelectRecipients.h"
#import "DeleteSelectButton.h"
#import <QuartzCore/QuartzCore.h>
#import "GameMessageObject.h"
#import "ViewPracticeChatterMessage.h"
#import "FastActionSheet.h"

@implementation PracticeChatter
@synthesize results, teamName, teamId, inboxResults, outboxResults, userRole, noInbox, noOutbox, error, sendMessageButton,
inPseudoEditMode, pseudoSelectedArrayZero, pseudoSelectedArrayOne, editDone, deleteSuccess, threadIdsToArchiveInbox,
threadIdsToArchiveOutbox, messagesOnlyArray, pollsOnlyArray, messagesSentArray, pollsSentArray, myTableView, barActivity,
messageActivity, messageActivityLabel, doneInbox, doneOutbox, practiceId, callReload, messageField, allMessages, errorLabel, errorString, noMessagesLabel,
tmpAllMessages, startDate, infoText, hideTab;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}


-(void)viewDidLoad{
	
	self.title = @"Pracitce Messages";
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	self.myTableView.hidden = YES;
	
	[self.messageActivity startAnimating];
	self.messageActivityLabel.hidden = NO;
	
	self.sendMessageButton.hidden = YES;
	
	self.allMessages = [NSMutableArray array];
	self.noMessagesLabel.hidden = YES;
	
	NSDateFormatter *tmpFormat = [[NSDateFormatter alloc] init];
	[tmpFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
	NSDate *theDate = [tmpFormat dateFromString:self.startDate];
	[tmpFormat setDateFormat:@"MM/dd"];
	NSString *stringDate = [tmpFormat stringFromDate:theDate];
	[tmpFormat release];
	
	self.messageField.placeholder = [NSString stringWithFormat:@"Enter a message for practice on %@...", stringDate];
	
	
}


-(void)timerFire{
	
	self.tmpAllMessages = [NSMutableArray array];
	[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
	
}


-(void)viewWillDisappear:(BOOL)animated{
	
	[myTimer invalidate];
	
}


-(void)viewWillAppear:(BOOL)animated{
	
	
	
	myTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0
											   target: self
											 selector:@selector(timerFire)
											 userInfo: nil repeats:YES];
	
	
	
	if (self.hideTab) {
		self.infoText.frame = CGRectMake(0, 349, 320, 62);
		self.myTableView.frame = CGRectMake(0, 50, 320, 302);
		
	}else {
		self.infoText.frame = CGRectMake(0, 305, 320, 62);
		self.myTableView.frame = CGRectMake(0, 50, 320, 258);
		
	}
	
	
	self.tabBarItem.badgeValue = nil;
	
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];
	
	[self.messageActivity startAnimating];
	self.callReload = false;
	self.tmpAllMessages = [NSMutableArray array];
	[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
	
	
	self.doneInbox = false;
	self.doneOutbox = false;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendMessageButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	
	
	
}


-(void)getAllMessages{
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	self.inboxResults = [NSMutableArray array];
	self.outboxResults = [NSMutableArray array];
	NSString *token = @"";
	NSMutableArray *resultsArray = [NSMutableArray array];
	
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreads:token :self.teamId :@"all" :self.practiceId :@"practice" :@"message" :@"all"];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			resultsArray = [response valueForKey:@"messages"];
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.error = @"*Error connecting to server";
					break;
				default:
					//log status code?
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	self.results = resultsArray;
	
	
	for (int i = 0; i < [self.results count]; i++) {
		
		GameMessageObject *tmpMessage = [[GameMessageObject alloc] init];
		
		if ([[self.results objectAtIndex:i] class] == [MessageThreadInbox class]) {
			
			MessageThreadInbox *tmpInbox = [self.results objectAtIndex:i];
			
			tmpMessage.threadId = tmpInbox.threadId;
			tmpMessage.teamId = tmpInbox.teamId;
			tmpMessage.subject = tmpInbox.subject;
			tmpMessage.body = tmpInbox.body;
			tmpMessage.status = tmpInbox.status;
			tmpMessage.messageDate = tmpInbox.receivedDate;
			tmpMessage.teamName = tmpInbox.teamName;
			tmpMessage.senderId = tmpInbox.senderId;
			tmpMessage.senderName = tmpInbox.senderName;
			
			if (!tmpInbox.wasViewed) {
				[self performSelectorInBackground:@selector(updateWasViewed:) withObject:tmpInbox.threadId];
			}
			
		}else {
			
			MessageThreadOutbox *tmpOutbox = [self.results objectAtIndex:i];
			
			tmpMessage.threadId = tmpOutbox.threadId;
			tmpMessage.teamId = tmpOutbox.teamId;
			tmpMessage.subject = tmpOutbox.subject;
			tmpMessage.body = tmpOutbox.body;
			tmpMessage.status = tmpOutbox.status;
			tmpMessage.messageDate = tmpOutbox.createdDate;
			tmpMessage.teamName = tmpOutbox.teamName;
			tmpMessage.senderId = @"";
			tmpMessage.senderName = @"";
			
		}
		
		[self.tmpAllMessages addObject:tmpMessage];
		[tmpMessage release];
		
	}
	
	
	NSSortDescriptor *inboxSort = [[NSSortDescriptor alloc] initWithKey:@"messageDate" ascending:NO];
	[self.tmpAllMessages sortUsingDescriptors:[NSArray arrayWithObject:inboxSort]];
    [inboxSort release];
	
	
	
	
	[self performSelectorOnMainThread:@selector(finishedMessages) withObject:nil waitUntilDone:NO];	[pool drain];
    [pool drain];


    
}


-(void)finishedMessages{
	
	self.allMessages = [NSMutableArray arrayWithArray:self.tmpAllMessages];
	
	if ([self.allMessages count] == 0) {
		self.noMessagesLabel.hidden = NO;
	}else {
		self.noMessagesLabel.hidden = YES;
	}
	
	[self.barActivity stopAnimating];
	[self.messageActivity stopAnimating];
	self.messageActivityLabel.hidden = YES;
	self.myTableView.hidden = NO;
	self.callReload = true;
	[self.myTableView reloadData];
	
	
}

-(void)sendMessage{
	
	self.errorLabel.text = @"";
	
	if ([self.messageField.text isEqualToString:@""]) {
		self.errorLabel.text = @"*Enter a message first.";
	}else {
		
		self.sendMessageButton.enabled = NO;
		self.messageField.enabled = NO;
		[self.messageActivity startAnimating];
		[self performSelectorInBackground:@selector(createMessage) withObject:nil];
	}
	
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *InboxCell=@"InboxCell";
	static NSString *OutboxCell=@"OutboxCell";
	
	
	static NSInteger textTag = 1;
	static NSInteger bubbleImageInboxTag = 2;
	static NSInteger bubbleImageOutboxTag = 3;
	static NSInteger dateTag = 4;
	static NSInteger fromLabelTag = 5;
	static NSInteger fromMeLabelTag = 6;
	
	
	NSUInteger row = [indexPath row];
	bool isInbox = false;
	
	GameMessageObject *message = [self.allMessages objectAtIndex:row];
	if (![message.senderId isEqualToString:@""]) {
		isInbox = true;
	}
	
	UITableViewCell *cell;	
	
	if (isInbox) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:InboxCell];
		
	}else {
		
		cell = [tableView dequeueReusableCellWithIdentifier:OutboxCell];
		
	}
	
	
	if (cell == nil){
		
		CGRect frame;
		
		
		if (isInbox) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:InboxCell] autorelease];
			
			frame.origin.x = 5;
			frame.origin.y = 20;
			frame.size.height = 70;
			frame.size.width = 240;
			UIImageView *bubbleImageInbox = [[UIImageView alloc] initWithFrame:frame];
			bubbleImageInbox.tag = bubbleImageInboxTag;
			bubbleImageInbox.image = [UIImage imageNamed:@"messageBubbleBlue.png"];
			[cell.contentView addSubview:bubbleImageInbox];
			[bubbleImageInbox release];
			
			frame.origin.x = 5;
			frame.origin.y = 92;
			frame.size.width = 160;
			frame.size.height = 20;
			UILabel *fromLabel = [[UILabel alloc] initWithFrame:frame];
			fromLabel.tag = fromLabelTag;
			[cell.contentView addSubview:fromLabel];
			[fromLabel release];
			
		}else {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:OutboxCell] autorelease];
			
			frame.origin.x = 75;
			frame.origin.y = 20;
			frame.size.height = 70;
			frame.size.width = 240;
			UIImageView *bubbleImageOutbox = [[UIImageView alloc] initWithFrame:frame];
			bubbleImageOutbox.tag = bubbleImageOutboxTag;
			bubbleImageOutbox.image = [UIImage imageNamed:@"messageBubbleGreen.png"];
			[cell.contentView addSubview:bubbleImageOutbox];
			[bubbleImageOutbox release];
			
			frame.origin.x = 280;
			frame.origin.y = 92;
			frame.size.width = 160;
			frame.size.height = 20;
			UILabel *fromMeLabel = [[UILabel alloc] initWithFrame:frame];
			fromMeLabel.tag = fromMeLabelTag;
			[cell.contentView addSubview:fromMeLabel];
			[fromMeLabel release];
			
		}
		
		
		
		
		frame.origin.x = 10;
		frame.origin.y = 20;
		frame.size.height = 60;
		frame.size.width = 220;
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
		textLabel.tag = textTag;
		[cell.contentView addSubview:textLabel];
		[textLabel release];
		
		
		
		
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 20;
		frame.size.width = 320;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		
		
	}
	UILabel *fromLabel = (UILabel *)[cell.contentView viewWithTag:fromLabelTag];
	fromLabel.textColor = [UIColor blueColor];
	fromLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	UILabel *fromMeLabel = (UILabel *)[cell.contentView viewWithTag:fromMeLabelTag];
	fromMeLabel.textColor = [UIColor blueColor];
	fromMeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	
	fromMeLabel.text = @"Me";
	
	UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:textTag];
	textLabel.numberOfLines = 2;
	textLabel.lineBreakMode = UILineBreakModeTailTruncation;
	textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	textLabel.textColor = [UIColor blackColor];
	textLabel.backgroundColor = [UIColor clearColor];
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	dateLabel.textAlignment = UITextAlignmentCenter;
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.textColor = [UIColor grayColor];
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	
	NSString *date = message.messageDate;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	NSDate *formatedDate = [dateFormat dateFromString:date];
	[dateFormat setDateFormat:@"MMM dd, hh:mm aa"];
	NSString *displayDate = [dateFormat stringFromDate:formatedDate];
	
	dateLabel.text = displayDate;
	[dateFormat release];
	
	fromLabel.text = message.senderName;
	
	textLabel.text = message.body;
	if (isInbox) {
		UIImageView *inboxBubble = (UIImageView *)[cell.contentView viewWithTag:bubbleImageInboxTag];
		inboxBubble.hidden = NO;
		textLabel.frame = CGRectMake(15, 20, 220, 60);
		
	}else {
		UIImageView *outboxBubble = (UIImageView *)[cell.contentView viewWithTag:bubbleImageOutboxTag];
		outboxBubble.hidden = NO;
		textLabel.frame = CGRectMake(90, 20, 220, 60);
		
	}
	
	
	[cell.contentView bringSubviewToFront:textLabel];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
	
	
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    return 110;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	GameMessageObject *tmpMsg = [self.allMessages objectAtIndex:row];
	
	ViewPracticeChatterMessage *next = [[ViewPracticeChatterMessage alloc] init];
	
	next.senderName = tmpMsg.senderName;
	next.messageBody = tmpMsg.body;
	next.messageDate = tmpMsg.messageDate;
	
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = temp;
    
	[self.navigationController pushViewController:next animated:YES];
	
	
	
}

//Table View Data Source Methods:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	
	return [self.allMessages count];
	
}


-(void)textDidStart{
	
	self.sendMessageButton.hidden = NO;
	
	if (self.hideTab) {
		self.myTableView.frame = CGRectMake(0, 91, 320, 261);
		
	}else {
		self.myTableView.frame = CGRectMake(0, 91, 320, 217);
	}
	
}

-(void)textDidEnd{
	
	self.sendMessageButton.hidden = YES;
	self.errorLabel.hidden = YES;
	
	if (self.hideTab) {
		self.myTableView.frame = CGRectMake(0, 50, 320, 302);
		
		
	}else {
		self.myTableView.frame = CGRectMake(0, 50, 320, 258);
		
	}
	
}

-(void)endText{
	
	if (self.tabBarController != nil) {
		[self.tabBarController becomeFirstResponder];
	}else {
		[self becomeFirstResponder];
	}
	
}


-(void)createMessage{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	if (![token isEqualToString:@""]){	
		
		
		NSDictionary *response = [ServerAPI createMessageThread:token :self.teamId :@"Practice Message" :self.messageField.text :@"plain" :self.practiceId :@"practice" :@"false" :[NSArray array] :[NSArray array] :@"" :@"false" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.errorString = @"";
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
				case 207:
					//error connecting to server
					self.errorString = @"*Fans cannot send messages.";
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
	 @selector(doneMessage)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
	
}

-(void)doneMessage{
	
	self.sendMessageButton.enabled = YES;
	self.messageField.enabled = YES;
	[self.messageActivity stopAnimating];
	
	if ([self.errorString isEqualToString:@""]) {
		//success
		self.messageField.text = @"";
		[self.messageActivity startAnimating];
		self.tmpAllMessages = [NSMutableArray array];
		[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
	}else {
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send messages.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            [alert release];
		}else {
			self.errorLabel.text = self.errorString;
			self.errorLabel.hidden = NO;
			self.errorLabel.textColor = [UIColor redColor];
		}
		
	}
	
	
}

-(void)updateWasViewed:(NSString *)threadId {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI updateMessageThread:token :self.teamId :threadId :@"" :@"true" :@"" :@""];
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

- (void)viewDidUnload {
	/*
	results = nil;
	teamName = nil;
	teamId = nil;
	inboxResults = nil;
	outboxResults = nil;
	userRole = nil;
	error = nil;
	sendMessageButton = nil;
	myTableView = nil;
	pseudoSelectedArrayZero = nil;
	pseudoSelectedArrayOne = nil;
	editDone = nil;
	threadIdsToArchiveInbox = nil;
	threadIdsToArchiveOutbox = nil;
	messagesOnlyArray = nil;
	pollsOnlyArray = nil;
	messagesSentArray = nil;
	pollsSentArray = nil;
	barActivity = nil;
	messageActivity = nil;
	messageActivityLabel = nil;
	practiceId = nil;
	messageField = nil;
	errorLabel = nil;
	noMessagesLabel = nil;
	*/
	
	sendMessageButton = nil;
	myTableView = nil;
	barActivity = nil;
	messageActivity = nil;
	messageActivityLabel = nil;	
	messageField = nil;
	errorLabel = nil;
	noMessagesLabel = nil;
	infoText = nil;
	
	[super viewDidUnload];
}


- (void)dealloc {
	[infoText release];
	[results release];
	[teamName release];
	[teamId release];
	[inboxResults release];
	[outboxResults release];
	[userRole release];
	[error release];
	[sendMessageButton release];
	[myTableView release];
	[pseudoSelectedArrayZero release];
	[pseudoSelectedArrayOne release];
	[editDone release];
	[threadIdsToArchiveInbox release];
	[threadIdsToArchiveOutbox release];
	[messagesOnlyArray release];
	[pollsOnlyArray release];
	[messagesSentArray release];
	[pollsSentArray release];
	[barActivity release];
	[messageActivity release];
	[messageActivityLabel release];
	[practiceId release];
	[allMessages release];
	[startDate release];
	[messageField release];
	[errorLabel release];
	[errorString release];
	[noMessagesLabel release];
	[tmpAllMessages release];
	[myTimer release];
	[super dealloc];
	
}

@end