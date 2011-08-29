//
//  TeamHome.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamHome.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Game.h"
#import "Gameday.h"
#import "GameTabs.h"
#import "GameAttendance.h"
#import "GameMessages.h"
#import "GameEdit.h"
#import "GameTabsNoCoord.h"
#import "TeamActivity.h"
#import "Scores.h"
#import "TeamUrl.h"
#import "Event.h"
#import "Practice.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "PracticeMessages.h"
#import "EventTabs.h"
#import "EventAttendance.h"
#import "EventNotes.h"
#import "Fans.h"
#import "EventMessages.h"
#import "Vote.h"
#import "GameChatter.h"
#import "PracticeChatter.h"
#import "QuartzCore/QuartzCore.h"
#import "Base64.h"
#import "TeamPicture.h"
#import "NewPlayer.h"
#import "NewGamePractice.h"
#import <QuartzCore/QuartzCore.h>

@implementation TeamHome
@synthesize teamId, userRole, teamSport, teamName, nextGameInfoLabel, topRight, topLeft, recentGamesTable, scheduleButton, allScoresButton, 
webPageButton, nextGameButton, teamNameLabel, gamesArray, pastGamesArray, errorLabel, gameSuccess, nextGameArray, teamUrl,
scheduleButtonUnderline, allScoresButtonUnderline, webPageButtonUnderline, nextEventInfoLabel, nextEventButton, eventSuccess, eventsArray,
futureEventsArray, nextEventArray, bannerIsVisible, eventsActivity, touchUpLocation, gestureStartPoint, nextGameLabel, nextEventLabel,
teamInfoThumbnail, noEvents, noGames, eventsAlert, membersAlert, noMembers, displayedMemberAlert, displayedEventAlert, gamesArrayTemp, pastGamesArrayTemp,
displayWarning;

-(void)viewWillDisappear:(BOOL)animated{
	
	displayPhoto = false;
    self.displayWarning = false;
	//self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

-(void)viewDidLoad{

	self.noEvents = false;
	self.noGames = false;
	self.noMembers = false;
	self.displayedEventAlert = false;
	self.displayedMemberAlert = false;
	
	self.gamesArray = [NSMutableArray array];
	self.pastGamesArray = [NSMutableArray array];
	
	[self.view setMultipleTouchEnabled:YES];
	self.scheduleButton.hidden = YES;
	self.scheduleButtonUnderline.hidden = YES;
	self.teamNameLabel.text = @"Team Home";
	
	
	self.recentGamesTable.delegate = self;
	self.recentGamesTable.dataSource = self;
    
    self.recentGamesTable.layer.masksToBounds = YES;
    self.recentGamesTable.layer.cornerRadius = 7.0;
    
	if (self.teamUrl == nil){
		[self.webPageButton setHidden:YES];
		[self.webPageButtonUnderline setHidden:YES];
	}
	if ([self.teamUrl isEqualToString:@""]) {
		[self.webPageButton setHidden:YES];
		[self.webPageButtonUnderline setHidden:YES];
		
	}
	
	NSString *theSport = [self.teamSport lowercaseString];
	
	if ([theSport isEqualToString:@"basketball"]) {
		self.topRight.image = [UIImage imageNamed:@"cellBasketball.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellBasketball.png"];
		
	}else if ([theSport isEqualToString:@"baseball"]) {
		self.topRight.image = [UIImage imageNamed:@"cellBaseball.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellBaseball.png"];
		
	}else if ([theSport isEqualToString:@"soccer"]) {
		self.topRight.image = [UIImage imageNamed:@"cellSoccer.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellSoccer.png"];
		
	}else if ([theSport isEqualToString:@"football"] || [self.teamSport isEqualToString:@"flag football"]) {
		self.topRight.image = [UIImage imageNamed:@"cellFootball.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellFootball.png"];
		
	}else if ([theSport isEqualToString:@"hockey"]) {
		self.topRight.image = [UIImage imageNamed:@"cellHockey.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellHockey.png"];
		
	}else if ([theSport isEqualToString:@"lacrosse"]) {
		self.topRight.image = [UIImage imageNamed:@"cellLacrosse.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellLacrosse.png"];
		
	}else if ([theSport isEqualToString:@"tennis"]) {
		self.topRight.image = [UIImage imageNamed:@"cellTennis.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellTennis.png"];
		
	}else if ([theSport isEqualToString:@"volleyball"]) {
		self.topRight.image = [UIImage imageNamed:@"cellVolleyball.png"];
		self.topLeft.image = [UIImage imageNamed:@"cellVolleyball.png"];
		
	}else if ([theSport isEqualToString:@"development"]) {
		self.topRight.image = [UIImage imageNamed:@"computerCell.png"];
		self.topLeft.image = [UIImage imageNamed:@"computerCell.png"];
	}else {
		self.topLeft.image = [UIImage imageNamed:@"cellOther.png"];
		self.topRight.image = [UIImage imageNamed:@"cellOther.png"];

	}
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.nextGameButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.nextEventButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	myAd.delegate = self;
	myAd.hidden = NO;
	[self.view addSubview:myAd];
    	
}


-(void)viewWillAppear:(BOOL)animated{

	displayPhoto = true;
	self.displayWarning = true;
	[self performSelectorInBackground:@selector(getListOfMembers) withObject:nil];

	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];

	self.nextGameArray = [NSMutableArray array];
	self.title = @"Team Home";
	
	if (myAd != nil) {
		//myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
	
	[self.eventsActivity startAnimating];
	
	[self performSelectorInBackground:@selector(getTeamInfo) withObject:nil];
	[self performSelectorInBackground:@selector(getListOfGames) withObject:nil];
	[self performSelectorInBackground:@selector(getListOfEvents) withObject:nil];
	
	self.nextGameButton.hidden = YES;
	self.nextEventButton.hidden = YES;
}

-(void)changeTeamPicture{

	TeamPicture *tmp = [[TeamPicture alloc] init];
	tmp.userRole = self.userRole;
	tmp.teamId = self.teamId;
	[self.navigationController pushViewController:tmp animated:NO];
}


-(void)getListOfGames{

	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	self.gamesArrayTemp = [NSMutableArray array];
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfGames:self.teamId :token];
		
		NSString *status = [response valueForKey:@"status"];
				
		if ([status isEqualToString:@"100"]){
			
			self.gameSuccess = true;
			self.gamesArrayTemp = [response valueForKey:@"games"];
			
		
			
			
			if ([self.gamesArrayTemp count] == 0) {
				self.noGames = true;
			}
			
			for (int i = 0; i < [self.gamesArrayTemp count]; i++) {
				
				Game *tmpGame = [self.gamesArrayTemp objectAtIndex:i];
				
				if ([tmpGame.interval isEqualToString:@"-4"]) {
					[self.gamesArrayTemp removeObjectAtIndex:i];
					i--;
				}
			}
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			self.gameSuccess = false;
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
					//log status code
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}

	[self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
	[pool drain];
}

-(void)done{
	
	self.gamesArray = self.gamesArrayTemp;
		
	[self.eventsActivity stopAnimating];

	if (self.gameSuccess) {
		
		if (self.noGames && self.noEvents) {
			
			if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
	
				if (!self.displayedEventAlert && !self.displayedMemberAlert) {
					self.displayedEventAlert = true;
					NSString *message1 = @"You have not created any events yet for this team.  Would you like to get things going by adding some events to your team schedule?";
					self.eventsAlert = [[UIAlertView alloc] initWithTitle:@"No Team Events" message:message1 delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Add Events", nil];
                    
                    if (self.displayWarning){
                        [self.eventsAlert show];
                        [self.eventsAlert release];
                    }
				}
				
			}
		}
		
		NSDate *dateNow = [NSDate date];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"yyyy-MM-dd HH:mm"]; 

		bool futureGame = false;
		
		self.pastGamesArrayTemp = [NSMutableArray array];
		for (int i = 0; i < [self.gamesArray count]; i++){
			
			Game *tmp = [self.gamesArray objectAtIndex:i];
			
			NSDate *gameDate = [format dateFromString:tmp.startDate];
			
			
			if ([gameDate isEqualToDate:[gameDate earlierDate:dateNow]]) {
				//if the game is in the past
				
				[self.pastGamesArrayTemp addObject:tmp];
			}else {
				//we have reached the first game in the future
				futureGame = true;
				
				[format setDateFormat:@"MMM dd 'at' hh:mm a"];
				
				self.nextGameInfoLabel.text = [format stringFromDate:gameDate];
				[self.nextGameArray addObject:tmp];
				i = [self.gamesArray count];
			}

			
		}
		[format release];
		
		NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
		[self.pastGamesArrayTemp sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
		[dateSorter release];
        
		self.pastGamesArray = [NSMutableArray arrayWithArray:self.pastGamesArrayTemp];
		
		[self performSelectorInBackground:@selector(getMvpInfo) withObject:nil];
		
		[self.recentGamesTable reloadData];
		
		if (!futureGame) {
			self.nextGameInfoLabel.text = @"*No games scheduled*";
			[self.nextGameButton setHidden:YES];
		}else {
			[self.nextGameButton setHidden:NO];
		}

		
	}else {
		self.errorLabel.text = @"*Error connecting to server";
	}

	
}


-(void)getListOfEvents{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	self.eventsArray = [NSMutableArray array];
	self.futureEventsArray = [NSMutableArray array];
	self.nextEventArray = [NSMutableArray array];
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfEvents:self.teamId :token :@"all"];
		
		NSString *status = [response valueForKey:@"status"];
				
		if ([status isEqualToString:@"100"]){
			
			self.eventSuccess = true;
			self.eventsArray = [response valueForKey:@"events"];
			
			
			if ([self.eventsArray count] == 0) {
				self.noEvents = true;
			}

			for (int i = 0; i < [self.eventsArray count]; i++) {
				
				if ([Event class] == [[self.eventsArray objectAtIndex:i] class]) {
					
					Event *tmpEvent = [self.eventsArray objectAtIndex:i];
					
					if (tmpEvent.isCanceled) {
						[self.eventsArray removeObjectAtIndex:i];
						i--;
					}
				}else if ([Practice class] == [[self.eventsArray objectAtIndex:i] class]) {
					
					Practice *tmpEvent = [self.eventsArray objectAtIndex:i];
					
					if (tmpEvent.isCanceled) {
						[self.eventsArray removeObjectAtIndex:i];
						i--;
					}
				}
			}
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			self.eventSuccess = false;
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
					//log status code
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	[self performSelectorOnMainThread:@selector(doneEvents) withObject:nil waitUntilDone:NO];
	[pool drain];
}

-(void)doneEvents{
	
	[self.eventsActivity stopAnimating];

	
	if (self.eventSuccess) {
		
		if (self.noGames && self.noEvents) {
			
			if (!self.displayedEventAlert && !self.displayedMemberAlert) {
                
                if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
                    
                    self.displayedEventAlert = true;
                    NSString *message1 = @"You have not created any events yet for this team.  Would you like to get things going by adding some events to your team schedule?";
                    self.eventsAlert = [[UIAlertView alloc] initWithTitle:@"No Team Events" message:message1 delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Add Events", nil];
                    if (self.displayWarning){
                        [self.eventsAlert show];
                        [self.eventsAlert release];
                    }
                    
                }
			
			}
		}
		
		NSDate *dateNow = [NSDate date];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		
		for (int i = 0; i < [self.eventsArray count]; i++){
			
			NSDate *gameDate = [NSDate date];
			
			if ([[self.eventsArray objectAtIndex:i] class] == [Practice class]) {
				Practice *tmp = [self.eventsArray objectAtIndex:i];
				gameDate = [format dateFromString:tmp.startDate];
			}
			if ([[self.eventsArray objectAtIndex:i] class] == [Event class]) {
				Event *tmp = [self.eventsArray objectAtIndex:i];
				gameDate = [format dateFromString:tmp.startDate];
			}
			
			if ([dateNow isEqualToDate:[gameDate earlierDate:dateNow]]) {
				//if the game is in the future
				
				[self.futureEventsArray addObject:[self.eventsArray objectAtIndex:i]];
			}
			
			
		}
		
		//sort the futureEventsArray
		NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
		[self.futureEventsArray sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
		[dateSorter release];
		
		
		//Go through the futureEvents Array, if find an "Event", list that, else list first Practice
		bool oneEvent = false;
		if ([self.futureEventsArray count] > 0) {
			
			[self.nextEventButton setHidden:NO];
			
			for (int i = 0; i < [self.futureEventsArray count]; i++){
				
			if ([[self.futureEventsArray objectAtIndex:i] class] == [Event class]) {
				
				oneEvent = true;
				Event *tmp = [self.futureEventsArray objectAtIndex:i];
				[self.nextEventArray addObject:tmp];
				
				[format setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				
					
				NSDate *eventDate = [format dateFromString:tmp.startDate];
						
				[format setDateFormat:@"MMM dd 'at' hh:mm a"];
						
				self.nextEventInfoLabel.text = [format stringFromDate:eventDate];
				break;
			}
				
			}
			
			if (!oneEvent) {
				Practice *tmp = [self.futureEventsArray objectAtIndex:0];
				[self.nextEventArray addObject:tmp];
				
				[format setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				
				
				NSDate *eventDate = [format dateFromString:tmp.startDate];
				
				[format setDateFormat:@"MMM dd 'at' hh:mm a"];
				
				self.nextEventInfoLabel.text = [format stringFromDate:eventDate];
				
			}
			
		}else {
			self.nextEventInfoLabel.text = @"*None scheduled*";
			[self.nextEventButton setHidden:YES];
		}

		[format release];
		
	}else {
		self.nextEventInfoLabel.text = @"*None scheduled*";
		[self.nextEventButton setHidden:YES];

	}

		
	
}




-(void)schedule{
	
	self.tabBarController.selectedIndex = 3;
}

-(void)webPage{
	
	TeamUrl *tmp = [[TeamUrl alloc] init];
	tmp.url = self.teamUrl;
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Team" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)allScores{
	
	Scores *tmp = [[Scores alloc] init];
	tmp.teamId = self.teamId;
	tmp.sport = self.teamSport;
	tmp.teamName = self.teamName;
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)nextEvent{
	
	if ([[self.nextEventArray objectAtIndex:0] class] == [Practice class]) {
		PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
		
		
		Practice *currentPractice = [self.futureEventsArray objectAtIndex:0];
		NSArray *viewControllers = currentPracticeTab.viewControllers;
		currentPracticeTab.teamId = self.teamId;
		currentPracticeTab.practiceId = currentPractice.practiceId;
		currentPracticeTab.userRole = self.userRole;
		
		PracticeNotes *currentNotes = [viewControllers objectAtIndex:0];
		currentNotes.practiceId = currentPractice.practiceId;
		currentNotes.teamId = self.teamId;
		currentNotes.userRole = self.userRole;
		
		PracticeAttendance *currentAttendance = [viewControllers objectAtIndex:1];
		currentAttendance.practiceId = currentPractice.practiceId;
		currentAttendance.teamId = self.teamId;
		currentAttendance.startDate = currentPractice.startDate;
		currentAttendance.userRole = self.userRole;

		PracticeChatter *messages = [viewControllers objectAtIndex:2];
		messages.teamId = self.teamId;
		messages.practiceId = currentPractice.practiceId;
		messages.userRole = self.userRole;
		messages.startDate = currentPractice.startDate;

		
		/*
		PracticeMessages *messages = [viewControllers objectAtIndex:1];
		messages.teamId = self.teamId;
		messages.practiceId = currentPractice.practiceId;
		messages.userRole = self.userRole;
		*/
		
		[self.navigationController pushViewController:currentPracticeTab animated:YES];
		
	}else {
		
		EventTabs *currentPracticeTab = [[EventTabs alloc] init];
		
		
		Event *currentEvent = [self.nextEventArray objectAtIndex:0];
		NSArray *viewControllers = currentPracticeTab.viewControllers;
		currentPracticeTab.teamId = self.teamId;
		currentPracticeTab.eventId = currentEvent.eventId;
		currentPracticeTab.userRole = self.userRole;
		
		EventNotes *currentNotes = [viewControllers objectAtIndex:0];
		currentNotes.eventId = currentEvent.eventId;
		currentNotes.teamId = self.teamId;
		currentNotes.userRole = self.userRole;
		
		EventAttendance *currentAttendance = [viewControllers objectAtIndex:1];
		currentAttendance.eventId = currentEvent.eventId;
		currentAttendance.teamId = self.teamId;
		currentAttendance.startDate = currentEvent.startDate;
		currentAttendance.userRole = self.userRole;

		/*
		EventMessages *messages = [viewControllers objectAtIndex:1];
		messages.teamId = self.teamId;
		messages.eventId = currentEvent.eventId;
		messages.userRole = self.userRole;
		*/
		
		[self.navigationController pushViewController:currentPracticeTab animated:YES];
		
	}

	
}

-(void)nextGame{
	
	Game *currentGame = [self.nextGameArray objectAtIndex:0];
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		GameTabs *currentGameTab = [[GameTabs alloc] init];
		NSArray *viewControllers = currentGameTab.viewControllers;
		currentGameTab.teamId = self.teamId;
		currentGameTab.gameId = currentGame.gameId;
		currentGameTab.userRole = self.userRole;
		currentGameTab.teamName = self.teamName;
		
		Gameday *currentNotes = [viewControllers objectAtIndex:0];
		currentNotes.gameId = currentGame.gameId;
		currentNotes.teamId = self.teamId;
		currentNotes.userRole = self.userRole;
		currentNotes.sport = self.teamSport;
		currentNotes.description = currentGame.description;
		currentNotes.startDate = currentGame.startDate;
		currentNotes.opponentString = currentGame.opponent;
		
		
		/*
		TeamActivity *activity = [viewControllers objectAtIndex:1];
		activity.teamId = self.teamId;
		activity.userRole = self.userRole;
		*/
		
		GameAttendance *currentAttendance = [viewControllers objectAtIndex:2];
		currentAttendance.gameId = currentGame.gameId;
		currentAttendance.teamId = self.teamId;
		currentAttendance.startDate = currentGame.startDate;
		
		GameChatter *messages = [viewControllers objectAtIndex:1];
		messages.gameId = currentGame.gameId;
		messages.teamId = self.teamId;
		messages.userRole = self.userRole;
		messages.startDate = currentGame.startDate;

		
		Vote *fans = [viewControllers objectAtIndex:3];
		fans.teamId = self.teamId;
		fans.userRole = self.userRole;
		fans.gameId = currentGame.gameId;

		[self.navigationController pushViewController:currentGameTab animated:YES];
		
	}else {
		
		GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
		NSArray *viewControllers = currentGameTab.viewControllers;
		currentGameTab.teamId = self.teamId;
		currentGameTab.gameId = currentGame.gameId;
		currentGameTab.userRole = self.userRole;
		currentGameTab.teamName = self.teamName;
		
		/*
		TeamActivity *activity = [viewControllers objectAtIndex:1];
		activity.teamId = self.teamId;
		activity.userRole = self.userRole;
		*/
		
		Gameday *currentNotes = [viewControllers objectAtIndex:0];
		currentNotes.gameId = currentGame.gameId;
		currentNotes.teamId = self.teamId;
		currentNotes.userRole = self.userRole;
		currentNotes.sport = self.teamSport;
		currentNotes.description = currentGame.description;
		currentNotes.startDate = currentGame.startDate;
		currentNotes.opponentString = currentGame.opponent;
		
		
		GameChatter *messages = [viewControllers objectAtIndex:1];
		messages.gameId = currentGame.gameId;
		messages.teamId = self.teamId;
		messages.userRole = self.userRole;
		messages.startDate = currentGame.startDate;

		
		Vote *fans = [viewControllers objectAtIndex:2];
		fans.teamId = self.teamId;
		fans.userRole = self.userRole;
		fans.gameId = currentGame.gameId;

		[self.navigationController pushViewController:currentGameTab animated:YES];
		
	}

	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if ([self.pastGamesArray count] == 0) {
		return 1;
	}
	

	return [self.pastGamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger dateTag = 1;
	static NSInteger resultTag = 2;
	static NSInteger mvpTag = 3;
	static NSInteger mvpNameTag = 5;
	static NSInteger fansTag = 4;
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		CGRect frame;
		
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 17;
		frame.size.width = 300;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		frame.origin.y = 23;
		frame.size.height = 14;
		UILabel *resultLabel = [[UILabel alloc] initWithFrame:frame];
		resultLabel.tag = resultTag;
		[cell.contentView addSubview:resultLabel];
		[resultLabel release];
		
		frame.origin.y = 39;
		frame.size.width = 185;
		UILabel *mvpLabel = [[UILabel alloc] initWithFrame:frame];
		mvpLabel.tag = mvpTag;
		[cell.contentView addSubview:mvpLabel];
		[mvpLabel release];
		
		frame.origin.x += 41;
		frame.origin.y = 39;
		frame.size.width = 185;
		UILabel *mvpNameLabel = [[UILabel alloc] initWithFrame:frame];
		mvpNameLabel.tag = mvpNameTag;
		[cell.contentView addSubview:mvpNameLabel];
		[mvpNameLabel release];
		
		frame.origin.x = 200;
		frame.size.width = 100;
		UILabel *fansLabel = [[UILabel alloc] initWithFrame:frame];
		fansLabel.tag = fansTag;
		[cell.contentView addSubview:fansLabel];
		[fansLabel release];
		
				
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	UILabel *scoreLabel = (UILabel *)[cell.contentView viewWithTag:resultTag];
	UILabel *mvpLabel = (UILabel *)[cell.contentView viewWithTag:mvpTag];
	UILabel *mvpNameLabel = (UILabel *)[cell.contentView viewWithTag:mvpNameTag];

	UILabel *fansLabel = (UILabel *)[cell.contentView viewWithTag:fansTag];
	
	mvpLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	mvpNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];

	fansLabel.font = [UIFont fontWithName:@"Helvetica" size:14];

	mvpLabel.text = @"MVP:";
	fansLabel.text = @"# Fans: 12";
	fansLabel.hidden = YES;
	
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	dateLabel.textColor = [UIColor blackColor];
	
	scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	if ([self.pastGamesArray count] == 0) {
		dateLabel.text = @"No past games...";
		mvpLabel.hidden = YES;
		mvpNameLabel.hidden = YES;
		fansLabel.hidden = YES;
	} else {
		mvpLabel.hidden = NO;
		mvpNameLabel.hidden = NO;
		fansLabel.hidden = YES;
		
		Game *theGame = [self.pastGamesArray objectAtIndex:row];
		
		mvpNameLabel.text = theGame.mvp;
		
		if (theGame.hasMvp) {
			mvpNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
			mvpNameLabel.textColor = [UIColor blackColor];
		}else {
			mvpNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];

			if ([theGame.mvp isEqualToString:@"No Votes"]) {
				mvpNameLabel.textColor = [UIColor blackColor];
			}else {
				mvpNameLabel.textColor = [UIColor blueColor];
			}

		}

		
		NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
		[format1 setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		
		NSDate *gameDate = [format1 dateFromString:theGame.startDate];
		[format1 setDateFormat:@"MMM dd 'at' hh:mm aa"];
		NSString *gameDateString = [format1 stringFromDate:gameDate];
		
        [format1 release];
		dateLabel.text = gameDateString;
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		//Scoring info
		if (theGame.interval != nil) {
			
			if (![theGame.interval isEqualToString:@"0"]) {
				
				
				if ([theGame.interval isEqualToString:@"-1"]) {
					//Game over
					int scoreUs = [theGame.scoreUs intValue];
					int scoreThem = [theGame.scoreThem intValue];
					
					NSString *result = @"";
					
					if (scoreUs > scoreThem) {
						result = @"W";
						scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
						scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
						
					}else if (scoreUs < scoreThem) {
						result = @"L";
						scoreLabel.textColor = [UIColor redColor];
					}else {
						result = @"T";
						scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
						scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
					}
					
					scoreLabel.text = [NSString stringWithFormat:@"%@ %@-%@", result, theGame.scoreUs, theGame.scoreThem];
				}else {
					//Game in progress
					//scoreLabel.textColor = [UIColor colorWithRed:.412 green:.412 blue:.412 alpha:1.0];
					scoreLabel.textColor = [UIColor blueColor];
					
					NSString *time = @"";
					int interval = [theGame.interval intValue];
					
					if (interval == 1) {
						time = @"1st";
					}
					
					if (interval == 2) {
						time = @"2nd";
					}
					
					if (interval == 3) {
						time = @"3rd";
					}
					
					if (interval >= 4) {
						time = [NSString stringWithFormat:@"%@th", theGame.interval];
					}
					
					if (interval == -2) {
						time = @"OT";
					}
					
					
					if (interval == -3) {
						time = @"";
					}
					
					
					scoreLabel.text = [NSString stringWithFormat:@"%@-%@ %@", theGame.scoreUs, theGame.scoreThem, time];
				}
				
			}
		}
		
		
	}

										   

	return cell;
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];

	if ([self.pastGamesArray count] > 0) {
		Game *currentGame = [self.pastGamesArray objectAtIndex:row];
		
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			GameTabs *currentGameTab = [[GameTabs alloc] init];
			NSArray *viewControllers = currentGameTab.viewControllers;
			currentGameTab.teamId = self.teamId;
			currentGameTab.gameId = currentGame.gameId;
			currentGameTab.userRole = self.userRole;
			currentGameTab.teamName = self.teamName;
			
			Gameday *currentNotes = [viewControllers objectAtIndex:0];
			currentNotes.gameId = currentGame.gameId;
			currentNotes.teamId = self.teamId;
			currentNotes.userRole = self.userRole;
			currentNotes.sport = self.teamSport;
			currentNotes.description = currentGame.description;
			currentNotes.startDate = currentGame.startDate;
			currentNotes.opponentString = currentGame.opponent;
			
			/*
			TeamActivity *activity = [viewControllers objectAtIndex:1];
			activity.teamId = self.teamId;
			activity.userRole = self.userRole;
			*/
			
			GameAttendance *currentAttendance = [viewControllers objectAtIndex:2];
			currentAttendance.gameId = currentGame.gameId;
			currentAttendance.teamId = self.teamId;
			currentAttendance.startDate = currentGame.startDate;
			
			GameChatter *messages = [viewControllers objectAtIndex:1];
			messages.gameId = currentGame.gameId;
			messages.teamId = self.teamId;
			messages.userRole = self.userRole;
			messages.startDate = currentGame.startDate;

			
			Vote *fans = [viewControllers objectAtIndex:3];
			fans.teamId = self.teamId;
			fans.userRole = self.userRole;
			fans.gameId = currentGame.gameId;

			[self.navigationController pushViewController:currentGameTab animated:YES];
			
		}else {
			
			GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
			NSArray *viewControllers = currentGameTab.viewControllers;
			currentGameTab.teamId = self.teamId;
			currentGameTab.gameId = currentGame.gameId;
			currentGameTab.userRole = self.userRole;
			currentGameTab.teamName = self.teamName;
			
			/*
			TeamActivity *activity = [viewControllers objectAtIndex:1];
			activity.teamId = self.teamId;
			activity.userRole = self.userRole;
			*/
			
			Gameday *currentNotes = [viewControllers objectAtIndex:0];
			currentNotes.gameId = currentGame.gameId;
			currentNotes.teamId = self.teamId;
			currentNotes.userRole = self.userRole;
			currentNotes.sport = self.teamSport;
			currentNotes.description = currentGame.description;
			currentNotes.startDate = currentGame.startDate;
			currentNotes.opponentString = currentGame.opponent;
	
			
			GameChatter *messages = [viewControllers objectAtIndex:1];
			messages.gameId = currentGame.gameId;
			messages.teamId = self.teamId;
			messages.userRole = self.userRole;
			messages.startDate = currentGame.startDate;

			
			Vote *fans = [viewControllers objectAtIndex:2];
			fans.teamId = self.teamId;
			fans.userRole = self.userRole;
			fans.gameId = currentGame.gameId;

			[self.navigationController pushViewController:currentGameTab animated:YES];
			
		}
		
	}
}

//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	
	if (!self.bannerIsVisible) {
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
		
	if (self.bannerIsVisible) {
		
		//myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
	
	
}

-(void)getMvpInfo{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
		
	for (int i = 0; i < [self.pastGamesArray count]; i++) {
		
		Game *tmpGame = [self.pastGamesArray objectAtIndex:i];
		
		if ([tmpGame.mvp isEqualToString:@""]) {
			
			rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

			NSDictionary *response = [ServerAPI getGameVoteTallies:mainDelegate.token :self.teamId :tmpGame.gameId :@"mvp"];
			
			if ([[response valueForKey:@"status"] isEqualToString:@"100"]) {
				
				NSArray *memberTallies = [response valueForKey:@"memberTallies"];
				
				NSString *newMvp = [self getMvp:memberTallies];
				
				tmpGame.mvp = newMvp;

				[self performSelectorOnMainThread:@selector(doneMvp) withObject:nil waitUntilDone:NO];
				
			
				
			}
		}
		
	}
	
	[pool drain];

}

-(void)doneMvp{
	
	[self.recentGamesTable reloadData];
	
}

-(NSString *)getMvp:(NSArray *)memberTallies{
	
	NSString *returnMvp = @"";
	
	NSString *currentMvp = @"";
	int currentMax = 0;
	
	for (int i = 0; i < [memberTallies count]; i++) {
		
		NSDictionary *tmp = [memberTallies objectAtIndex:i];
		
		int tmpCount = [[tmp valueForKey:@"voteCount"] intValue];
		
		if (tmpCount > currentMax) {
			currentMax = tmpCount;
			currentMvp = [tmp valueForKey:@"memberName"];
		}
	}
	
	if (currentMax == 0) {
		returnMvp = @"No Votes";
	}else {
		returnMvp = currentMvp;
	}

	
	return returnMvp;
	
}

	
-(void)getTeamInfo{
	
	NSAutoreleasePool * pool;
	
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		NSDictionary *response = [ServerAPI getTeamInfo:self.teamId :token :@"false"];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			NSDictionary *tmpDictionary = [response valueForKey:@"teamInfo"];
			
			self.teamInfoThumbnail = @"";
			
			self.teamInfoThumbnail = [tmpDictionary valueForKey:@"thumbNail"];
									
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			//[self.errorLabel setHidden:NO];
			switch (statusCode) {
				case 0:
					//null parameter
					//self.errorLabel.text = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.errorLabel.text = @"*Error connecting to server";
					break;
				default:
					//log status code?
					//self.errorLabel.text = @"*Error connecting to server";
					break;
			}
		}
	}
	
	
	[self performSelectorOnMainThread:@selector(doneInfo) withObject:nil waitUntilDone:NO];
	
	[pool drain];
	

}

-(void)doneInfo{
	
	bool realImage = false;
	NSString *imageString = @"";
	if (self.teamInfoThumbnail != nil) {
		
		if (![self.teamInfoThumbnail isEqualToString:@""]) {
			realImage = true;
			imageString = self.teamInfoThumbnail;
		}
	}
	
	if (realImage) {
			
			
			UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 44)];
			backView.backgroundColor = [UIColor clearColor];
			
			UIButton *teamPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[teamPictureButton addTarget:self action:@selector(changeTeamPicture) forControlEvents:UIControlEventTouchUpInside];
			teamPictureButton.frame = CGRectMake(0, 0, 62, 44);
			teamPictureButton.backgroundColor = [UIColor clearColor];
			
			UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 45, 35)];
			blackView.backgroundColor = [UIColor blackColor];
			UIImageView *teamImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 41, 31)];

			NSData *tmpData = [Base64 decode:imageString];
			teamImage.image = [UIImage imageWithData:tmpData];
        
        
        if (teamImage.image.size.height >= teamImage.image.size.width) {
            teamImage.frame = CGRectMake(2, 2, 31, 31);
            blackView.frame = CGRectMake(5, 5, 35, 35);
        }
			
			
			[blackView addSubview:teamImage];
        [teamImage release];
			
			[backView addSubview:blackView];
			[backView addSubview:teamPictureButton];
			
			
			teamImage.layer.masksToBounds = YES;
			teamImage.layer.cornerRadius = 3.0;
			blackView.layer.masksToBounds = YES;
			blackView.layer.cornerRadius = 3.0;
			
			UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
        [backView release];
			
		if (displayPhoto) {
			[self.tabBarController.navigationItem setLeftBarButtonItem:teamPicture];

		}
        [teamPicture release];
			
			
	}else {
		
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			
			
			
			UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
			tmpButton.frame = CGRectMake(2, 2, 44, 44);
			[tmpButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
			[tmpButton addTarget:self action:@selector(changeTeamPicture) forControlEvents:UIControlEventTouchUpInside];
			
			UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
			//UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changeTeamPicture)];
			
			
			if (displayPhoto) {
				[self.tabBarController.navigationItem setLeftBarButtonItem:teamPicture];
			}
            [teamPicture release];
			
		}else {
			[self.tabBarController.navigationItem setLeftBarButtonItem:nil];

		}


		
	}


	
		
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView == self.eventsAlert) {
		
		if (buttonIndex == 0) {
			
		}else {
			
			NewGamePractice *nextController = [[NewGamePractice alloc] init];
			nextController.teamId = self.teamId;
			[self.navigationController pushViewController:nextController animated:YES];	
			
		}

	}else if (alertView == self.membersAlert) {
		
		if (buttonIndex == 0) {
			
		}else {
			
			NewPlayer *nextController = [[NewPlayer alloc] init];
			nextController.teamId = self.teamId;
			nextController.userRole = self.userRole;
			[self.navigationController pushViewController:nextController animated:YES];
			
		}

	}
}

-(void)getListOfMembers{
	
	NSAutoreleasePool * pool;
	
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		NSDictionary *response = [ServerAPI getListOfTeamMembers:self.teamId :token :@"" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			NSArray *memberArray = [response valueForKey:@"members"];
			
			
			if ([memberArray count] <= 1) {
				self.noMembers = true;
			}
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			//[self.errorLabel setHidden:NO];
			switch (statusCode) {
				case 0:
					//null parameter
					//self.errorLabel.text = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.errorLabel.text = @"*Error connecting to server";
					break;
				default:
					//log status code?
					//self.errorLabel.text = @"*Error connecting to server";
					break;
			}
		}
	}
	
	
	[self performSelectorOnMainThread:@selector(doneMembers) withObject:nil waitUntilDone:NO];
	
	[pool drain];
	
	
}

-(void)doneMembers{
	
	if (self.noMembers) {
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			
			if (!self.displayedMemberAlert && !self.displayedEventAlert) {
				self.displayedMemberAlert = true;
				NSString *message1 = @"You have not added any Members to this team yet.  Would you like to get things going by adding some members to your team roster?";
				self.membersAlert = [[UIAlertView alloc] initWithTitle:@"No Team Members" message:message1 delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Add Members", nil];
				if (self.displayWarning){
                    [self.membersAlert show];
                    [self.membersAlert release];
                }
			}
			
		}
		
		
		
	}
}

-(void)viewDidUnload{

	errorLabel = nil;
	teamNameLabel = nil;
	nextGameInfoLabel = nil;
	topRight = nil;
	topLeft = nil;
	recentGamesTable = nil;
	scheduleButton = nil;
	allScoresButton = nil;
	webPageButton = nil;
	scheduleButtonUnderline = nil;
	allScoresButtonUnderline = nil;
	webPageButtonUnderline = nil;
	nextGameButton = nil;
	nextEventInfoLabel = nil;
	nextEventButton = nil;
	eventsActivity = nil;
	nextGameLabel = nil;
	nextEventLabel = nil;

	[super viewDidUnload];
}
-(void)dealloc{
	[teamId release];
	[userRole release];
	[teamSport release];
	[teamName release];
	[nextGameInfoLabel release];
	[topRight release];
	[topLeft release];
	[recentGamesTable release];
	[scheduleButton release];
	[allScoresButton release];
	[webPageButton release];
	[nextGameButton release];
	[teamNameLabel release];
	[gamesArray release];
	[pastGamesArray release];
	[errorLabel release];
	[nextGameArray release];
	[teamUrl release];
	[scheduleButtonUnderline release];
	[allScoresButtonUnderline release];
	[webPageButtonUnderline release];
	[nextEventButton release];
	[nextEventInfoLabel release];
	[eventsArray release];
	[futureEventsArray release];
	[nextEventArray release];
	[eventsActivity release];
	[myAd release];
	[nextGameLabel release];
	[nextEventLabel release];
	[teamInfoThumbnail release];
	[eventsAlert release];
	[membersAlert release];
	[pastGamesArrayTemp release];
	[gamesArrayTemp release];
	[super dealloc];
	
}


@end
