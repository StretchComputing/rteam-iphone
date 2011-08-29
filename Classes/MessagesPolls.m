//
//  MessagesPolls.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessagesPolls.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SendMessage.h"
#import "SendPoll.h"
#import "MessageThreadOutbox.h"
#import "ViewPollSent.h"
#import "SelectRecipients.h"
#import "SelectRecipientsTeam.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessagesPolls
@synthesize results, teamName, teamId, error, inPseudoEditMode, pseduoSelectedArray, editDone, deleteSuccess,
threadIdsToArchive, sendButton, deleteButton, deleteActivity, scroll, tmpBlack, teamList, haveTeamList, teamTable, messagesTableView,
messageDeleteView, cancelDeleteButton, deleteMessagesButton, errorString, teamListCount, barActivity, pollActivity, pollActivityLabel,
teamListFailed, sendPollButtonActivity;


-(void)viewWillDisappear:(BOOL)animated{
	

	[self.barActivity stopAnimating];
	self.tabBarController.navigationItem.leftBarButtonItem = nil;
	displayFilter = false;

}


-(void)viewDidLoad{
	self.teamListFailed = false;
	self.messagesTableView.delegate = self;
	self.messagesTableView.dataSource = self;
	self.teamTable.delegate = self;
	self.teamTable.dataSource = self;
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.messageDeleteView.bounds;
	UIColor *color1 =  [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1];
	UIColor *color2 = [UIColor colorWithRed:0.69 green:0.769 blue:0.871 alpha:1.0];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.messageDeleteView.layer insertSublayer:gradient atIndex:0];
	
	
	self.barActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(95, 32, 20, 20)];
	//set the initial property
	self.barActivity.hidesWhenStopped = YES;
	self.barActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	self.messagesTableView.hidden = YES;
	[self.navigationController.view addSubview:self.barActivity];
	
	self.messageDeleteView.hidden = YES;
	
	[self.pollActivity startAnimating];
	self.pollActivityLabel.hidden = NO;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteMessagesButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.sendButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
	[self.tmpBlack setHidden:YES];
	
	self.scroll.layer.masksToBounds = YES;
	self.scroll.layer.cornerRadius = 25.0;
	//UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	//self.scroll.backgroundColor = tmpColor;
	self.teamTable.backgroundColor = [UIColor clearColor];
	
	self.tmpBlack.backgroundColor = [UIColor blackColor];
	self.tmpBlack.layer.masksToBounds = YES;
	self.tmpBlack.layer.cornerRadius = 25.0;
	
	CAGradientLayer *gradient1 = [CAGradientLayer layer];
	gradient1.frame = self.scroll.bounds;
	UIColor *color3 = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0];
	UIColor *color4 = [UIColor whiteColor];
	gradient1.colors = [NSArray arrayWithObjects:(id)[color3 CGColor], (id)[color4 CGColor], nil];
	[self.scroll.layer insertSublayer:gradient1 atIndex:0];
	
	[self.barActivity stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
	
	displayFilter = true;
	self.tmpBlack.hidden = YES;
	self.teamId = @"";
	[self.barActivity startAnimating];
	[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	
	self.messageDeleteView.hidden = YES;
	
	[self performSelectorInBackground:@selector(getAllPolls) withObject:nil];

		
}


-(void)getAllPolls{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	NSArray *resultsArray = [NSArray array];
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreads:token :self.teamId :@"outbox" :@"" :@"" :@"poll" :@"active"];
		
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			resultsArray = [response valueForKey:@"messages"];
			
		
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.error.text = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.error.text = @"*Error connecting to server";
					break;
				default:
					//log status code?
					self.error.text = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:resultsArray];
	
	NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
	[tmpArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	[lastNameSorter release];
    
	self.results = tmpArray;

	self.pseduoSelectedArray = [NSMutableArray array];
	for (int i = 0; i < [self.results count]; i++) {
		[self.pseduoSelectedArray addObject:@"0"];
	}
	
	[pool drain];
	
	[self performSelectorOnMainThread:@selector(finishedPolls) withObject:nil waitUntilDone:NO];
}

-(void)finishedPolls{
	
	[self.barActivity stopAnimating];
	[self.pollActivity stopAnimating];
	self.pollActivityLabel.hidden = YES;
	self.messagesTableView.hidden = NO;
	[self.messagesTableView reloadData];

	
}

-(void)waitTeamList{

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	while (!self.haveTeamList) {
		
		if (self.teamListFailed) {
			break;
		}
	}
			
	[self performSelectorOnMainThread:@selector(goPoll) withObject:nil waitUntilDone:NO];
	
	
	[pool drain];
	
}
	
-(void)goPoll{
	
	self.sendButton.hidden = NO;
	[self.sendPollButtonActivity stopAnimating];
	
	if (!self.teamListFailed) {

		NSArray *teamArray = self.teamList;
		
		if ([teamArray count] == 1) {
			Team *tmpTeam = [teamArray objectAtIndex:0];
			SelectRecipients *tmp = [[SelectRecipients alloc] init];
			tmp.teamId = tmpTeam.teamId;
			tmp.fromWhere = @"MessagesTabs";
			tmp.messageOrPoll = @"poll";
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if ([teamArray count] > 1) {
			SelectRecipientsTeam *tmp = [[SelectRecipientsTeam alloc] init];
			tmp.teamArray = teamArray;
			tmp.fromWhere = @"MessagesTabs";
			tmp.messageOrPoll = @"poll";
			[self.navigationController pushViewController:tmp animated:YES];
		}else {
			
			self.error.text = @"*You must create or join at least 1 team to send a poll.";
		}
		
	}else {
	
		self.error.text = @"*Error retrieving team list.";

	}

	
}


-(void)sendPoll{
	
	[self.sendPollButtonActivity startAnimating];
	self.sendButton.hidden = YES;
	
	[self performSelectorInBackground:@selector(waitTeamList) withObject:nil];
	
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.messagesTableView) {
		
		if ([self.results count] == 0) {
			return 1;
		}
		return [self.results count];
		
	}else {
		return [self.teamList count] + 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.messagesTableView){
			
		static NSString *FirstLevelCell=@"FirstLevelCell";
		static NSInteger subjTag = 1;
		static NSInteger bodTag = 2;
		static NSInteger dateTag = 3;
		static NSInteger replyTag = 4;
		static NSInteger finalizedTag = 5;
		static NSInteger teamTag = 6;
		static NSInteger pseudoTag = 7;
		static NSInteger noResultsTag = 8;
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
		
		if (cell == nil){
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
			CGRect frame;
			frame.origin.x = 10;
			frame.origin.y = 5;
			frame.size.height = 22;
			frame.size.width = 195;
			
			
			UILabel *subjectLabel = [[UILabel alloc] initWithFrame:frame];
			subjectLabel.tag = subjTag;
			[cell.contentView addSubview:subjectLabel];
			[subjectLabel release];
			
			
			
			frame.size.width = 280;
			frame.size.height = 17;
			frame.origin.y += 23;
			UILabel *bodyLabel = [[UILabel alloc] initWithFrame:frame];
			bodyLabel.tag = bodTag;
			[cell.contentView addSubview:bodyLabel];
			[bodyLabel release];
			
			frame.size.height = 15;
			frame.origin.y =5;
			frame.size.width = 140;
			frame.origin.x = 200;
			UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
			dateLabel.tag = dateTag;
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
			
			
			//frame.size.height = 15;
			frame.origin.x = 32;
			frame.origin.y = 46;
			frame.size.width = 170;
			UILabel *replyLabel = [[UILabel alloc] initWithFrame:frame];
			replyLabel.tag = replyTag;
			[cell.contentView addSubview:replyLabel];
			[replyLabel release];
			
			frame.origin.x = 215;
			frame.origin.y = 46;
			frame.size.width = 100;
			UILabel *finalizedLabel = [[UILabel alloc] initWithFrame:frame];
			finalizedLabel.tag = finalizedTag;
			[cell.contentView addSubview:finalizedLabel];
			[finalizedLabel release];
			
			frame.size.height = 15;
			frame.origin.y = 64;
			frame.origin.x = 10;
			UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
			teamLabel.tag = teamTag;
			[cell.contentView addSubview:teamLabel];
			[teamLabel release];
			
			CGRect rect = CGRectMake(4.0f, 25.0f, 20.0f, 20.0f);
			UIImageView *pseudoImage = [[UIImageView alloc] initWithFrame:rect];
			pseudoImage.tag = pseudoTag;
			[pseudoImage setImage:[UIImage imageNamed:@"pseudoNotSelected.png"]];
			pseudoImage.opaque = YES; // explicitly opaque for performance
			[cell.contentView addSubview:pseudoImage];
			[pseudoImage release];
			
			frame.size.height = 20;
			frame.origin.y = 30;
			frame.origin.x = 0;
			frame.size.width = 320;
			UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:frame];
			noResultsLabel.tag = noResultsTag;
			[cell.contentView addSubview:noResultsLabel];
			[noResultsLabel release];
			
		}
		
		UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
		dateLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *noResultsLabel = (UILabel *)[cell.contentView viewWithTag:noResultsTag];
		noResultsLabel.backgroundColor = [UIColor clearColor];
		noResultsLabel.textColor = [UIColor grayColor];
		noResultsLabel.textAlignment = UITextAlignmentCenter;
		
		UILabel *subjLabel = (UILabel *)[cell.contentView viewWithTag:subjTag];
		subjLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *bodyLabel = (UILabel *)[cell.contentView viewWithTag:bodTag];
		bodyLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *replyLabel = (UILabel *)[cell.contentView viewWithTag:replyTag];
		replyLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *finalizedLabel = (UILabel *)[cell.contentView viewWithTag:finalizedTag];
		finalizedLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
		teamLabel.backgroundColor = [UIColor clearColor];
		
		UIImageView *pseudoImage = (UIImageView *)[cell.contentView viewWithTag:pseudoTag];
		pseudoImage.backgroundColor = [UIColor clearColor];
		
		NSUInteger row = [indexPath row];
		
		if ([self.results count] == 0) {
			
			noResultsLabel.text = @"No polls sent...";
			
			noResultsLabel.hidden = NO;
			pseudoImage.hidden = YES;
			dateLabel.hidden = YES;
			subjLabel.hidden = YES;
			bodyLabel.hidden = YES;
			finalizedLabel.hidden = YES;
			teamLabel.hidden = YES;
			replyLabel.hidden = YES;
			
			cell.contentView.backgroundColor = [UIColor whiteColor];
			cell.accessoryView.backgroundColor = [UIColor whiteColor];
			cell.backgroundView = [[[UIView alloc] init] autorelease]; 
			cell.backgroundView.backgroundColor = [UIColor whiteColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;

			return cell;
			
		}else {
			noResultsLabel.hidden = YES;
			pseudoImage.hidden = NO;
			dateLabel.hidden = NO;
			subjLabel.hidden = NO;
			bodyLabel.hidden = NO;
			finalizedLabel.hidden = NO;
			teamLabel.hidden = NO;
			replyLabel.hidden = NO;
			
			UIButton *selectRowButton = [UIButton buttonWithType:UIButtonTypeCustom];
			selectRowButton.tag = row;
			selectRowButton.hidden = NO;
			selectRowButton.frame = CGRectMake(0, 0, 31, 67);
			[selectRowButton addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
			[selectRowButton retain];
			//selectRowButton.backgroundColor = [UIColor redColor];
			[cell.contentView addSubview:selectRowButton];
			[cell.contentView bringSubviewToFront:selectRowButton];
			
			
			
			bool isSelected = false;
			
			if ([[self.pseduoSelectedArray objectAtIndex:row] isEqualToString:@"0"]) {
				pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
			}else {
				pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
				isSelected = true;
				
			}
			
			dateLabel.frame = CGRectMake(225, 5, 75, 15);
			subjLabel.frame = CGRectMake(32, 5, 163, 22);
			bodyLabel.frame = CGRectMake(32, 28, 255, 17);
			teamLabel.frame = CGRectMake(32, 64, 280, 15);
			[pseudoImage setHidden:NO];
			
			
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
			
			
			dateLabel.frame = CGRectMake(225, 5, 75, 15);
			
			
			
			teamLabel.textColor = [UIColor colorWithRed:0.133333 green:0.5451 blue:0.133333 alpha:1.0];
			teamLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			
			
			
			subjLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
			
			dateLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			dateLabel.textColor = [UIColor blueColor];
			
			bodyLabel.textColor = [UIColor grayColor];
			bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			
			replyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
			replyLabel.textColor = [UIColor blueColor];
			finalizedLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			//Configure the cell
			
			
			MessageThreadOutbox *theMessage = [self.results objectAtIndex:row];
			
			
			if (theMessage.teamName != nil) {
				teamLabel.text = [@"Team: " stringByAppendingString:theMessage.teamName];
			}
			
			if (![self.teamId isEqualToString:@""]) {
				teamLabel.text = self.teamName;
			}
			
			//set the date
			dateLabel.text = [self formatDateString:theMessage.createdDate];
			dateLabel.textAlignment = UITextAlignmentRight;
			
			//set subject and question
			subjLabel.text = theMessage.subject;
			bodyLabel.text = theMessage.body;
			
			NSString *recipients = theMessage.numRecipients;
			NSString *replies = theMessage.numReplies;
			
			if (recipients == nil) {
				recipients = @"0";
			}
			if (replies == nil) {
				replies = @"0";
			}
			
			NSString *replyString = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
			
			replyLabel.text = replyString;
			
			if ([theMessage.status isEqualToString:@"finalized"]) {
				finalizedLabel.text = @"*Complete*";
				finalizedLabel.textColor = [UIColor redColor];
				[finalizedLabel setHidden:NO];
				
				if (self.inPseudoEditMode) {
					teamLabel.frame = CGRectMake(27, 46, 183, 15);
					
				}else {
					teamLabel.frame = CGRectMake(10, 46, 200, 15);
				}
				
			}else {
				[finalizedLabel setHidden:YES];
			}
			
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if (self.inPseudoEditMode) {
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}else {
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			}
			return cell;
			
		}
		
				
	}else {
		//Team table view
		
		static NSString *FirstLevelCell=@"FirstLevelCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc]
					 initWithStyle:UITableViewCellStyleDefault
					 reuseIdentifier: FirstLevelCell] autorelease];
		}
		
		NSUInteger row = [indexPath row];
		
		if (row == 0) {
			cell.textLabel.text = @"All";
		}else {
			Team *tmpTeam = [self.teamList objectAtIndex:row-1];
			
			NSString *count = @"";
			if ([self.teamListCount count] > 0) {
				count = [self.teamListCount objectAtIndex:row-1];
				
			}
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@ - (%@)", tmpTeam.name, count];
		}
		
		
		
		return cell;
		
	}
	
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.messagesTableView) {
		return 80;
	}
    return 30;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	 NSUInteger row = [indexPath row];
	
	if (tableView == self.messagesTableView) {
		
		if ([self.results count] > 0) {
			MessageThreadOutbox *thread = [self.results objectAtIndex:row];
			
			ViewPollSent *tmp = [[ViewPollSent alloc] init];
			
			if ((self.teamId == nil) || ([self.teamId isEqualToString:@""])) {
				tmp.teamId = thread.teamId;
			}else{
				tmp.teamId = self.teamId;
			}
			
			tmp.messageThreadId = thread.threadId;
			tmp.teamName = thread.teamName;
			NSString *recipients = thread.numRecipients;
			NSString *replies = thread.numReplies;
			
			if (recipients == nil) {
				recipients = @"0";
			}
			if (replies == nil) {
				replies = @"0";
			}
			
			if ([thread.status isEqualToString:@"finalized"]) {
				tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people replied."];
			}else {
				tmp.replyFraction = [[[replies stringByAppendingString:@"/"] stringByAppendingString:recipients] stringByAppendingString:@" people have replied."];
			}
			
			tmp.pollArray = self.results;
			
			for (int i = 0; i < [self.results count]; i++) {
				
				MessageThreadOutbox *tmp1 = [self.results objectAtIndex:i];
				
				if ([tmp1.threadId isEqualToString:thread.threadId]) {
					tmp.currentPollNumber = i;
				}
			}
			
			
			
			[self.navigationController pushViewController:tmp animated:YES];
			
		}
	 
	}else {
		[self.tmpBlack setHidden:YES];
		self.editDone.title = @"Team Filter";
		
		
		if (row == 0) {
			self.teamId = @"";
			
			[self.barActivity startAnimating];
			[self performSelectorInBackground:@selector(getAllPolls) withObject:nil];

		}else {
			Team *tmpTeam = [self.teamList objectAtIndex:row-1];
			self.teamId = tmpTeam.teamId;
			self.teamName = tmpTeam.name;
			
			[self.barActivity startAnimating];
			[self performSelectorInBackground:@selector(getAllPolls) withObject:nil];

		}
		
	}
}

-(void)messageDelete{
	//Delete all message threads that are selected.
	
	self.threadIdsToArchive = [NSMutableArray array];
	
	for (int i = 0; i < [self.results count]; i++) {
		
		if ([[self.pseduoSelectedArray objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadOutbox *tmp = [self.results objectAtIndex:i];
			[threadIdsToArchive addObject:tmp.threadId];
		}
	}
	
	
	[self.deleteActivity startAnimating];
	[self.deleteMessagesButton setEnabled:NO];
	[self.tabBarController.navigationItem setHidesBackButton:YES];
	[self.cancelDeleteButton setEnabled:NO];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}

- (void)runRequest {

	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSDictionary *response = [ServerAPI updateMessageThreads:mainDelegate.token :self.threadIdsToArchive :@"outbox"];
	
	
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
	
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

-(void)didFinish{
	
	
	[self.deleteActivity stopAnimating];
	[self.deleteMessagesButton setEnabled:YES];
	[self.tabBarController.navigationItem setHidesBackButton:NO];
	[self.cancelDeleteButton setEnabled:YES];
	
	if (self.deleteSuccess) {
		//[self getAllMessages];
		[self.messageDeleteView setHidden:YES];
		[self.tabBarController viewWillAppear:NO];
		
	}else {
		self.error.text = self.errorString;
	}

	
}



-(NSString *)formatDateString:(NSString *)messageSent{
	//If its today, just return the time
	//If its yesterday, return "Yesterday"
	//else, return format MM/DD/YY
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
    NSDate *messageDate = [dateFormat dateFromString:messageSent];
	NSDate *todaysDate = [NSDate date];
	NSDate *yesterdaysDate = [todaysDate dateByAddingTimeInterval:-86400];
	
	[dateFormat setDateFormat:@"yyyyMMdd"];
	NSString *messageString = [dateFormat stringFromDate:messageDate];
	NSString *todayString = [dateFormat stringFromDate:todaysDate];
	NSString *yesterdayString = [dateFormat stringFromDate:yesterdaysDate];
	
	NSString *returnDate = @"";
	if ([messageString isEqualToString:todayString]) {
		//Date is today, return the message time
		[dateFormat setDateFormat:@"hh:mm aa"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}else if ([messageString isEqualToString:yesterdayString]) {
		//Date was yesterday
		returnDate = @"Yesterday";
	}else {
		//Date was not today or yesterday
		[dateFormat setDateFormat:@"MM/dd/yy"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}
	
	[dateFormat release];
	return returnDate;
	
}


-(void)getTeamList{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	self.teamListCount = [NSMutableArray array];

	self.teamListFailed = false;
	//Retrieve teams from DB
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getListOfTeams:token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.teamList = [response valueForKey:@"teams"];
			
			for (int i = 0; i < [self.teamList count]; i++) {
				[self.teamListCount addObject:@"0"];
			}
			
			
			self.haveTeamList = true;
			
			
		}else{
			
			self.haveTeamList = false;
			self.teamListFailed = true;
			//self.memberTeams = [NSMutableArray array];
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
		[self performSelectorOnMainThread:
		 @selector(doneTeams)
							   withObject:nil
							waitUntilDone:NO
		 ];
		
		
		[pool drain];
		
	}
	
	
}

-(void)doneTeams{
	bool showFilter;
	if (self.haveTeamList) {
		
		if ([self.teamList count] > 1) {
			showFilter = true;
		}else {
			showFilter = false;
		}
		
	}else {
		showFilter = false;
	}
	
	
	if (showFilter) {
		
		self.editDone = [[UIBarButtonItem alloc] initWithTitle:@"Team Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterTeam)];
		
		if (displayFilter) {

			[self.tabBarController.navigationItem setLeftBarButtonItem:self.editDone];

		}
		
		[self.teamTable reloadData];
	}else {
		self.tabBarController.navigationItem.leftBarButtonItem = nil;
	}
	
}

-(void)filterTeam{
	
	self.messageDeleteView.hidden = YES;
	
	for (int i = 0; i < [self.pseduoSelectedArray count]; i++) {
		
		[self.pseduoSelectedArray replaceObjectAtIndex:i withObject:@"0"];
	}
	
	[self performSelectorInBackground:@selector(getTeamMessageCounts) withObject:nil];

	if (self.tmpBlack.hidden == YES) {
		[self.tmpBlack setHidden:NO];
		self.editDone.title = @"Cancel";
		
	}else {
		[self.tmpBlack setHidden:YES];
		self.editDone.title = @"Team Filter";
	}
	
	
	
}


-(void)cancelDelete{
	
	self.messageDeleteView.hidden = YES;
	
	for (int i = 0; i < [self.pseduoSelectedArray count]; i++) {
		
		[self.pseduoSelectedArray replaceObjectAtIndex:i withObject:@"0"];
	}
	
	[self.messagesTableView reloadData];
}

-(void)selectRow:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	int thisTag = tmp.tag;
	
	if ([[self.pseduoSelectedArray objectAtIndex:thisTag] isEqualToString:@"0"]) {
		[self.pseduoSelectedArray replaceObjectAtIndex:thisTag withObject:@"1"];
	}else if ([[self.pseduoSelectedArray objectAtIndex:thisTag] isEqualToString:@"1"]) {
		[self.pseduoSelectedArray replaceObjectAtIndex:thisTag withObject:@"0"];
	}
	
	[self.messagesTableView reloadData];
	
	bool noneSelected = true;
	for (int i = 0; i < [self.pseduoSelectedArray count]; i++) {
		
		NSString *tmp = [self.pseduoSelectedArray objectAtIndex:i];
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

-(void)getTeamMessageCounts{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	//Retrieve teams from DB
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	for (int i = 0; i < [self.teamList count]; i++) {
		
		//If there is a token, do a DB lookup to find the teams associated with this coach:
		if (![token isEqualToString:@""]){
			
			Team *tmpTeam = [self.teamList objectAtIndex:i];
						
			NSDictionary *response = [ServerAPI getMessageThreads:token :tmpTeam.teamId :@"outbox" :@"" :@"" :@"poll" :@"active"];
			
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				NSArray *resultsArray = [response valueForKey:@"messages"];
				NSString *count = [NSString stringWithFormat:@"%d", [resultsArray count]];
				
				[self.teamListCount replaceObjectAtIndex:i withObject:count];
				
				
			}else{
				
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						//self.error = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						//self.error = @"*Error connecting to server";
						break;
					default:
						//should never get here
						//self.error = @"*Error connecting to server";
						break;
				}
			}
			
			
			
			[self performSelectorOnMainThread:
			 @selector(doneCount)
								   withObject:nil
								waitUntilDone:NO
			 ];
			
			
			
		}
		
	}
	
	[pool drain];
	
}

-(void)doneCount{
	
	[self.teamTable reloadData];
	
}

- (void)viewDidUnload {
	//results = nil;
	//teamName = nil;
	//teamId = nil;
	error = nil;
	sendButton = nil;
	//pseduoSelectedArray = nil;
	editDone = nil;
	//threadIdsToArchive = nil;
	deleteButton = nil;
	deleteActivity = nil;
	messageDeleteView = nil;
	cancelDeleteButton = nil;
	deleteMessagesButton = nil;
	messagesTableView = nil;
	scroll = nil;
	teamTable = nil;
	//teamList = nil;
	tmpBlack = nil;
	//errorString = nil;
	//teamListCount = nil;
	barActivity = nil;
	pollActivity = nil;
	pollActivityLabel = nil;
	sendPollButtonActivity = nil;
	[super viewDidUnload];
	


}


- (void)dealloc {
	[results release];
	[teamName release];
	[sendPollButtonActivity release];
	[teamId release];
	[error release];
	[sendButton release];
	[pseduoSelectedArray release];
	[editDone release];
	[threadIdsToArchive release];
	[deleteButton release];
	[deleteActivity release];
	[messageDeleteView release];
	[cancelDeleteButton release];
	[deleteMessagesButton release];
	[messagesTableView release];
	[scroll release];
	[teamTable release];
	[teamList release];
	[tmpBlack release];
	[errorString release];
	[teamListCount release];
	[barActivity release];
	[pollActivity release];
	[pollActivityLabel release];
	[super dealloc];
}

@end
