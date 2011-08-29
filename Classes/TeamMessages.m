//
//  TeamMessages.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamMessages.h"
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
#import "GameChatter.h"
#import "PracticeChatter.h"
#import "GameChatter.h"
#import "PracticeChatter.h"

@implementation TeamMessages
@synthesize results, teamName, teamId, inboxResults, outboxResults, userRole, noInbox, noOutbox, error, sendPollButton, sendMessageButton,
inPseudoEditMode, pseudoSelectedArrayZero, pseudoSelectedArrayOne, deleteSuccess, threadIdsToArchiveInbox, deleteButton,
threadIdsToArchiveOutbox, deleteActivity, messagesOnlyArray, pollsOnlyArray, messagesSentArray, pollsSentArray, myTableView, barActivity,
messageActivity, messageActivityLabel, messageDeleteView, doneInbox, doneOutbox;


-(void)viewWillDisappear:(BOOL)animated{
	
	//self.tabBarController.navigationItem.leftBarButtonItem = nil;
}


-(void)viewDidLoad{
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	self.myTableView.hidden = YES;
	
	[self.messageActivity startAnimating];
	self.messageActivityLabel.hidden = NO;
	


	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.messageDeleteView.bounds;
	UIColor *color1 =  [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1];
	UIColor *color2 = [UIColor colorWithRed:0.69 green:0.769 blue:0.871 alpha:1.0];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.messageDeleteView.layer insertSublayer:gradient atIndex:0];
	
	
	self.messageDeleteView.hidden = YES;
	
}


-(void)viewWillAppear:(BOOL)animated{
	
	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];
	[self.messageActivity startAnimating];
	[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];


	self.doneInbox = false;
	self.doneOutbox = false;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendMessageButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.sendPollButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	[self.deleteButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
		
}


-(void)getAllMessages{
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	self.inboxResults = [NSMutableArray array];
	self.outboxResults = [NSMutableArray array];
	NSString *token = @"";
	NSMutableArray *resultsArray = [NSMutableArray array];
	
	self.messagesOnlyArray = [NSMutableArray array];
	self.pollsOnlyArray = [NSMutableArray array];
	self.messagesSentArray = [NSMutableArray array];
	self.pollsSentArray = [NSMutableArray array];
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreads:token :self.teamId :@"all" :@"" :@"" :@"both" :@"active"];
		
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
		
		if ([[self.results objectAtIndex:i] class] == [MessageThreadInbox class]) {
			//its an inbox message
			
			[self.inboxResults addObject:[self.results objectAtIndex:i]];
		}else {
			//its an outbox message
			[self.outboxResults addObject:[self.results objectAtIndex:i]];
		}
		
	}
	
	NSSortDescriptor *inboxSort = [[NSSortDescriptor alloc] initWithKey:@"receivedDate" ascending:NO];
	[self.inboxResults sortUsingDescriptors:[NSArray arrayWithObject:inboxSort]];
	[inboxSort release];
    
	NSSortDescriptor *outboxSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
	[self.outboxResults sortUsingDescriptors:[NSArray arrayWithObject:outboxSort]];
	[outboxSort release];
    
	self.pseudoSelectedArrayZero = [NSMutableArray array];
	self.pseudoSelectedArrayOne = [NSMutableArray array];
	
	for (int i = 0; i < [self.inboxResults count]; i++) {
		[self.pseudoSelectedArrayZero addObject:@"0"];
		
		//Fill the messages and polls arrays
		MessageThreadInbox *tmp = [self.inboxResults objectAtIndex:i];
		if ([tmp.pollChoices count] > 0) {
			//Its a poll
			[self.pollsOnlyArray addObject:tmp];
		}else {
			
			if (!tmp.threadingUsed) {
				[self.messagesOnlyArray addObject:tmp];
			}
		}
		
	}
	
		
	for (int i = 0; i < [self.outboxResults count]; i++) {
		[self.pseudoSelectedArrayOne addObject:@"0"];
		
		//Fill the messages and polls arrays
		MessageThreadOutbox *tmp = [self.outboxResults objectAtIndex:i];
		if ([tmp.messageType isEqualToString:@"poll"]) {
			//Its a poll
			[self.pollsSentArray addObject:tmp];
		}else {
			
			if (!tmp.threadingUsed) {
				[self.messagesSentArray addObject:tmp];
			}
		}
		
		
	}

	
	[pool drain];
	[self performSelectorOnMainThread:@selector(finishedMessages) withObject:nil waitUntilDone:NO];
}


-(void)finishedMessages{
	
	[self.barActivity stopAnimating];
	[self.messageActivity stopAnimating];
	self.messageActivityLabel.hidden = YES;
	self.myTableView.hidden = NO;
	[self.myTableView reloadData];
	
	
}

-(void)sendMessage{
	
	SendMessage *nextController = [[SendMessage alloc] init];
	nextController.teamId = self.teamId;
	nextController.origLoc = @"CurrentTeamTabs";
	nextController.userRole = self.userRole;
	[self.navigationController pushViewController:nextController animated:YES];
}

-(void)sendPoll{
	
	SelectRecipients *tmp = [[SelectRecipients alloc] init];
	tmp.teamId = self.teamId;
	tmp.fromWhere = @"CurrentTeamTabs";
	tmp.messageOrPoll = @"poll";
    tmp.userRole = self.userRole;
	[self.navigationController pushViewController:tmp animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	static NSInteger subjTag = 1;
	static NSInteger bodTag = 2;
	static NSInteger dateTag = 3;
	static NSInteger pollMessageTag = 4;
	static NSInteger imageTag = 5;
	static NSInteger replyTag = 6;
	static NSInteger pseudoTag = 7;
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	BOOL wasViewed = YES;
	
	if (!self.noInbox) {
		
		if (section == 0) {
			MessageThreadInbox *inboxMessage = [self.inboxResults objectAtIndex:row];
			wasViewed = inboxMessage.wasViewed;
		}
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];	
	
	if (cell == nil){
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		
		CGRect frame;
		
		
		frame.origin.x = 10;
		
		
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 227;
		UILabel *subjectLabel = [[UILabel alloc] initWithFrame:frame];
		subjectLabel.tag = subjTag;
		[cell.contentView addSubview:subjectLabel];
		[subjectLabel release];
		
		frame.size.height = 17;
		frame.origin.y = 28;
		frame.size.width = 280;
		UILabel *bodyLabel = [[UILabel alloc] initWithFrame:frame];
		bodyLabel.tag = bodTag;
		[cell.contentView addSubview:bodyLabel];
		[bodyLabel release];
		
		frame.size.height = 15;
		frame.origin.y = 46;
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		frame.origin.y = 62;
		frame.size.height = 15;
		frame.size.width = 200;
		UILabel *replyLabel = [[UILabel alloc] initWithFrame:frame];
		replyLabel.tag = replyTag;
		[cell.contentView addSubview:replyLabel];
		[replyLabel release];
		
		frame.origin.x = 240;
		frame.origin.y = 5;
		frame.size.height = 15;
		frame.size.width = 60;
		UILabel *pollMessageLabel = [[UILabel alloc] initWithFrame:frame];
		pollMessageLabel.tag = pollMessageTag;
		[cell.contentView addSubview:pollMessageLabel];
		[pollMessageLabel release];
		
		
			
		CGRect myImageRect = CGRectMake(28.0f, 28.0f, 15.0f, 11.0f);
		UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
		[myImage setImage:[UIImage imageNamed:@"blueDot1.png"]];
		myImage.opaque = YES; // explicitly opaque for performance
		myImage.tag = imageTag;
		[cell.contentView addSubview:myImage];
		[myImage release];
		
		
		CGRect rect = CGRectMake(4.0f, 25.0f, 20.0f, 20.0f);
		UIImageView *pseudoImage = [[UIImageView alloc] initWithFrame:rect];
		pseudoImage.tag = pseudoTag;
		[pseudoImage setImage:[UIImage imageNamed:@"pseudoNotSelected.png"]];
		pseudoImage.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:pseudoImage];
		[pseudoImage release];
		
		
		
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	UILabel *subjLabel = (UILabel *)[cell.contentView viewWithTag:subjTag];
	UILabel *bodyLabel = (UILabel *)[cell.contentView viewWithTag:bodTag];
	UILabel *pollMessageLabel = (UILabel *)[cell.contentView viewWithTag:pollMessageTag];
	//UIImageView *blueDotImage = (UIImageView *)[cell.contentView viewWithTag:blueDotImgTag];
	UILabel *replyLabel = (UILabel *)[cell.contentView viewWithTag:replyTag];
	
	UIImageView *pseudoImage = (UIImageView *)[cell.contentView viewWithTag:pseudoTag];
	UIImageView *myImage = (UIImageView *)[cell.contentView viewWithTag:imageTag];
	
	dateLabel.backgroundColor = [UIColor clearColor];
	subjLabel.backgroundColor = [UIColor clearColor];
	bodyLabel.backgroundColor = [UIColor clearColor];
	pollMessageLabel.backgroundColor = [UIColor clearColor];
	replyLabel.backgroundColor = [UIColor clearColor];
	pseudoImage.backgroundColor = [UIColor clearColor];
	myImage.backgroundColor = [UIColor clearColor];
	
	DeleteSelectButton *selectRowButton = [DeleteSelectButton buttonWithType:UIButtonTypeCustom];
	selectRowButton.sRow = row;
	selectRowButton.sSec = section;
	selectRowButton.frame = CGRectMake(0, 0, 45, 67);
	[selectRowButton addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
	[selectRowButton retain];
	//selectRowButton.backgroundColor = [UIColor redColor];
	[cell.contentView addSubview:selectRowButton];
	[cell.contentView bringSubviewToFront:selectRowButton];
	[selectRowButton release];
    
	bool isSelected = false;
	
	if (!wasViewed) {
		
		if (section == 0) {
			
			if (!self.noInbox) {

			if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"0"]) {
				pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
			}else {
				pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
				isSelected = true;
				
			}
			}
		}else {
			
			if (!self.noOutbox) {

			if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"0"]) {
				pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
			}else {
				pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
				isSelected = true;
				
			}
			}
		}

		
		
		dateLabel.frame = CGRectMake(45, 46, 275, 15);
		subjLabel.frame = CGRectMake(45, 5, 183, 22);
		bodyLabel.frame = CGRectMake(45, 28, 255, 17);
		replyLabel.frame = CGRectMake(45, 62, 200, 15);
		[pseudoImage setHidden:NO];
		[myImage setHidden:NO];
		
	}else {
		if (section == 0) {
			
			if (!self.noInbox) {

			if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"0"]) {
				pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
			}else {
				pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
				isSelected = true;
				
			}
			}
		}else {
			
			if (!self.noOutbox) {

			if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"0"]) {
				pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
			}else {
				pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
				isSelected = true;
				
			}
			}
		}
		
		dateLabel.frame = CGRectMake(45, 46, 275, 15);
		subjLabel.frame = CGRectMake(45, 5, 183, 22);
		bodyLabel.frame = CGRectMake(45, 28, 255, 17);
		replyLabel.frame = CGRectMake(45, 62, 200, 15);

		[pseudoImage setHidden:NO];
		[myImage setHidden:YES];
	}
	
	
	if (isSelected) {
	//	UIColor *tmpColor = [UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0];
		UIColor *tmpColor = [UIColor colorWithRed:0.88 green:0.93 blue:0.98 alpha:1.0];

		cell.contentView.backgroundColor = tmpColor;
		cell.accessoryView.backgroundColor = tmpColor;
		
		cell.backgroundView = [[[UIView alloc] init] autorelease]; 
		cell.backgroundView.backgroundColor = tmpColor;
	}else {
		cell.contentView.backgroundColor = [UIColor whiteColor];
		cell.accessoryView.backgroundColor = [UIColor whiteColor];
		cell.backgroundView = [[[UIView alloc] init] autorelease]; 
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	
	replyLabel.textColor = [UIColor blueColor];
	replyLabel.font = [UIFont fontWithName:@"Helvetica" size:15];

	
	pollMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	pollMessageLabel.textColor = [UIColor blueColor];
	subjLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	bodyLabel.textColor = [UIColor grayColor];
	bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	
	//Configure the cell
	
	
    bodyLabel.textAlignment = UITextAlignmentLeft;

	if (section == 0) {
		
		if (self.noInbox) {
			bodyLabel.text = @"No messages in team inbox...";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;

			[pseudoImage setHidden:YES];
			[subjLabel setHidden:YES];
			[dateLabel setHidden:YES];
			[pollMessageLabel setHidden:YES];

			[replyLabel setHidden:YES];
			bodyLabel.frame = CGRectMake(10, 28, 280, 17);
            bodyLabel.textAlignment = UITextAlignmentCenter;

		}else{
            bodyLabel.textAlignment = UITextAlignmentLeft;

		[pollMessageLabel setHidden:NO];

		[subjLabel setHidden:NO];
		[dateLabel setHidden:NO];
		[replyLabel setHidden:YES];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		MessageThreadInbox *inboxMessage = [self.inboxResults objectAtIndex:row];
		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = inboxMessage.receivedDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, hh:mm aa"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		
		
		dateLabel.text = startDateString;
		
		[dateFormat release];
		[format release];
		//retrieve the opponent
		
		subjLabel.text = inboxMessage.subject;
		bodyLabel.text = inboxMessage.body;
		
		if ([inboxMessage.pollChoices count] > 0 ) {
			pollMessageLabel.text = @"Poll";
		}else {
			pollMessageLabel.text = @"Message";
		}
			
		}
		
	}else{
		if (self.noOutbox) {
			bodyLabel.text = @"No messages in team outbox...";
			[pseudoImage setHidden:YES];
			[subjLabel setHidden:YES];
			[dateLabel setHidden:YES];
			[replyLabel setHidden:YES];
			[pollMessageLabel setHidden:YES];
			bodyLabel.frame = CGRectMake(10, 28, 280, 17);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
            bodyLabel.textAlignment = UITextAlignmentCenter;

		}else{
            bodyLabel.textAlignment = UITextAlignmentLeft;
			[pollMessageLabel setHidden:NO];

			[subjLabel setHidden:NO];
			[dateLabel setHidden:NO];
			[replyLabel setHidden:NO];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		MessageThreadOutbox *theMessage = [self.outboxResults objectAtIndex:row];
		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theMessage.createdDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, hh:mm aa"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		
		
		dateLabel.text = startDateString;
		
		[dateFormat release];
		[format release];
		//retrieve the opponent
		
		subjLabel.text = theMessage.subject;
		bodyLabel.text = theMessage.body;
		
		if ([theMessage.messageType isEqualToString:@"poll"]) {
			pollMessageLabel.text = @"Poll";
		
		}else {
			pollMessageLabel.text = @"Message";
		}
			
			
		NSString *recipients = theMessage.numRecipients;
		NSString *replies = theMessage.numReplies;
			
			
				if (recipients == nil) {
					recipients = @"0";
				}
				if (replies == nil) {
					replies = @"0";
				}
				
				NSString *replyString = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
				
				if ([recipients isEqualToString:@"0"] && [replies isEqualToString:@"0"]) {
					[replyLabel setHidden:YES];
				}else {
					replyLabel.text = replyString;
					[replyLabel setHidden:NO];
				}
			
			
			if ([theMessage.messageType isEqualToString:@"plain"]) {
				[replyLabel setHidden:YES];
			}
			
			

			

		}
	}
	
	if (self.inPseudoEditMode) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}else {
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	return cell;
	
	
}

-(void)selectRow:(id)sender{
	
	DeleteSelectButton *tmp = (DeleteSelectButton *)sender;
	int row = tmp.sRow;
	int section = tmp.sSec;
	
	if (section == 0) {
		
		if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"0"]) {
			[self.pseudoSelectedArrayZero replaceObjectAtIndex:row withObject:@"1"];
		}else if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"1"]) {
			[self.pseudoSelectedArrayZero replaceObjectAtIndex:row withObject:@"0"];
		}
		
		[self.myTableView reloadData];
		
	}else {
		if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"0"]) {
			[self.pseudoSelectedArrayOne replaceObjectAtIndex:row withObject:@"1"];
		}else if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"1"]) {
			[self.pseudoSelectedArrayOne replaceObjectAtIndex:row withObject:@"0"];
		}
		
		[self.myTableView reloadData];
	}

	

	
	bool noneSelected = true;
	for (int i = 0; i < [self.pseudoSelectedArrayZero count]; i++) {
		
		NSString *tmp = [self.pseudoSelectedArrayZero objectAtIndex:i];
		if ([tmp isEqualToString:@"1"]) {
			noneSelected = false;
		}
	}
	for (int i = 0; i < [self.pseudoSelectedArrayOne count]; i++) {
		
		NSString *tmp = [self.pseudoSelectedArrayOne objectAtIndex:i];
		if ([tmp isEqualToString:@"1"]) {
			noneSelected = false;
		}
	}
	
	if (noneSelected) {
		self.messageDeleteView.hidden = YES;
	}else {
		self.messageDeleteView.hidden = NO;
	}
	
	
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    if ([indexPath section] == 0) {
		return 70;
	}else {
		return 80;
	}
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	if (!self.inPseudoEditMode) {
		
		if (section == 0 && ([self.inboxResults count] > 0)) {
			MessageThreadInbox *messageOrPoll = [self.inboxResults objectAtIndex:row];
			
			if ([messageOrPoll.pollChoices count] > 0) {
				ViewPollReceived *poll = [[ViewPollReceived alloc] init];
			
				poll.teamId = self.teamId;
				poll.origTeamId = [self.teamId copy];
				poll.threadId = messageOrPoll.threadId;
				poll.pollChoices = messageOrPoll.pollChoices;
				poll.from = messageOrPoll.senderName;
				poll.subject = messageOrPoll.subject;
				poll.body = messageOrPoll.body;
				poll.receivedDate = messageOrPoll.receivedDate;
				poll.wasViewed = messageOrPoll.wasViewed;
				poll.status = messageOrPoll.status;
				poll.teamName = self.teamName;
				
				//For cycling through polls
				poll.pollArray = self.pollsOnlyArray;
								
				for (int i = 0; i < [self.pollsOnlyArray count]; i++) {
					
					MessageThreadInbox *tmp = [self.pollsOnlyArray objectAtIndex:i];
					
					if ([tmp.threadId isEqualToString:messageOrPoll.threadId]) {
						poll.currentPollNumber = i;
					}
				}
				
				
				[self.navigationController pushViewController:poll animated:YES];
			}else {
				
				if (messageOrPoll.threadingUsed) {
					
					if ([messageOrPoll.eventType isEqualToString:@"game"]) {
						GameChatter *tmp = [[GameChatter alloc] init];
						tmp.gameId = messageOrPoll.eventId;
						tmp.teamId = self.teamId;
						tmp.startDate = messageOrPoll.eventDate;

						tmp.title = @"Game Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}else {
						
						PracticeChatter *tmp = [[PracticeChatter alloc] init];
						tmp.practiceId = messageOrPoll.eventId;
						tmp.teamId = self.teamId;
						tmp.startDate = messageOrPoll.eventDate;

						tmp.title = @"Practice Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}
					
					
					
				}else{
					ViewMessageReceived *message = [[ViewMessageReceived alloc] init];
					
					message.teamId = self.teamId;
					message.origTeamId = [self.teamId copy];
					//message.from = messageOrPoll.sender
					message.subject = messageOrPoll.subject;
					message.body = messageOrPoll.body;
					message.receivedDate = messageOrPoll.receivedDate;
					message.wasViewed = messageOrPoll.wasViewed;
					message.threadId = messageOrPoll.threadId;
					message.senderId = messageOrPoll.senderId;
					message.senderName = messageOrPoll.senderName;
                                        
                    message.userRole = self.userRole;
					
					
					//For cycling through messages
					message.messageArray = self.messagesOnlyArray;
					
					for (int i = 0; i < [self.messagesOnlyArray count]; i++) {
						
						MessageThreadInbox *tmp = [self.messagesOnlyArray objectAtIndex:i];
						
						if ([tmp.threadId isEqualToString:messageOrPoll.threadId]) {
							message.currentMessageNumber = i;
						}
					}
					
					
					[self.navigationController pushViewController:message animated:YES];
					
				}
				
							}
		}else if ((section == 1) && ([self.outboxResults count] > 0)) {
		
			MessageThreadOutbox *messageOrPoll = [self.outboxResults objectAtIndex:row];
		
			if ([messageOrPoll.messageType isEqualToString:@"poll"]) {			
				
				
				ViewPollSent *tmp = [[ViewPollSent alloc] init];
				tmp.teamId = self.teamId;
				tmp.origTeamId = [self.teamId copy];
				tmp.messageThreadId = messageOrPoll.threadId;
				NSString *recipients = messageOrPoll.numRecipients;
				NSString *replies = messageOrPoll.numReplies;
				tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
				
				tmp.pollArray = self.pollsSentArray;
				
			
				for (int i = 0; i < [self.pollsSentArray count]; i++) {
					
					MessageThreadOutbox *tmp1 = [self.pollsSentArray objectAtIndex:i];
					
					if ([tmp1.threadId isEqualToString:messageOrPoll.threadId]) {
						tmp.currentPollNumber = i;
					}
				}
				
				[self.navigationController pushViewController:tmp animated:YES];
			
			}else {
				
				if (messageOrPoll.threadingUsed) {
					
					if ([messageOrPoll.eventType isEqualToString:@"game"]) {
						GameChatter *tmp = [[GameChatter alloc] init];
						tmp.gameId = messageOrPoll.eventId;
						tmp.teamId = self.teamId;
						tmp.startDate = messageOrPoll.eventDate;

						tmp.title = @"Game Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}else {
						
						PracticeChatter *tmp = [[PracticeChatter alloc] init];
						tmp.practiceId = messageOrPoll.eventId;
						tmp.teamId = self.teamId;
						tmp.startDate = messageOrPoll.eventDate;

						tmp.title = @"Practice Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}
					
					
					
				}else {
					ViewMessageSent *message = [[ViewMessageSent alloc] init];
					
					message.teamId = self.teamId;
					message.origTeamId = [self.teamId copy];
					//message.from = messageOrPoll.
					message.subject = messageOrPoll.subject;
					message.body = messageOrPoll.body;
					message.createdDate	= messageOrPoll.createdDate;
					message.threadId = messageOrPoll.threadId;
					
					message.messageArray = self.messagesSentArray;
					
					for (int i = 0; i < [self.messagesSentArray count]; i++) {
						
						MessageThreadOutbox *tmp = [self.messagesSentArray objectAtIndex:i];
						
						if ([tmp.threadId isEqualToString:messageOrPoll.threadId]) {
							message.currentMessageNumber = i;
						}
					}
					
					
					[self.navigationController pushViewController:message animated:YES];
				}

				
			}
		}
	}


	
}

//Table View Data Source Methods:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (section == 0) {
		if ([self.inboxResults count] == 0) {
			self.noInbox = true;
			return 1;
		}else {
			self.noInbox = false;
		}

		return [self.inboxResults count];
	}else {
		if ([self.outboxResults count] == 0) {
			self.noOutbox = true;
			return 1;
		}else {
			self.noOutbox = false;
		}
		return [self.outboxResults count];
	}
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

	if (section == 0) {
		return @"Inbox";
	}else {
		return @"Outbox";
	}

}

-(void)deleteMessages{
	//Delete all message threads that are selected.
	
	self.threadIdsToArchiveInbox = [NSMutableArray array];
	self.threadIdsToArchiveOutbox = [NSMutableArray array];
	
	for (int i = 0; i < [self.inboxResults count]; i++) {
		
		if ([[self.pseudoSelectedArrayZero objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadInbox *tmp = [self.inboxResults objectAtIndex:i];
			
			if (tmp.threadingUsed) {
				
				for (int i = 0; i < [tmp.subThreadIds count]; i++) {
					
					[threadIdsToArchiveInbox addObject:[tmp.subThreadIds objectAtIndex:i]];
				}
			}else {
				[threadIdsToArchiveInbox addObject:tmp.threadId];
				
			}

			
		}
	}
	for (int i = 0; i < [self.outboxResults count]; i++) {
		
		if ([[self.pseudoSelectedArrayOne objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadInbox *tmp = [self.outboxResults objectAtIndex:i];
			
			if (tmp.threadingUsed) {
				
				for (int i = 0; i < [tmp.subThreadIds count]; i++) {
					
					[threadIdsToArchiveOutbox addObject:[tmp.subThreadIds objectAtIndex:i]];
				}
			}else {
				[threadIdsToArchiveOutbox addObject:tmp.threadId];
				
			}

			
		}
	}
	
	if ([threadIdsToArchiveInbox count] > 0) {
		//Server hit to delete the threads
		[self.tabBarController.navigationItem setHidesBackButton:YES];
		[self.deleteActivity startAnimating];
		
		[self performSelectorInBackground:@selector(runRequestInbox) withObject:nil];
	}else {
		self.doneInbox = true;
	}

	if ([threadIdsToArchiveOutbox count] > 0) {
		//Server hit to delete the threads
		[self.tabBarController.navigationItem setHidesBackButton:YES];

		[self.deleteActivity startAnimating];
		
		[self performSelectorInBackground:@selector(runRequestOutbox) withObject:nil];
	}else {
		self.doneOutbox = true;
	}

	
	
	
}

- (void)runRequestInbox {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSDictionary *response = [ServerAPI updateMessageThreads:mainDelegate.token :self.threadIdsToArchiveInbox :@"inbox"];
	
	
	NSString *status = [response valueForKey:@"status"];
	
	
	if ([status isEqualToString:@"100"]){
		
		self.deleteSuccess = true;
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		self.deleteSuccess = false;
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
				//should never get here
				self.error = @"*Error connecting to server";
				break;
		}
	}
	self.doneInbox = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)runRequestOutbox {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSDictionary *response = [ServerAPI updateMessageThreads:mainDelegate.token :self.threadIdsToArchiveOutbox :@"outbox"];
	
	
	NSString *status = [response valueForKey:@"status"];
	
	if ([status isEqualToString:@"100"]){
		
		self.deleteSuccess = true;
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		self.deleteSuccess = false;
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
				//should never get here
				self.error = @"*Error connecting to server";
				break;
		}
	}
	
	self.doneOutbox = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

-(void)didFinish{

	if (self.doneInbox && self.doneOutbox) {
		[self.tabBarController.navigationItem setHidesBackButton:NO];
		[self.deleteActivity stopAnimating];
		self.messageDeleteView.hidden = YES;
		
		[self.messageActivity startAnimating];
		[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
	}
	
}



-(void)cancelDelete{
	
	self.messageDeleteView.hidden = YES;
	
	for (int i = 0; i < [self.pseudoSelectedArrayZero count]; i++) {
		
		[self.pseudoSelectedArrayZero replaceObjectAtIndex:i withObject:@"0"];
	}
	
	for (int i = 0; i < [self.pseudoSelectedArrayOne count]; i++) {
		
		[self.pseudoSelectedArrayOne replaceObjectAtIndex:i withObject:@"0"];
	}
	
	[self.myTableView reloadData];
}

- (void)viewDidUnload {

	sendPollButton = nil;
	sendMessageButton = nil;
	myTableView = nil;
	deleteButton = nil;
	deleteActivity = nil;
    barActivity = nil;
	messageActivity = nil;
	messageActivityLabel = nil;
	[super viewDidUnload];


	
	

	
}


- (void)dealloc {
	[results release];
	[teamName release];
	[teamId release];
	[inboxResults release];
	[outboxResults release];
	[userRole release];
	[error release];
	[sendPollButton release];
	[sendMessageButton release];
	[myTableView release];
	[deleteButton release];
	[pseudoSelectedArrayZero release];
	[pseudoSelectedArrayOne release];
	[threadIdsToArchiveInbox release];
	[threadIdsToArchiveOutbox release];
	[deleteActivity release];
	[messagesOnlyArray release];
	[pollsOnlyArray release];
	[messagesSentArray release];
	[pollsSentArray release];
	[barActivity release];
	[messageActivity release];
	[messageActivityLabel release];
	[super dealloc];

}

@end
