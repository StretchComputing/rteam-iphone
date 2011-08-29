//
//  MessagesInbox.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessagesInbox.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SendMessage.h"
#import "SendPoll.h"
#import "MessageThreadInbox.h"
#import "ViewPollReceived.h"
#import "ViewMessageReceived.h"
#import <QuartzCore/QuartzCore.h>
#import "GameChatter.h"
#import "PracticeChatter.h"

@implementation MessagesInbox
@synthesize results, teamName, teamId, userRole, error, inPseudoEditMode, pseduoSelectedArray, editDone, myHeader, deleteSuccess,
threadIdsToArchive, deleteButton, deleteActivity, messagesOnlyArray, pollsOnlyArray, messageDeleteView, cancelDeleteButton, deleteMessagesButton,
messagesTableView, teamTable, scroll, haveTeamList, teamList, tmpBlack, teamListCount, messageActivity, messageActivityLabel, barActivity;


-(void)viewWillDisappear:(BOOL)animated{
	

	[self.barActivity stopAnimating];
	self.tabBarController.navigationItem.leftBarButtonItem = nil;
	displayFilter = false;

	
}

-(void)viewDidLoad{
	
	self.teamId = @"";

	self.messagesTableView.delegate = self;
	self.messagesTableView.dataSource = self;
	self.teamTable.delegate = self;
	self.teamTable.dataSource = self;
		
	self.messagesTableView.hidden = YES;

	[self.messageActivity startAnimating];
	self.messageActivityLabel.hidden = NO;
	
	self.barActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(95, 32, 20, 20)];
	//set the initial property
	self.barActivity.hidesWhenStopped = YES;
	self.barActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	self.messagesTableView.hidden = YES;
	[self.navigationController.view addSubview:self.barActivity];
	
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.messageDeleteView.bounds;
	UIColor *color1 =  [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1];
	UIColor *color2 = [UIColor colorWithRed:0.69 green:0.769 blue:0.871 alpha:1.0];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.messageDeleteView.layer insertSublayer:gradient atIndex:0];
	
	
	self.messageDeleteView.hidden = YES;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteMessagesButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
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
	
	
	UIView *footerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 65)]
	 autorelease];
	
	CGRect myImageRect = CGRectMake(125.0f, 100.0f, 48.0f, 48.0f);
	UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
	[myImage setImage:[UIImage imageNamed:@"message.png"]];
	myImage.opaque = YES; // explicitly opaque for performance
	[footerView addSubview:myImage];
	[myImage release];
	
	footerView.backgroundColor = [UIColor whiteColor];
	
	self.messagesTableView.tableFooterView = footerView;
	
}


-(void)viewWillAppear:(BOOL)animated{

	self.tmpBlack.hidden = YES;

	displayFilter = true;
	
	[self.barActivity startAnimating];
	[self performSelectorInBackground:@selector(getTeamList) withObject:nil];

	self.messageDeleteView.hidden = YES;
	
	[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
	
	UIView *footerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 65)]
	 autorelease];
	
	CGRect myImageRect = CGRectMake(125.0f, 100.0f, 48.0f, 48.0f);
	UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
	[myImage setImage:[UIImage imageNamed:@"message.png"]];
	myImage.opaque = YES; // explicitly opaque for performance
	[footerView addSubview:myImage];
	[myImage release];
	
	
	footerView.backgroundColor = [UIColor whiteColor];
	
	self.messagesTableView.tableFooterView = footerView;
	
}


-(void)cancelDelete{
	
	self.messageDeleteView.hidden = YES;

	for (int i = 0; i < [self.pseduoSelectedArray count]; i++) {
		
		[self.pseduoSelectedArray replaceObjectAtIndex:i withObject:@"0"];
	}
	
	[self.messagesTableView reloadData];
}


-(void)getAllMessages{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);

	
	NSString *token = @"";
	NSArray *resultsArray = [NSArray array];
	self.messagesOnlyArray = [NSMutableArray array];
	self.pollsOnlyArray = [NSMutableArray array];
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (self.teamId == nil) {
		self.teamId = @"";
	}
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreads:token :self.teamId :@"inbox" :@"" :@"" :@"both" :@"active"];
		
		
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
	
	NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:resultsArray];

	
	
	NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"receivedDate" ascending:NO];
	[tmpArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	[lastNameSorter release];
	
	self.results = tmpArray;
	
	self.pseduoSelectedArray = [NSMutableArray array];
	for (int i = 0; i < [self.results count]; i++) {
		[self.pseduoSelectedArray addObject:@"0"];
		
		//Fill the messages and polls arrays
		MessageThreadInbox *tmp = [self.results objectAtIndex:i];
		if ([tmp.pollChoices count] > 0) {
			//Its a poll
			[self.pollsOnlyArray addObject:tmp];
		}else {
			
			if (!tmp.threadingUsed) {
				[self.messagesOnlyArray addObject:tmp];
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
	self.messagesTableView.hidden = NO;
	[self.messagesTableView reloadData];

	
}
-(void)messageDelete{
	//Delete all message threads that are selected.
	
	self.threadIdsToArchive = [NSMutableArray array];
	
	for (int i = 0; i < [self.results count]; i++) {
		
		if ([[self.pseduoSelectedArray objectAtIndex:i] isEqualToString:@"1"]) {
			MessageThreadInbox *tmp = [self.results objectAtIndex:i];
			
			if (tmp.threadingUsed) {
							
				for (int i = 0; i < [tmp.subThreadIds count]; i++) {
										
					[threadIdsToArchive addObject:[tmp.subThreadIds objectAtIndex:i]];
				}
			}else {
				[threadIdsToArchive addObject:tmp.threadId];

			}

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
	
	
	NSDictionary *response = [ServerAPI updateMessageThreads:mainDelegate.token :self.threadIdsToArchive :@"inbox"];
	
	
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

	
	[self.deleteActivity stopAnimating];
	[self.deleteMessagesButton setEnabled:YES];
	[self.tabBarController.navigationItem setHidesBackButton:NO];
	[self.cancelDeleteButton setEnabled:YES];
	
	if (self.deleteSuccess) {
		[self.messageDeleteView setHidden:YES];
		[self.tabBarController viewWillAppear:NO];

	}
	
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
	
	if (tableView == self.messagesTableView) {
		
		NSUInteger row = [indexPath row];
		
		//The object in the array is in the Inbox, but it could be a Poll or a Message.
		
		BOOL wasViewed = NO;
		
		MessageThreadInbox *theMessage;
		if ([self.results count] > 0) {
			theMessage = [self.results objectAtIndex:row];
			
			wasViewed = theMessage.wasViewed;
		}
		
		
		static NSString *FirstLevelCell=@"FirstLevelCell";
		static NSInteger subjTag = 1;
		static NSInteger bodTag = 2;
		static NSInteger dateTag = 3;
		static NSInteger finalizedTag = 4;
		static NSInteger imageTag = 5;
		static NSInteger pseudoTag = 6;
		static NSInteger teamTag = 7;
		static NSInteger noResultsTag = 8;
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
		
		if (cell == nil){
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
			CGRect frame;
			
			frame.origin.x = 10;
			frame.origin.y = 5;
			frame.size.height = 22;
			frame.size.width = 280;
			
			UILabel *subjectLabel = [[UILabel alloc] initWithFrame:frame];
			subjectLabel.tag = subjTag;
			[cell.contentView addSubview:subjectLabel];
			[subjectLabel release];
			
			frame.size.height = 17;
			frame.origin.y += 23;
			UILabel *bodyLabel = [[UILabel alloc] initWithFrame:frame];
			bodyLabel.tag = bodTag;
			[cell.contentView addSubview:bodyLabel];
			[bodyLabel release];
			
			frame.size.height = 15;
			frame.origin.y += 18;
			UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
			dateLabel.tag = dateTag;
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
			
			frame.size.height = 15;
			frame.origin.y += 16;
			frame.origin.x = 45;
			UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
			teamLabel.tag = teamTag;
			[cell.contentView addSubview:teamLabel];
			[teamLabel release];
			
			
			frame.origin.x = 215;
			frame.origin.y = 46;
			frame.size.width = 100;
			UILabel *finalizedLabel = [[UILabel alloc] initWithFrame:frame];
			finalizedLabel.tag = finalizedTag;
			[cell.contentView addSubview:finalizedLabel];
			[finalizedLabel release];
			
			
			
			CGRect myImageRect = CGRectMake(28.0f, 28.0f, 15.0f, 11.0f);
			UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
			myImage.tag = imageTag;
			[myImage setImage:[UIImage imageNamed:@"blueDot1.png"]];
			myImage.opaque = YES; // explicitly opaque for performance
			[cell.contentView addSubview:myImage];
			[myImage release];
			
			CGRect rect = CGRectMake(4.0f, 23.5, 20.0f, 20.0f);
			UIImageView *pseudoImage = [[UIImageView alloc] initWithFrame:rect];
			pseudoImage.tag = pseudoTag;
			[pseudoImage setImage:[UIImage imageNamed:@"pseudoNotSelected.png"]];
			pseudoImage.opaque = YES; // explicitly opaque for performance
			[cell.contentView addSubview:pseudoImage];
			[pseudoImage release];
			
			frame.size.height = 20;
			frame.origin.y = 25;
			frame.origin.x = 0;
			frame.size.width = 320;
			UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:frame];
			noResultsLabel.tag = noResultsTag;
			[cell.contentView addSubview:noResultsLabel];
			[noResultsLabel release];
			
			/*
			 UIButton *selectRowButton = [UIButton buttonWithType:UIButtonTypeCustom];
			 selectRowButton.tag = selectRowTag;
			 selectRowButton.frame = CGRectMake(0, 0, 66, 40);
			 [selectRowButton addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
			 [cell.contentView addSubview:selectRowButton];
			 */
			
		}
		
		
		UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
		dateLabel.backgroundColor = [UIColor clearColor];
		UILabel *subjLabel = (UILabel *)[cell.contentView viewWithTag:subjTag];
		subjLabel.backgroundColor = [UIColor clearColor];
		UILabel *bodyLabel = (UILabel *)[cell.contentView viewWithTag:bodTag];
		bodyLabel.backgroundColor = [UIColor clearColor];	
		UILabel *finalizedLabel = (UILabel *)[cell.contentView viewWithTag:finalizedTag];
		finalizedLabel.backgroundColor = [UIColor clearColor];	
		UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
		teamLabel.backgroundColor = [UIColor clearColor];
		
		UIImageView *myImage = (UIImageView *)[cell.contentView viewWithTag:imageTag];
		myImage.backgroundColor = [UIColor clearColor];
		
		UIImageView *pseudoImage = (UIImageView *)[cell.contentView viewWithTag:pseudoTag];
		pseudoImage.backgroundColor = [UIColor clearColor];
		
		UILabel *noResultsLabel = (UILabel *)[cell.contentView viewWithTag:noResultsTag];
		noResultsLabel.backgroundColor = [UIColor clearColor];
		noResultsLabel.textColor = [UIColor grayColor];
		noResultsLabel.textAlignment = UITextAlignmentCenter;
		
		if ([self.results count] == 0) {
			
			noResultsLabel.hidden = NO;
			noResultsLabel.text = @"No messages in inbox...";
			pseudoImage.hidden = YES;
			myImage.hidden = YES;
			pseudoImage.hidden = YES;
			dateLabel.hidden = YES;
			subjLabel.hidden = YES;
			bodyLabel.hidden = YES;
			finalizedLabel.hidden = YES;
			teamLabel.hidden = YES;
			
			
			cell.contentView.backgroundColor = [UIColor whiteColor];
			cell.accessoryView.backgroundColor = [UIColor whiteColor];
			cell.backgroundView = [[[UIView alloc] init] autorelease]; 
			cell.backgroundView.backgroundColor = [UIColor whiteColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryNone;
			
			return cell;
			
		}else {
			noResultsLabel.hidden = YES;
			myImage.hidden = NO;
			pseudoImage.hidden = NO;
			dateLabel.hidden = NO;
			subjLabel.hidden = NO;
			bodyLabel.hidden = NO;
			finalizedLabel.hidden = NO;
			teamLabel.hidden = NO;
			
			UIButton *selectRowButton = [UIButton buttonWithType:UIButtonTypeCustom];
			selectRowButton.tag = row;
			selectRowButton.frame = CGRectMake(0, 0, 45, 67);
			[selectRowButton addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
			[selectRowButton retain];
			//selectRowButton.backgroundColor = [UIColor redColor];
			[cell.contentView addSubview:selectRowButton];
			[cell.contentView bringSubviewToFront:selectRowButton];
			[selectRowButton release];
            
			bool isSelected = false;
			
			if (!wasViewed) {
				
				if ([[self.pseduoSelectedArray objectAtIndex:row] isEqualToString:@"0"]) {
					pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
				}else {
					pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
					isSelected = true;
					
				}
				
				dateLabel.frame = CGRectMake(225, 5, 75, 15);
				subjLabel.frame = CGRectMake(45, 5, 183, 22);
				bodyLabel.frame = CGRectMake(45, 28, 255, 17);
				teamLabel.frame = CGRectMake(45, 46, 280, 15);
				[pseudoImage setHidden:NO];
				[myImage setHidden:NO];
				
			}else {
				if ([[self.pseduoSelectedArray objectAtIndex:row] isEqualToString:@"0"]) {
					pseudoImage.image = [UIImage imageNamed:@"pseudoNotSelected.png"];
				}else {
					pseudoImage.image = [UIImage imageNamed:@"pseudoSelected.png"];
					isSelected = true;
					
				}
				
				dateLabel.frame = CGRectMake(225, 5, 75, 15);
				subjLabel.frame = CGRectMake(45, 5, 183, 22);
				bodyLabel.frame = CGRectMake(45, 28, 255, 17);
				teamLabel.frame = CGRectMake(45, 46, 280, 15);
				[pseudoImage setHidden:NO];
				[myImage setHidden:YES];
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
			
			if (theMessage.teamName != nil) {
				teamLabel.text = [@"Team: " stringByAppendingString:theMessage.teamName];
				[teamLabel setHidden:NO];
			}else {
				[teamLabel setHidden:YES];
			}
			
			if (![self.teamId isEqualToString:@""]) {
				teamLabel.text = self.teamName;
				[teamLabel setHidden:NO];
			}
			
			teamLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			teamLabel.textColor = [UIColor colorWithRed:0.133333 green:0.5451 blue:0.133333 alpha:1.0];
			
			subjLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
			
			dateLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
			dateLabel.textColor = [UIColor blueColor];
			dateLabel.textAlignment = UITextAlignmentRight;
			
			finalizedLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			finalizedLabel.textColor = [UIColor redColor];
			finalizedLabel.text = @"*Completed*";
			
			bodyLabel.textColor = [UIColor grayColor];
			bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
			
			
			//Configure the cell
			[finalizedLabel setHidden:YES];
			if ([theMessage.pollChoices count] > 0) {
				//Then it is a poll
				
				if ([theMessage.status isEqualToString:@"finalized"]) {
					[finalizedLabel setHidden:NO];
					
					if (self.inPseudoEditMode) {
						teamLabel.frame = CGRectMake(45, 46, 170, 15);
						
					}else {
						if (!wasViewed) {
							teamLabel.frame = CGRectMake(45, 46, 170, 15);
							
						}else {
							teamLabel.frame = CGRectMake(45, 46, 170, 15);
							
						}
					}
				}
			}
			
			//Set the date
			dateLabel.text = [self formatDateString:theMessage.receivedDate];
			
			
			//Set subject and body of message
			subjLabel.text = theMessage.subject;
			bodyLabel.text = theMessage.body;
			
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

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.messagesTableView) {
		return 67;
	}
    return 30;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	
	if (tableView == self.messagesTableView) {
		
		if ([self.results count] > 0) {
			MessageThreadInbox *messageOrPoll = [self.results objectAtIndex:row];
			
			if ([messageOrPoll.pollChoices count] > 0) {
				ViewPollReceived *poll = [[ViewPollReceived alloc] init];
				
				if ((self.teamId == nil) || ([self.teamId isEqualToString:@""])) {
					poll.teamId = messageOrPoll.teamId;
				}else{
					poll.teamId = self.teamId;
				}
				
				poll.threadId = messageOrPoll.threadId;
				poll.pollChoices = messageOrPoll.pollChoices;
				poll.from = messageOrPoll.senderName;
				poll.subject = messageOrPoll.subject;
				poll.body = messageOrPoll.body;
				poll.teamName = messageOrPoll.teamName;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *tmpDate = [dateFormat dateFromString:messageOrPoll.receivedDate];
				[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
				poll.receivedDate = [dateFormat stringFromDate:tmpDate];
				[dateFormat release];
				
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
				
				if (messageOrPoll.threadingUsed) {
					
					if ([messageOrPoll.eventType isEqualToString:@"game"]) {
						GameChatter *tmp = [[GameChatter alloc] init];
						tmp.gameId = messageOrPoll.eventId;
						tmp.teamId = messageOrPoll.teamId;
						tmp.startDate = messageOrPoll.eventDate;
						tmp.hideTab = true;
						tmp.title = @"Game Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}else {
						
						PracticeChatter *tmp = [[PracticeChatter alloc] init];
						tmp.practiceId = messageOrPoll.eventId;
						tmp.teamId = messageOrPoll.teamId;
						tmp.startDate = messageOrPoll.eventDate;
						tmp.hideTab = true;
						
						tmp.title = @"Practice Messages";
						[self.navigationController pushViewController:tmp animated:YES];
					}
					
					
					
				}else {
					
					ViewMessageReceived *message = [[ViewMessageReceived alloc] init];
					
					
					if ((self.teamId == nil) || ([self.teamId isEqualToString:@""])) {
						message.teamId = messageOrPoll.teamId;
					}else{
						message.teamId = self.teamId;
					}
					//message.from = messageOrPoll.sender
					message.subject = messageOrPoll.subject;
					message.body = messageOrPoll.body;
                    message.userRole = messageOrPoll.participantRole;
					
					message.confirmStatus = messageOrPoll.status;
					
					NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
					[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
					NSDate *tmpDate = [dateFormat dateFromString:messageOrPoll.receivedDate];
					[dateFormat setDateFormat:@"MMM dd, yyyy hh:mm aa"];
					message.receivedDate = [dateFormat stringFromDate:tmpDate];
					[dateFormat release];
					
					message.wasViewed = messageOrPoll.wasViewed;
					message.threadId = messageOrPoll.threadId;
					message.senderId = messageOrPoll.senderId;
					message.senderName = messageOrPoll.senderName;
					message.teamName = messageOrPoll.teamName;
					
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
			
		}
	
	}else {
		[self.tmpBlack setHidden:YES];
		self.editDone.title = @"Team Filter";
		
		if (row == 0) {
			self.teamId = @"";

			[self.barActivity startAnimating];
			[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
		}else {
			Team *tmpTeam = [self.teamList objectAtIndex:row-1];
			self.teamId = tmpTeam.teamId;
			self.teamName = tmpTeam.name;

			[self.barActivity startAnimating];
			[self performSelectorInBackground:@selector(getAllMessages) withObject:nil];
		}
		
	}


	
}

-(void)getTeamList{
	

	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	self.teamListCount = [NSMutableArray array];

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
		
		
		
	}
	
	[pool drain];

	
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
			
			//NSDictionary *response = [ServerAPI getMessageThreadCount:token :tmpTeam.teamId :@"" :@"" :@""];
			
			NSDictionary *response = [ServerAPI getMessageThreads:token :tmpTeam.teamId :@"inbox" :@"" :@"" :@"both" :@"active"];
			
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


- (void)viewDidUnload {
	
	//results = nil;
	deleteButton = nil;
	deleteActivity = nil;
	//teamName = nil;
	//teamId = nil;
	//userRole = nil;
	//error = nil;
	//pseudoSelectedArray = nil;
	editDone = nil;
	myHeader = nil;
	//threadIdsToArchive = nil;
	//messagesOnlyArray = nil;
	//pollsOnlyArray = nil;
	messageDeleteView = nil;
	cancelDeleteButton = nil;
	deleteMessagesButton = nil;
	messagesTableView = nil;
	teamTable = nil;
	scroll = nil;
	//teamList = nil;
	tmpBlack = nil;
	//teamListCount = nil;
	messageActivity = nil;
	barActivity = nil;
	[super viewDidUnload];


	
}


- (void)dealloc {
	[results release];
	[deleteButton release];
	[deleteActivity release];
	[teamName release];
	[teamId release];
	[userRole release];
	[error release];
	[pseudoSelectedArray release];
	[editDone release];
	[myHeader release];
	[threadIdsToArchive release];
	[messagesOnlyArray release];
	[pollsOnlyArray release];
	[messageDeleteView release];
	[cancelDeleteButton release];
	[deleteMessagesButton release];
	[messagesTableView release];
	[teamTable release];
	[scroll release];
	[teamList release];
	[tmpBlack release];
	[teamListCount release];
	[messageActivity release];
	[messageActivityLabel release];
	[barActivity release];
	[super dealloc];
}

@end
