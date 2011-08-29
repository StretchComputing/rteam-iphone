//
//  EventMessages.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventMessages.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SendMessage.h"
#import "SendPoll.h"
#import "MessageThreadOutbox.h"
#import "MessageThreadInbox.h"
#import "ViewPollSent.h"
#import "ViewPollReceived.h"
#import "ViewMessageSent.h"
#import "ViewMessageReceived.h"
#import "SelectRecipients.h"

@implementation EventMessages
@synthesize results, teamName, teamId, eventId, inboxResults, outboxResults, noInbox, noOutbox, error, userRole, 
sendPollButton, sendMessageButton, inPseudoEditMode, pseudoSelectedArrayZero, pseudoSelectedArrayOne, editDone, deleteSuccess, 
threadIdsToArchiveInbox, threadIdsToArchiveOutbox, deleteButton, deleteActivity, messagesOnlyArray, pollsOnlyArray;



-(void)viewWillAppear:(BOOL)animated{
	self.editDone = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.tabBarController.navigationItem setRightBarButtonItem:self.editDone];
	
	[self getAllMessages];
	
	//Header to be displayed if there are no players
	UIView *headerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 50)]
	 autorelease];
	
	self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.sendMessageButton.frame = CGRectMake(10, 10, 130, 30);
	[self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
	[self.sendMessageButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[self.sendMessageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	self.sendMessageButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.sendMessageButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[headerView addSubview:self.sendMessageButton];
	
	self.sendPollButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.sendPollButton.frame = CGRectMake(170, 10, 130, 30);
	[self.sendPollButton setTitle:@"Send Poll" forState:UIControlStateNormal];
	[self.sendPollButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[self.sendPollButton addTarget:self action:@selector(sendPoll) forControlEvents:UIControlEventTouchUpInside];
	self.sendPollButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.sendPollButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[headerView addSubview:self.sendPollButton];
	
	self.deleteActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.deleteActivity.frame = CGRectMake(160, 15, 20,20);
	self.deleteActivity.hidesWhenStopped = YES;
	[headerView addSubview:self.deleteActivity];
	
	self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.deleteButton.frame = CGRectMake(95, 10, 130, 30);
	[self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[self.deleteButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[self.deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
	self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.deleteButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[headerView addSubview:self.deleteButton];
	[self.deleteButton setHidden:YES];
	
	
	UILabel *desc =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(0, 5, 320, 60)]
	 autorelease];
	desc.text = NSLocalizedString(@"All polls or messages that relate to this practice:", @"");
	desc.textColor = [UIColor blackColor];
	desc.numberOfLines = 3;
	desc.font = [UIFont boldSystemFontOfSize:14];
	desc.backgroundColor = [UIColor clearColor];
	desc.textAlignment = UITextAlignmentCenter;
	
	//[headerView addSubview:desc];
	
	UIView *footerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 75)]
	 autorelease];
	
	UILabel *att =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(70, 10, 200, 40)]
	 autorelease];
	att.text = NSLocalizedString(@"Results To Display:", @"");
	att.textColor = [UIColor blackColor];
	att.font = [UIFont boldSystemFontOfSize:16];
	att.backgroundColor = [UIColor clearColor];
	
	
	NSArray *segments = [NSArray arrayWithObjects:@"Polls", @"Messages", @"Both", nil];
	
	UISegmentedControl *show = [[UISegmentedControl alloc] initWithItems:segments];
	show.frame = CGRectMake(5, 50, 310, 30);
	//[show addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	[footerView addSubview:att];
	[footerView addSubview:show];
	
    [show release];
    
	footerView.backgroundColor = [UIColor whiteColor];
	headerView.backgroundColor = [UIColor whiteColor];
	
	self.tableView.tableHeaderView = headerView;
	//self.tableView.tableFooterView = footerView;
}


-(void)getAllMessages{
	
	self.inboxResults = [NSMutableArray array];
	self.outboxResults = [NSMutableArray array];
	NSString *token = @"";
	NSMutableArray *resultsArray = [NSMutableArray array];
	NSDictionary *response = [NSDictionary dictionary];
	
	self.messagesOnlyArray = [NSMutableArray array];
	self.pollsOnlyArray = [NSMutableArray array];
	//Get the TeamID from the controller right below on the stack
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 1;
	
	//Team *tempTeam = [temp objectAtIndex:num];
	//self.teamId = tempTeam.teamId;
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		response = [ServerAPI getMessageThreads:token :self.teamId :@"all" :self.eventId :@"practice" :@"both" :@"active"];
		
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
			[self.messagesOnlyArray addObject:tmp];
		}
	}
	for (int i = 0; i < [self.outboxResults count]; i++) {
		[self.pseudoSelectedArrayOne addObject:@"0"];
	}
	[self.tableView reloadData];
	
}


-(void)sendMessage{
	
	SendMessage *nextController = [[SendMessage alloc] init];
	nextController.teamId = self.teamId;
	nextController.eventId = self.eventId;
	nextController.eventType = @"generic";
	nextController.origLoc = @"EventTabs";
	[self.navigationController pushViewController:nextController animated:YES];
}

-(void)sendPoll{
	SelectRecipients *tmp = [[SelectRecipients alloc] init];
	tmp.teamId = self.teamId;
	tmp.fromWhere = @"EventTabs";
	tmp.messageOrPoll = @"poll";
    tmp.userRole = self.userRole;
	tmp.eventType = @"generic";
	tmp.eventId = self.eventId;
	[self.navigationController pushViewController:tmp animated:YES];}


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
		
		
		
		CGRect myImageRect = CGRectMake(6.0f, 28.0f, 15.0f, 11.0f);
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
	
	bool isSelected = false;
	
	if (self.inPseudoEditMode) {
		
		if (section == 0) {
			
			if ([self.inboxResults count] > 0) {
				
				if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"0"]) {
					pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
				}else {
					pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
					isSelected = true;
				}
			}
			
		}else {
			
			if ([self.outboxResults count] > 0) {
				
				
				if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"0"]) {
					pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
				}else {
					pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
					isSelected = true;
				}
			}
		}
		
		dateLabel.frame = CGRectMake(27, 46, 280, 15);
		subjLabel.frame = CGRectMake(27, 5, 210, 22);
		bodyLabel.frame = CGRectMake(27, 28, 280, 17);
		replyLabel.frame = CGRectMake(27, 64, 280, 15);
		[pseudoImage setHidden:NO];
		[myImage setHidden:YES];
	}else {
		[pseudoImage setHidden:YES];
		if (!wasViewed) {
			[myImage setHidden:NO];
			dateLabel.frame = CGRectMake(27, 46, 280, 15);
			subjLabel.frame = CGRectMake(27, 5, 210, 22);
			bodyLabel.frame = CGRectMake(27, 28, 280, 17);
			replyLabel.frame = CGRectMake(27, 64, 280, 15);
			
			
		}else {
			[myImage setHidden:YES];
			dateLabel.frame = CGRectMake(10, 46, 280, 15);
			subjLabel.frame = CGRectMake(10, 5, 227, 22);
			bodyLabel.frame = CGRectMake(10, 28, 280, 17);
			replyLabel.frame = CGRectMake(10, 64, 280, 15);
			
			
		}
	}
	
	if (isSelected) {
		//UIColor *tmpColor = [UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0];
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
	
	
	
	if (section == 0) {
		
		if (self.noInbox) {
			bodyLabel.text = @"No messages in inbox...";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			
			[pseudoImage setHidden:YES];
			[subjLabel setHidden:YES];
			[dateLabel setHidden:YES];
			[pollMessageLabel setHidden:YES];
			
			[replyLabel setHidden:YES];
			bodyLabel.frame = CGRectMake(10, 28, 280, 17);
		}else{
			
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
			bodyLabel.text = @"No messages in outbox...";
			[pseudoImage setHidden:YES];
			[subjLabel setHidden:YES];
			[dateLabel setHidden:YES];
			[replyLabel setHidden:YES];
			[pollMessageLabel setHidden:YES];
			bodyLabel.frame = CGRectMake(10, 28, 280, 17);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			
		}else{
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
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
		
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	if (!self.inPseudoEditMode) {
		
		if (section == 0 && ([self.inboxResults count] > 0)) {
			MessageThreadInbox *messageOrPoll = [self.inboxResults objectAtIndex:row];
			
			if ([messageOrPoll.pollChoices count] > 0) {
				ViewPollReceived *poll = [[ViewPollReceived alloc] init];
				
				poll.teamId = self.teamId;
				poll.threadId = messageOrPoll.threadId;
				poll.pollChoices = messageOrPoll.pollChoices;
				poll.from = messageOrPoll.senderName;
				poll.subject = messageOrPoll.subject;
				poll.body = messageOrPoll.body;
				poll.receivedDate = messageOrPoll.receivedDate;
				poll.wasViewed = messageOrPoll.wasViewed;
				poll.status = messageOrPoll.status;

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
				ViewMessageReceived *message = [[ViewMessageReceived alloc] init];
				
				message.teamId = self.teamId;
				//message.from = messageOrPoll.sender
				message.subject = messageOrPoll.subject;
				message.body = messageOrPoll.body;
				message.receivedDate = messageOrPoll.receivedDate;
				message.wasViewed = messageOrPoll.wasViewed;
				message.threadId = messageOrPoll.threadId;
				message.senderId = messageOrPoll.senderId;
				message.senderName = messageOrPoll.senderName;
				
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
		}else if ((section == 1) && ([self.outboxResults count] > 1)) {
			
			MessageThreadOutbox *messageOrPoll = [self.outboxResults objectAtIndex:row];
			
			if ([messageOrPoll.messageType isEqualToString:@"poll"]) {			
				
				ViewPollSent *tmp = [[ViewPollSent alloc] init];
				tmp.teamId = self.teamId;
				tmp.messageThreadId = messageOrPoll.threadId;
				NSString *recipients = messageOrPoll.numRecipients;
				NSString *replies = messageOrPoll.numReplies;
				tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
				[self.navigationController pushViewController:tmp animated:YES];
				
			}else {
				ViewMessageSent *message = [[ViewMessageSent alloc] init];
				
				message.teamId = self.teamId;
				//message.from = messageOrPoll.sender
				message.subject = messageOrPoll.subject;
				message.body = messageOrPoll.body;
				message.createdDate	= messageOrPoll.createdDate;
				message.threadId = messageOrPoll.threadId;
				
				
				[self.navigationController pushViewController:message animated:YES];
			}
		}
	}else {
		
		if (section == 0) {
			
			if ([[self.pseudoSelectedArrayZero objectAtIndex:row] isEqualToString:@"0"]) {
				[self.pseudoSelectedArrayZero replaceObjectAtIndex:row withObject:@"1"];
			}else {
				[self.pseudoSelectedArrayZero replaceObjectAtIndex:row withObject:@"0"];
			}
			
		}else {
			if ([[self.pseudoSelectedArrayOne objectAtIndex:row] isEqualToString:@"0"]) {
				[self.pseudoSelectedArrayOne replaceObjectAtIndex:row withObject:@"1"];
			}else {
				[self.pseudoSelectedArrayOne replaceObjectAtIndex:row withObject:@"0"];
			}
		}
		
		
		[self.tableView reloadData];
		
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

-(void)delete{
	
	
	
	self.threadIdsToArchiveInbox = [NSMutableArray array];
	self.threadIdsToArchiveOutbox = [NSMutableArray array];
	
	for (int i = 0; i < [self.inboxResults count]; i++) {
		
		if ([[self.pseudoSelectedArrayZero objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadInbox *tmp = [self.inboxResults objectAtIndex:i];
			[threadIdsToArchiveInbox addObject:tmp.threadId];
		}
	}
	for (int i = 0; i < [self.outboxResults count]; i++) {
		
		if ([[self.pseudoSelectedArrayOne objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadInbox *tmp = [self.outboxResults objectAtIndex:i];
			[threadIdsToArchiveOutbox addObject:tmp.threadId];
		}
	}
	bool runRequest = false;
	
	if ([threadIdsToArchiveInbox count] > 0) {
		//Server hit to delete the threads
		[self.tabBarController.navigationItem setHidesBackButton:YES];
		[self.deleteButton setHidden:YES];
		[self.editDone setEnabled:NO];
		[self.deleteActivity startAnimating];
		
		[self performSelectorInBackground:@selector(runRequestInbox) withObject:nil];
		runRequest = true;
	}
	if ([threadIdsToArchiveOutbox count] > 0) {
		//Server hit to delete the threads
		[self.tabBarController.navigationItem setHidesBackButton:YES];
		[self.deleteButton setHidden:YES];
		[self.editDone setEnabled:NO];
		[self.deleteActivity startAnimating];
		
		[self performSelectorInBackground:@selector(runRequestOutbox) withObject:nil];
		runRequest = true;
	}
	
	
	if (!runRequest) {
		
		self.inPseudoEditMode = false;
		self.editDone.title = @"Edit";
		self.editDone.style = UIBarButtonItemStylePlain;
		[self.sendPollButton setHidden:NO];
		[self.sendMessageButton setHidden:NO];
		[self.deleteButton setHidden:YES];
		
		[self.tableView reloadData];
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
	
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

-(void)didFinish{
	
	self.inPseudoEditMode = false;
	self.editDone.title = @"Edit";
	self.editDone.style = UIBarButtonItemStylePlain;
	[self.sendPollButton setHidden:NO];
	[self.sendMessageButton setHidden:NO];
	[self.deleteButton setHidden:YES];
	
	[self.tabBarController.navigationItem setHidesBackButton:NO];
	[self.editDone setEnabled:YES];
	[self.deleteActivity stopAnimating];
	
	if (self.deleteSuccess) {
		//[self getAllMessages];
		[self.tabBarController viewWillAppear:NO];
		
	}
	
}



- (void) EditTable:(id)sender{
	
	
	if (self.inPseudoEditMode) {
		self.inPseudoEditMode = false;
		self.editDone.title = @"Edit";
		self.editDone.style = UIBarButtonItemStylePlain;
		[self.sendPollButton setHidden:NO];
		[self.sendMessageButton setHidden:NO];
		[self.deleteButton setHidden:YES];
		
	}else {
		self.inPseudoEditMode = true;
		self.editDone.title = @"Done";
		self.editDone.style = UIBarButtonItemStyleDone;
		[self.sendPollButton setHidden:YES];
		[self.sendMessageButton setHidden:YES];
		[self.deleteButton setHidden:NO];
		
	}
	
	[self.tableView reloadData];
	
}

- (void)viewDidUnload {
	results = nil;
	teamName = nil;
	teamId = nil;
	eventId = nil;
	inboxResults = nil;
	outboxResults = nil;
	error = nil;
	userRole = nil;
	sendPollButton = nil;
	sendMessageButton = nil;
	deleteButton = nil;
	pseudoSelectedArrayOne = nil;
	pseudoSelectedArrayZero = nil;
	deleteActivity = nil;
	editDone = nil;
	threadIdsToArchiveInbox = nil;
	threadIdsToArchiveOutbox = nil;
	messagesOnlyArray = nil;
	pollsOnlyArray = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[results release];
	[teamName release];
	[teamId release];
	[eventId release];
	[inboxResults release];
	[outboxResults release];
	[error release];
	[userRole release];
	[sendPollButton release];
	[sendMessageButton release];
	[deleteButton release];
	[pseudoSelectedArrayZero release];
	[pseudoSelectedArrayOne release];
	[deleteActivity release];
	[editDone release];
	[threadIdsToArchiveInbox release];
	[threadIdsToArchiveOutbox release];
	[messagesOnlyArray release];
	[pollsOnlyArray release];
	
	[super dealloc];
}

@end
