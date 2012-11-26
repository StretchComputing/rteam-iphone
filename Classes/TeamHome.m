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
#import "GameEdit.h"
#import "GameTabsNoCoord.h"
#import "Scores.h"
#import "Event.h"
#import "Practice.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "EventTabs.h"
#import "EventAttendance.h"
#import "EventNotes.h"
#import "Vote.h"
#import "QuartzCore/QuartzCore.h"
#import "Base64.h"
#import "TeamPicture.h"
#import "NewPlayer.h"
#import <QuartzCore/QuartzCore.h>
#import "TeamEdit.h"
#import "TraceSession.h"
#import "TeamEditFan.h"
#import "GoogleAppEngine.h"
#import "SelectCalendarEvent.h"

@implementation TeamHome
@synthesize teamId, userRole, teamSport, teamName, nextGameInfoLabel, topRight, topLeft, recentGamesTable, allScoresButton, nextGameButton, teamNameLabel, gamesArray, pastGamesArray, errorLabel, gameSuccess, nextGameArray, teamUrl, allScoresButtonUnderline, nextEventInfoLabel, nextEventButton, eventSuccess, eventsArray,
futureEventsArray, nextEventArray, bannerIsVisible, eventsActivity, touchUpLocation, gestureStartPoint, nextGameLabel, nextEventLabel,
teamInfoThumbnail, noEvents, noGames, eventsAlert, membersAlert, noMembers, displayedMemberAlert, displayedEventAlert, gamesArrayTemp, pastGamesArrayTemp,
displayWarning, myAd, displayPhoto, editButton, fromHome, addMembersButton, addEventsButton, recentGamesLabel, largeActivity, doneMembers, doneGames, doneEvents, noEventsLabel, recordLabel, recordString, pastGame, futureGame, pastGameLabel, futureGameLabel;


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

	self.teamNameLabel.text = @"Team Home";
	
	
	self.recentGamesTable.delegate = self;
	self.recentGamesTable.dataSource = self;
    
    self.recentGamesTable.layer.masksToBounds = YES;
    self.recentGamesTable.layer.cornerRadius = 7.0;
    
	
	
		
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.nextGameButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.nextEventButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addMembersButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addEventsButton setBackgroundImage:stretch forState:UIControlStateNormal];


    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    self.allScoresButton.hidden = YES;
    self.allScoresButtonUnderline.hidden = YES;
    self.recentGamesLabel.hidden = YES;
    self.recentGamesTable.hidden = YES;
    
    self.addMembersButton.hidden = YES;
    self.noEventsLabel.hidden = YES;

    self.addEventsButton.hidden = YES;
    self.doneMembers = false;
    self.doneGames = false;
    self.doneEvents = false;

    	
}


-(void)viewWillAppear:(BOOL)animated{

    [TraceSession addEventToSession:@"TeamHome - View Will Appear"];

    
    NSString *theSport = [self.teamSport lowercaseString];
    
	if ([theSport isEqualToString:@"basketball"]) {
		self.topRight.image = [UIImage imageNamed:@"basketballOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"basketballOnly.png"];
		
	}else if ([theSport isEqualToString:@"baseball"] || [theSport isEqualToString:@"softball"]) {
		self.topRight.image = [UIImage imageNamed:@"baseballOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"baseballOnly.png"];
		
	}else if ([theSport isEqualToString:@"soccer"]) {
		self.topRight.image = [UIImage imageNamed:@"soccerOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"soccerOnly.png"];
		
	}else if ([theSport isEqualToString:@"football"] || [self.teamSport isEqualToString:@"flag football"]) {
		self.topRight.image = [UIImage imageNamed:@"footballOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"footballOnly.png"];
		
	}else if ([theSport isEqualToString:@"hockey"]) {
		self.topRight.image = [UIImage imageNamed:@"hockeyOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"hockeyOnly.png"];
		
	}else if ([theSport isEqualToString:@"lacrosse"]) {
		self.topRight.image = [UIImage imageNamed:@"lacrosseOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"lacrosseOnly.png"];
		
	}else if ([theSport isEqualToString:@"tennis"]) {
		self.topRight.image = [UIImage imageNamed:@"tennisOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"tennisOnly.png"];
		
	}else if ([theSport isEqualToString:@"volleyball"]) {
		self.topRight.image = [UIImage imageNamed:@"volleyballOnly.png"];
		self.topLeft.image = [UIImage imageNamed:@"volleyballOnly.png"];
		
	}else if ([theSport isEqualToString:@"development"]) {
		self.topRight.image = [UIImage imageNamed:@"computerCell.png"];
		self.topLeft.image = [UIImage imageNamed:@"computerCell.png"];
	}else {
		self.topLeft.image = [UIImage imageNamed:@"gen80.png"];
		self.topRight.image = [UIImage imageNamed:@"gen80.png"];
        
	}

    
    self.futureGame.view.hidden = YES;
    self.pastGame.view.hidden = YES;
    

   
    
	displayPhoto = true;
	self.displayWarning = true;
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTeam)];
    [self.tabBarController.navigationItem setRightBarButtonItem:edit];

	self.nextGameArray = [NSMutableArray array];
	self.title = @"Team Home";
	
	if (myAd.bannerLoaded) {
        myAd.hidden = NO;
    }else{
        myAd.hidden = YES;
    }
	
	[self.eventsActivity startAnimating];
	
    [self.largeActivity startAnimating];
	[self performSelectorInBackground:@selector(getTeamInfo) withObject:nil];
    self.recordLabel.hidden = YES;
	[self performSelectorInBackground:@selector(getListOfGames) withObject:nil];
	
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

	@autoreleasepool {
    
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
                
                int win = 0;
                int loss = 0;
                int tie = 0;
                self.recordString = @"";
                
                for (int i = 0; i < [self.gamesArrayTemp count]; i++) {
                    
                    Game *tmpGame = (self.gamesArrayTemp)[i];
                    
                    if ([tmpGame.interval isEqualToString:@"-4"]) {
                        [self.gamesArrayTemp removeObjectAtIndex:i];
                        i--;
                    }
                    
                    if ([tmpGame.interval isEqualToString:@"-1"]) {
                        
                        if ([tmpGame.scoreUs intValue] > [tmpGame.scoreThem intValue]) {
                            win++;
                        }else if ([tmpGame.scoreThem intValue] > [tmpGame.scoreUs intValue]) {
                            loss++;
                        }else{
                            tie++;
                        }
                    }
                }
                
                if (tie > 0) {
                    self.recordString = [NSString stringWithFormat:@"Record: %d-%d-%d", win, loss, tie];

                }else{
                    self.recordString = [NSString stringWithFormat:@"Record: %d-%d", win, loss];

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
        
        [self performSelectorOnMainThread:@selector(doneGetGames) withObject:nil waitUntilDone:NO];

	
    }
}

-(void)doneGetGames{
	
    @try {
        self.doneGames = true;
        self.gamesArray = [NSMutableArray arrayWithArray:self.gamesArrayTemp];
		
        [self.eventsActivity stopAnimating];
        [self.largeActivity stopAnimating];
        
        if (self.gameSuccess) {
            
            if ([self.gamesArray count] > 0) {
                
                self.recordLabel.hidden = NO;
                self.recordLabel.text = [NSString stringWithFormat:self.recordString];
                
                
                NSDate *dateNow = [NSDate date];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                
                bool futureGame1 = false;
                
                self.pastGamesArrayTemp = [NSMutableArray array];
                for (int i = 0; i < [self.gamesArray count]; i++){
                    
                    Game *tmp = (self.gamesArray)[i];
                    
                    NSDate *gameDate = [format dateFromString:tmp.startDate];
                    
                    
                    if ([gameDate isEqualToDate:[gameDate earlierDate:dateNow]]) {
                        //if the game is in the past
                        
                        [self.pastGamesArrayTemp addObject:tmp];
                    }else {
                        //we have reached the first game in the future
                        futureGame1 = true;
                        
                        [format setDateFormat:@"MMM dd 'at' hh:mm a"];
                        
                        self.nextGameInfoLabel.text = [format stringFromDate:gameDate];
                        [self.nextGameArray addObject:tmp];
                        i = [self.gamesArray count];
                    }
                    
                    
                }
                
                NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
                [self.pastGamesArrayTemp sortUsingDescriptors:@[dateSorter]];
                
                
                if ([self.pastGamesArrayTemp count] > 0) {
                    
                    //Mmost recent past game is at pastGamesARrayTemp index 0
                    //Next future game is at nextGameArray index 0
                    
                    NSDate *checkToday = [NSDate date];
                    NSDateFormatter *newDateFormat = [[NSDateFormatter alloc] init];
                    
                    [newDateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                    
                    Game *tmpGame = (self.pastGamesArrayTemp)[0];
                    NSDate *checkGame = [newDateFormat dateFromString:tmpGame.startDate];
                    
                    NSTimeInterval timeInterval = [checkToday timeIntervalSinceDate:checkGame];
                    
                    if (timeInterval <= 43200) {
                        //if the game started within the last 12 hrs, and the interval says its in progress, move it to the next game array
                        
                        int checkInterval = [tmpGame.interval intValue];
                        if (checkInterval > 0) {
                            self.nextGameArray = [NSMutableArray arrayWithObject:tmpGame];
                            [self.pastGamesArrayTemp removeObjectAtIndex:0];
                            
                        }
                    }
                    
                    
                }
                
                [self.futureGameLabel removeFromSuperview];
                [self.pastGameLabel removeFromSuperview];
                
                self.futureGameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 25)];
                self.futureGameLabel.textAlignment = UITextAlignmentCenter;
                self.futureGameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                self.futureGameLabel.backgroundColor = [UIColor clearColor];
                [self.view addSubview:self.futureGameLabel];
                
                self.pastGameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 320, 25)];
                self.pastGameLabel.textAlignment = UITextAlignmentCenter;
                self.pastGameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
                self.pastGameLabel.backgroundColor = [UIColor clearColor];
                [self.view addSubview:self.pastGameLabel];
                
                if (futureGame1) {
                    //There is a future Game
                    Game *tmpGame = (self.nextGameArray)[0];
                    
                    self.futureGame = [[BoxScoreViewViewController alloc] init];
                    self.futureGame.view.frame = CGRectMake(15, 130, 290, 65);
                    self.futureGame.scoreUs.text = [NSString stringWithString:tmpGame.scoreUs];
                    self.futureGame.scoreThem.text = [NSString stringWithString:tmpGame.scoreThem];
                    self.futureGame.nameUs.text = [NSString stringWithString:self.teamName];
                    
                    futureGameLabel.text = @"Next Game:";
                    
                    UIButton *futureGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    futureGameButton.frame = CGRectMake(0, 0, 250, 60);
                    [futureGameButton addTarget:self action:@selector(nextGame) forControlEvents:UIControlEventTouchUpInside];
                    [self.futureGame.view addSubview:futureGameButton];
                    
                    if ([tmpGame.interval isEqualToString:@"0"]) {
                        //interval is the date
                        
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                        NSDate *eventDate = [dateFormat dateFromString:tmpGame.startDate];
                        [dateFormat setDateFormat:@"MM/dd hh:mm"];
                        self.futureGame.interval.text = [dateFormat stringFromDate:eventDate];
                        
                        self.futureGame.scoreUs.text = @"-";
                        self.futureGame.scoreThem.text = @"-";
                        
                        
                    }else{
                        self.futureGame.interval.text = [self getIntervalLabelFromInterval:tmpGame.interval];
                        
                        if (![tmpGame.interval isEqualToString:@"-1"]) {
                            //Game is in progress!
                            futureGameLabel.text = @"Game in progress!";
                            
                        }else{
                            
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                            NSDate *eventDate = [dateFormat dateFromString:tmpGame.startDate];
                            [dateFormat setDateFormat:@"MM/dd hh:mm"];
                            self.futureGame.interval.text = [dateFormat stringFromDate:eventDate];
                            
                            
                        }
                    }
                    
                    if (![tmpGame.opponent isEqualToString:@""]) {
                        self.futureGame.nameThem.text = [NSString stringWithString:tmpGame.opponent];
                    }else{
                        self.futureGame.nameThem.text = @"Opponent";
                    }
                    [self.view addSubview:self.futureGame.view];
                    
                    
                    
                }else{
                    futureGameLabel.text = @"No future games found...";
                    
                    self.futureGame = [[BoxScoreViewViewController alloc] init];
                    self.futureGame.view.frame = CGRectMake(15, 130, 290, 65);
                    self.futureGame.scoreUs.text = @"-";
                    self.futureGame.scoreThem.text = @"-";
                    self.futureGame.nameUs.text = [NSString stringWithString:self.teamName];
                    self.futureGame.nameThem.text = @"Opponent TBD";
                    self.futureGame.interval.text = @"-";
                    
                    
                    [self.view addSubview:self.futureGame.view];
                    
                    
                }
                
                if ([self.pastGamesArrayTemp count] > 0) {
                    //There is a most recent game at index 0
                    
                    Game *tmpGame = (self.pastGamesArrayTemp)[0];
                    
                    self.pastGame = [[BoxScoreViewViewController alloc] init];
                    self.pastGame.view.frame = CGRectMake(35, 260, 250, 60);
                    self.pastGame.frontView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
                    self.pastGame.scoreUs.text = [NSString stringWithString:tmpGame.scoreUs];
                    self.pastGame.scoreThem.text = [NSString stringWithString:tmpGame.scoreThem];
                    self.pastGame.nameUs.text = [NSString stringWithString:self.teamName];
                    
                    self.pastGame.nameUs.textColor = [UIColor darkGrayColor];
                    self.pastGame.nameThem.textColor = [UIColor darkGrayColor];
                    
                    pastGameLabel.text = @"Most Recent Game:";
                    
                    UIButton *pastGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    pastGameButton.frame = CGRectMake(0, 0, 250, 60);
                    [pastGameButton addTarget:self action:@selector(previousGame) forControlEvents:UIControlEventTouchUpInside];
                    [self.pastGame.view addSubview:pastGameButton];
                    
                    if ([tmpGame.interval isEqualToString:@"0"]) {
                        //interval is the date
                        
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                        NSDate *eventDate = [dateFormat dateFromString:tmpGame.startDate];
                        [dateFormat setDateFormat:@"MM/dd"];
                        self.pastGame.interval.text = [dateFormat stringFromDate:eventDate];
                        
                        self.pastGame.scoreUs.text = @"-";
                        self.pastGame.scoreThem.text = @"-";
                        
                    }else{
                        self.pastGame.interval.text = [self getIntervalLabelFromInterval:tmpGame.interval];
                        
                        if (![tmpGame.interval isEqualToString:@"-1"]) {
                            //Game is in progress!
                            pastGameLabel.text = @"Game in progress!";
                            
                        }else{
                            
                            //Game is final
                            UILabel *finalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 250, 40)];
                            finalLabel.backgroundColor = [UIColor clearColor];
                            finalLabel.textAlignment = UITextAlignmentCenter;
                            finalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
                            
                            
                            int scoreu = [tmpGame.scoreUs intValue];
                            int scoret = [tmpGame.scoreThem intValue];
                            
                            if (scoreu > scoret) {
                                finalLabel.text = @"W";
                                finalLabel.textColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
                            }else if (scoret > scoreu){
                                finalLabel.text = @"L";
                                finalLabel.textColor = [UIColor redColor];
                            }else{
                                finalLabel.text = @"T";
                                finalLabel.textColor = [UIColor blueColor];
                            }
                            
                            [self.pastGame.view addSubview:finalLabel];
                            
                            CGRect frame = self.pastGame.interval.frame;
                            frame.origin.y +=20;
                            self.pastGame.interval.font = [UIFont fontWithName:@"Helvetica" size:14];
                            self.pastGame.interval.frame = frame;
                            
                        }
                    }
                    
                    if (![tmpGame.opponent isEqualToString:@""]) {
                        self.pastGame.nameThem.text = [NSString stringWithString:tmpGame.opponent];
                    }else{
                        self.pastGame.nameThem.text = @"Opponent";
                    }
                    [self.view addSubview:self.pastGame.view];
                    
                    
                }else{
                    
                    pastGameLabel.text = @"No past games found...";
                    
                    
                    self.pastGame = [[BoxScoreViewViewController alloc] init];
                    self.pastGame.view.frame = CGRectMake(35, 260, 250, 60);
                    self.pastGame.frontView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
                    self.pastGame.scoreUs.text = [NSString stringWithString:@"-"];
                    self.pastGame.scoreThem.text = [NSString stringWithString:@"-"];
                    self.pastGame.nameUs.text = [NSString stringWithString:self.teamName];
                    self.pastGame.interval.text = @"-";
                    self.pastGame.nameThem.text = @"No Opponent";
                    self.pastGame.nameUs.textColor = [UIColor darkGrayColor];
                    self.pastGame.nameThem.textColor = [UIColor darkGrayColor];

                    
                    [self.view addSubview:self.pastGame.view];
                    
                }
                
                
                self.addMembersButton.hidden = YES;
                self.noEventsLabel.hidden = YES;
                
                self.addEventsButton.hidden = YES;
            }else{
                
                if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
                    self.addMembersButton.hidden = NO;
                    self.noEventsLabel.hidden = NO;
                    
                    self.addEventsButton.hidden = NO;
                }else{
                    self.noEventsLabel.hidden = NO;
                    self.noEventsLabel.text = @"Your team has no scheduled games...";
                }
                
            }
            
            
            
            
            
            
        }else {
            self.errorLabel.text = @"*Error connecting to server";
        }

    }
    @catch (NSException *exception) {
    
        
        [GoogleAppEngine sendClientLog:@"TeamHome.m - doneGetGames()" logMessage:[exception reason] logLevel:@"exception" exception:exception];

        
        
        
    }
   
	
}






-(void)schedule{
	
	self.tabBarController.selectedIndex = 3;
}

/*
-(void)webPage{
	
	TeamUrl *tmp = [[TeamUrl alloc] init];
	tmp.url = self.teamUrl;
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Team" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:YES];
}
*/

-(void)allScores{
	
	Scores *tmp = [[Scores alloc] init];
	tmp.teamId = self.teamId;
	tmp.sport = self.teamSport;
	tmp.teamName = self.teamName;
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)nextEvent{
	
    if ([self.nextEventArray count] > 0) {
        if ([(self.nextEventArray)[0] class] == [Practice class]) {
            PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
            
            
            Practice *currentPractice = (self.futureEventsArray)[0];
            NSArray *viewControllers = currentPracticeTab.viewControllers;
            currentPracticeTab.teamId = self.teamId;
            currentPracticeTab.practiceId = currentPractice.practiceId;
            currentPracticeTab.userRole = self.userRole;
            
            PracticeNotes *currentNotes = viewControllers[0];
            currentNotes.practiceId = currentPractice.practiceId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            
            PracticeAttendance *currentAttendance = viewControllers[1];
            currentAttendance.practiceId = currentPractice.practiceId;
            currentAttendance.teamId = self.teamId;
            currentAttendance.startDate = currentPractice.startDate;
            currentAttendance.userRole = self.userRole;
            
            
            [self.navigationController pushViewController:currentPracticeTab animated:YES];
            
        }else {
            
            EventTabs *currentPracticeTab = [[EventTabs alloc] init];
            
            
            Event *currentEvent = (self.nextEventArray)[0];
            NSArray *viewControllers = currentPracticeTab.viewControllers;
            currentPracticeTab.teamId = self.teamId;
            currentPracticeTab.eventId = currentEvent.eventId;
            currentPracticeTab.userRole = self.userRole;
            
            EventNotes *currentNotes = viewControllers[0];
            currentNotes.eventId = currentEvent.eventId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            
            EventAttendance *currentAttendance = viewControllers[1];
            currentAttendance.eventId = currentEvent.eventId;
            currentAttendance.teamId = self.teamId;
            currentAttendance.startDate = currentEvent.startDate;
            currentAttendance.userRole = self.userRole;
            
            
            [self.navigationController pushViewController:currentPracticeTab animated:YES];
            
        }
    }

	
}


-(void)previousGame{
    
    if ([self.pastGamesArrayTemp count] > 0) {
        Game *currentGame = (self.pastGamesArrayTemp)[0];
        
        if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
            GameTabs *currentGameTab = [[GameTabs alloc] init];
            NSArray *viewControllers = currentGameTab.viewControllers;
            currentGameTab.teamId = self.teamId;
            currentGameTab.gameId = currentGame.gameId;
            currentGameTab.userRole = self.userRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = viewControllers[0];
            currentNotes.gameId = currentGame.gameId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            currentNotes.sport = self.teamSport;
            currentNotes.description = currentGame.description;
            currentNotes.startDate = currentGame.startDate;
            currentNotes.opponentString = currentGame.opponent;
            
            GameAttendance *currentAttendance = viewControllers[1];
            currentAttendance.gameId = currentGame.gameId;
            currentAttendance.teamId = self.teamId;
            currentAttendance.startDate = currentGame.startDate;
            
            
            
            
            Vote *fans = viewControllers[2];
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
            
            Gameday *currentNotes = viewControllers[0];
            currentNotes.gameId = currentGame.gameId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            currentNotes.sport = self.teamSport;
            currentNotes.description = currentGame.description;
            currentNotes.startDate = currentGame.startDate;
            currentNotes.opponentString = currentGame.opponent;
            
            
            
            Vote *fans = viewControllers[1];
            fans.teamId = self.teamId;
            fans.userRole = self.userRole;
            fans.gameId = currentGame.gameId;
            
            [self.navigationController pushViewController:currentGameTab animated:YES];
            
        }
        
    }

    
}
-(void)nextGame{
	
	if ([self.nextGameArray count] > 0) {
        Game *currentGame = (self.nextGameArray)[0];
        
        if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
            
            
            GameTabs *currentGameTab = [[GameTabs alloc] init];
            
            NSArray *viewControllers = currentGameTab.viewControllers;
            currentGameTab.teamId = self.teamId;
            currentGameTab.gameId = currentGame.gameId;
            currentGameTab.userRole = self.userRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = viewControllers[0];
            currentNotes.gameId = currentGame.gameId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            currentNotes.sport = self.teamSport;
            currentNotes.description = currentGame.description;
            currentNotes.startDate = currentGame.startDate;
            currentNotes.opponentString = currentGame.opponent;
            
            GameAttendance *currentAttendance = viewControllers[1];
            currentAttendance.gameId = currentGame.gameId;
            currentAttendance.teamId = self.teamId;
            currentAttendance.startDate = currentGame.startDate;
            
            
            
            
            Vote *fans = viewControllers[2];
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
            
            Gameday *currentNotes = viewControllers[0];
            currentNotes.gameId = currentGame.gameId;
            currentNotes.teamId = self.teamId;
            currentNotes.userRole = self.userRole;
            currentNotes.sport = self.teamSport;
            currentNotes.description = currentGame.description;
            currentNotes.startDate = currentGame.startDate;
            currentNotes.opponentString = currentGame.opponent;
            
            
            
            Vote *fans = viewControllers[1];
            fans.teamId = self.teamId;
            fans.userRole = self.userRole;
            fans.gameId = currentGame.gameId;
            
            [self.navigationController pushViewController:currentGameTab animated:YES];
            
        }

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 17;
		frame.size.width = 300;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		frame.origin.y = 23;
		frame.size.height = 14;
		UILabel *resultLabel = [[UILabel alloc] initWithFrame:frame];
		resultLabel.tag = resultTag;
		[cell.contentView addSubview:resultLabel];
		
		frame.origin.y = 39;
		frame.size.width = 185;
		UILabel *mvpLabel = [[UILabel alloc] initWithFrame:frame];
		mvpLabel.tag = mvpTag;
		[cell.contentView addSubview:mvpLabel];
		
		frame.origin.x += 41;
		frame.origin.y = 39;
		frame.size.width = 185;
		UILabel *mvpNameLabel = [[UILabel alloc] initWithFrame:frame];
		mvpNameLabel.tag = mvpNameTag;
		[cell.contentView addSubview:mvpNameLabel];
		
		frame.origin.x = 200;
		frame.size.width = 100;
		UILabel *fansLabel = [[UILabel alloc] initWithFrame:frame];
		fansLabel.tag = fansTag;
		[cell.contentView addSubview:fansLabel];
		
				
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
		
		Game *theGame = (self.pastGamesArray)[row];
		
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
	
    [TraceSession addEventToSession:@"Team Home Page - Game Row Clicked"];

    
	int row = [indexPath row];

	if ([self.pastGamesArray count] > 0) {
		Game *currentGame = (self.pastGamesArray)[row];
		
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			GameTabs *currentGameTab = [[GameTabs alloc] init];
			NSArray *viewControllers = currentGameTab.viewControllers;
			currentGameTab.teamId = self.teamId;
			currentGameTab.gameId = currentGame.gameId;
			currentGameTab.userRole = self.userRole;
			currentGameTab.teamName = self.teamName;
			
			Gameday *currentNotes = viewControllers[0];
			currentNotes.gameId = currentGame.gameId;
			currentNotes.teamId = self.teamId;
			currentNotes.userRole = self.userRole;
			currentNotes.sport = self.teamSport;
			currentNotes.description = currentGame.description;
			currentNotes.startDate = currentGame.startDate;
			currentNotes.opponentString = currentGame.opponent;
			
		
			GameAttendance *currentAttendance = viewControllers[1];
			currentAttendance.gameId = currentGame.gameId;
			currentAttendance.teamId = self.teamId;
			currentAttendance.startDate = currentGame.startDate;
			
		

			
			Vote *fans = viewControllers[2];
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
			
	
			
			Gameday *currentNotes = viewControllers[0];
			currentNotes.gameId = currentGame.gameId;
			currentNotes.teamId = self.teamId;
			currentNotes.userRole = self.userRole;
			currentNotes.sport = self.teamSport;
			currentNotes.description = currentGame.description;
			currentNotes.startDate = currentGame.startDate;
			currentNotes.opponentString = currentGame.opponent;
	
	

			
			Vote *fans = viewControllers[1];
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
		
        myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
	
	
}

-(void)getMvpInfo{

    @autoreleasepool {
        for (int i = 0; i < [self.pastGamesArray count]; i++) {
            
            Game *tmpGame = (self.pastGamesArray)[i];
            
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

    }
		
	
}

-(void)doneMvp{
	
	[self.recentGamesTable reloadData];
	
}

-(NSString *)getMvp:(NSArray *)memberTallies{
	
	NSString *returnMvp = @"";
	
	NSString *currentMvp = @"";
	int currentMax = 0;
	
	for (int i = 0; i < [memberTallies count]; i++) {
		
		NSDictionary *tmp = memberTallies[i];
		
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

	@autoreleasepool {
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

    }
		
	

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
			
			[backView addSubview:blackView];
			[backView addSubview:teamPictureButton];
			
			
			teamImage.layer.masksToBounds = YES;
			teamImage.layer.cornerRadius = 3.0;
			blackView.layer.masksToBounds = YES;
			blackView.layer.cornerRadius = 3.0;
			
			//UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
			
		if (displayPhoto) {
			//[self.tabBarController.navigationItem setRightBarButtonItem:teamPicture];

		}
			
			
	}else {
		
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			
			
			
			UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
			tmpButton.frame = CGRectMake(2, 2, 44, 44);
			[tmpButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
			[tmpButton addTarget:self action:@selector(changeTeamPicture) forControlEvents:UIControlEventTouchUpInside];
			
			//UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
			//UIBarButtonItem *teamPicture = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changeTeamPicture)];
			
			
			if (displayPhoto) {
				//[self.tabBarController.navigationItem setRightBarButtonItem:teamPicture];
			}
			
		}else {
			//[self.tabBarController.navigationItem setRightBarButtonItem:nil];

		}


		
	}


	
		
}





-(void)editTeam{
        

    
    if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
        [TraceSession addEventToSession:@"Team Home Page - Edit Team Button Clicked"];

        TeamEdit *tmp = [[TeamEdit alloc] init];
        tmp.teamId = self.teamId;
        tmp.fromHome = self.fromHome;
        [self.navigationController pushViewController:tmp animated:YES];
        
    }else{
        
        [TraceSession addEventToSession:@"Team Home Page - Edit Team (Fan) Button Clicked"];


        TeamEditFan *tmp = [[TeamEditFan alloc] init];
        tmp.teamId = self.teamId;
        tmp.fromHome = self.fromHome;
        [self.navigationController pushViewController:tmp animated:YES];
        
    }
 
    
}


-(void)addMembers{

    NewPlayer *nextController = [[NewPlayer alloc] init];
    nextController.teamId = self.teamId;
    nextController.userRole = self.userRole;
    [self.navigationController pushViewController:nextController animated:YES];
    
}

-(void)addEvents{
    
    SelectCalendarEvent *tmp = [[SelectCalendarEvent alloc] init];
	tmp.teamId = self.teamId;
	[self.navigationController pushViewController:tmp animated:YES];
    
}


-(void)dealloc{
    
    myAd.delegate = nil;
	myAd = nil;

}
-(void)viewDidUnload{

	errorLabel = nil;
	teamNameLabel = nil;
	nextGameInfoLabel = nil;
	topRight = nil;
	topLeft = nil;
	recentGamesTable = nil;
	allScoresButton = nil;
	allScoresButtonUnderline = nil;
	nextGameButton = nil;
	nextEventInfoLabel = nil;
	nextEventButton = nil;
	eventsActivity = nil;
	nextGameLabel = nil;
	nextEventLabel = nil;
    editButton = nil;
    largeActivity = nil;
    recentGamesLabel = nil;
    addEventsButton = nil;
    addMembersButton = nil;
    noEventsLabel = nil;
    myAd.delegate = nil;
	myAd = nil;
    recordLabel = nil;
	[super viewDidUnload];
}


-(NSString *)getIntervalLabelFromInterval:(NSString *)interval1{
    
    if ([interval1 isEqualToString:@"-1"]) {
        //Game over
        return @"Final";
        
    }else {
        //Game in progress
        
        NSString *time = @"";
        int interval = [interval1 intValue];
        
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
            time = [NSString stringWithFormat:@"%@th", interval1];
        }
        
        if (interval == -2) {
            time = @"OT";
        }
        
        
        if (interval == -3) {
            time = @"";
        }
        
        
        return time;
    }

    
}

@end
