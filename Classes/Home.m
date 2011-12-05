//
//  Home.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.x
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//activi

#import "Team.h"
#import "InviteFan2.h"
#import "Home.h"
#import "Practice.h"
#import "ServerAPI.h"
#import "Game.h"
#import "Fans.h"
#import "rTeamAppDelegate.h"
#import "GameTabs.h"
#import "Gameday.h"
#import "GameAttendance.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "AllEventsCalendar.h"
#import "MessageThreadInbox.h"
#import "Search.h"
#import "InviteFan.h"
#import "MyViewController.h"
#import "MyTeams.h"
#import "QuartzCore/QuartzCore.h"
#import "TeamNavigation.h"
#import "CurrentEvent.h"
#import "EventNowButton.h"
#import "GameTabsNoCoord.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "EventAttendance.h"
#import "Scores.h"
#import "HelpAbout.h"
#import <iAd/iAD.h>
#import "FastActionSheetHome.h"
#import "Vote.h"
#import "NewPlayer.h"
#import "NewMemberObject.h"
#import "AttendingButton.h"
#import "ScoreButton.h"
#import "NewActivity.h"
#import "SendPoll.h"
#import "GANTracker.h"

@implementation Home
@synthesize name, teamId, oneTeamFlag, games, practices,eventTodayIndex, eventToday, bottomBar, nextGameIndex, nextPracticeIndex, userRole, 
badgeNumber, didRegister, numMemberTeams, inviteFan, viewControllers, serverError, alreadyCalled1, alreadyCalled2, haveTeamList, teamList, changeQuickLink, newQuickLinkTable, newQuickLinkAlias, rowNewQuickTeam, 
teamListFailed, newMessagesSuccess, newMessagesCount, messageBadge, alreadyCalledCreate, activityGettingTeams, eventsNowActivity, eventsToday, 
eventsTomorrow, numberOfPages, eventsNowSuccess, eventsNowTryAgain, allBottomButtons, selectRowLabel, eventsButton, 
bannerIsVisible, myTeamsButton, messagesButton,displayIconsScroll, isEditingQuickLinkOne, newActivity, changeIconButton, foundQuick1, foundQuick2, undoCancel, undoTeamId, undoEventType, undoEventId, spotOpen, oneTeam,
addMembersButton, membersUserRole, membersTeamId, phoneOnlyArray, justAddName, displayIconsScrollBack, changeQuickLinkBack, changingLink,
refreshButton, questionButton, backHelpView, backViewTop, transViewBottom, transViewTop, settingQbutton, searchQbutton,
myTeamsQbutton, activityQbutton, messagesQbutton, eventsQbutton, quickLinksQbutton, happeningNowQbutton, helpQbutton,
inviteFanQbutton, refreshQbutton, backViewBottom, closeQuestionButton, helpExplanation,   isMoreShowing,  regTextView, regTextButton, registrationBackView, textBackView, textFrontView,
currentDisplay, aboutButton, numObjects, shortcutButton, quickLinkChangeButton, quickLinkOkButton, quickLinkCancelButton, quickLinkCancelTwoButton,
blueArrow, myAd, pageControlUsed, createdTeam, errorString, homeScoreView, happeningNowView, scrollView, pageControl, homeAttendanceView;



-(void)viewWillDisappear:(BOOL)animated{
    
    self.serverError.text = @"";
}

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
	

    if (myAd.bannerLoaded) {
        myAd.hidden = NO;
        bannerIsVisible = YES;
        
        self.bottomBar.frame = CGRectMake(0, 322, 320, 44);
        self.refreshQbutton.frame = CGRectMake(275, 319, 50, 50);
        self.aboutButton.frame = CGRectMake(85, 325, 150, 35);
        
    }else{
        myAd.hidden = YES;
        bannerIsVisible = NO;
        
        self.bottomBar.frame = CGRectMake(0, 372, 320, 44);
        self.refreshQbutton.frame = CGRectMake(275, 369, 50, 50);
        self.aboutButton.frame = CGRectMake(85, 375, 150, 35);

    }
    
    if (self.isMoreShowing) {
        [self moveDivider];
    }
    
	self.addMembersButton.hidden = YES;
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	mainDelegate.returnHome = NO;
    
    if ((mainDelegate.justAddName != nil) &&! [mainDelegate.justAddName isEqualToString:@""]){
        
        self.justAddName = mainDelegate.justAddName;
        mainDelegate.justAddName = @"";
    }

    self.messageBadge.hidden = YES;

	self.isEditingQuickLinkOne = false;
	
	self.alreadyCalled1 = false;
	self.alreadyCalled2 = false;
	self.alreadyCalledCreate = false;

	
	self.haveTeamList = false;
	[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	[self performSelectorInBackground:@selector(getUserInfo) withObject:nil];
	
	[self.eventsNowActivity startAnimating];
	[self performSelectorInBackground:@selector(getEventsNow) withObject:nil];

	[self.changeQuickLinkBack setHidden:YES];
	[self.displayIconsScrollBack setHidden:YES];
	

	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.changeQuickLink.bounds;
	UIColor *color1 =  [UIColor colorWithRed:34/255.0 green:145/255.0 blue:34/255.0 alpha:0.9];
	//UIColor *color1 = [UIColor whiteColor];
	UIColor *color2 = [UIColor colorWithRed:.386 green:.704 blue:.386 alpha:0.9];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	//[self.changeQuickLink.layer insertSublayer:gradient atIndex:0];
	self.changeQuickLink.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbackSmall.png"]];
    
	CAGradientLayer *gradient1 = [CAGradientLayer layer];
	gradient1.frame = self.displayIconsScroll.bounds;
	gradient1.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	//[self.displayIconsScroll.layer insertSublayer:gradient1 atIndex:0];
    self.displayIconsScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenbackSmall.png"]];

	
	self.rowNewQuickTeam = -1;
	
	self.changeQuickLink.layer.masksToBounds = YES;
	self.changeQuickLink.layer.cornerRadius = 25.0;
	self.displayIconsScroll.layer.masksToBounds = YES;
	self.displayIconsScroll.layer.cornerRadius = 25.0;
	
	self.changeQuickLinkBack.layer.masksToBounds = YES;
	self.changeQuickLinkBack.layer.cornerRadius = 25.0;
	self.displayIconsScrollBack.layer.masksToBounds = YES;
	self.displayIconsScrollBack.layer.cornerRadius = 25.0;
	
	self.newQuickLinkAlias.delegate = self;
	
	self.newQuickLinkTable.delegate = self;
	self.newQuickLinkTable.dataSource = self;
	self.newQuickLinkTable.backgroundColor = [UIColor clearColor];


	[self addQuickLinks];


	NSString *ios = [[UIDevice currentDevice] systemVersion];
		
	if (!(![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
		[self.eventsButton setHidden:YES];
	
	}

	
	if ([mainDelegate.phoneOnlyArray count] > 0) {
		
		self.phoneOnlyArray = [NSMutableArray arrayWithArray:mainDelegate.phoneOnlyArray];
		mainDelegate.phoneOnlyArray = [NSArray array];
		bool canText = false;
		
		NSString *ios = [[UIDevice currentDevice] systemVersion];
		
		
		if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
			
			if ([MFMessageComposeViewController canSendText]) {
				
				canText = true;
				
			}
		}else { 
			if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
				canText = true;
			}
		}
		
		if (canText) {
			NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Would you like to send them a text right now with information on how to sign up?";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
			[alert1 show];
		}else {
			NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert1 show];
		}
		
		
		
	}

  
	[self.view bringSubviewToFront:myAd];
    [self.view bringSubviewToFront:self.bottomBar];
	
}

-(void)addQuickLinks{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *quickLinkOne = mainDelegate.quickLinkOne;
	NSString *quickLinkOneName = mainDelegate.quickLinkOneName;

    if ([quickLinkOne isEqualToString:@"create"] || [quickLinkOne isEqualToString:@""]) {
        self.shortcutButton.hidden = YES;
        self.createdTeam = false;
    }else{
        self.createdTeam = true;
        self.shortcutButton.hidden = NO;
        
        self.shortcutButton.teamId = quickLinkOne;
        [self.shortcutButton addLabel];
        self.shortcutButton.teamName.text = quickLinkOneName;
        
        NSString *imageOneName = [self getQuickLinkImageOne];
        [self.shortcutButton setImage:[UIImage imageNamed:imageOneName] forState:UIControlStateNormal];
        self.shortcutButton.contentMode = UIViewContentModeScaleToFill;
        
        
        [self.shortcutButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [self.shortcutButton addTarget:self action:@selector(quickTeam:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(holdDown1)];
        
        
        longPressRecognizer.minimumPressDuration = 0.7;
        longPressRecognizer.allowableMovement = 20.0;
        [self.shortcutButton addGestureRecognizer:longPressRecognizer];
    }
    
  

		
	
    
}

-(void)quickTeam:(id)sender{

	@try {
	
	
        Team *toTeam;
		bool goTeam = true;
        
		while (!self.haveTeamList) {
			//Wait here for the background thread to finish;
			
			if (self.teamListFailed) {
				goTeam = false;
				break;
			}
		}
        
		if (goTeam) {
            
			for (int i = 0; i < [self.teamList count]; i++) {
                
				Team *team = [self.teamList objectAtIndex:i];
                
				if ([team.teamId isEqualToString:self.shortcutButton.teamId]) {
                    
					toTeam = team;
                    
				}
			}
            
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"View Team from Quick Link"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			TeamNavigation *tmpNav = [[TeamNavigation alloc] init];
			tmpNav.teamId = toTeam.teamId;
			tmpNav.teamName = toTeam.name;
			tmpNav.userRole = toTeam.userRole;
			tmpNav.sport = toTeam.sport;
            tmpNav.fromHome = true;
            tmpNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:tmpNav animated:YES];
            
		}else {
			self.serverError.text = @"*Error connecting to server";
			self.teamListFailed = false;
			[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
		}

        

	}@catch (NSException *e) {
		
	}
}



-(void)holdDown1{
	self.serverError.text = @"";
	self.isEditingQuickLinkOne = true;
	self.changeIconButton.hidden = NO;

	
	if (!self.alreadyCalled1) {
		
		[self.selectRowLabel setHidden:YES];
		[self.changeQuickLinkBack setHidden:NO];
		[self.view bringSubviewToFront:self.changeQuickLinkBack];
		if (!self.haveTeamList) {
			[self.activityGettingTeams startAnimating];

		}
	}
	self.alreadyCalled1 = true;
	
	
}

-(void)holdDown2{
	self.isEditingQuickLinkOne = false;
	self.serverError.text = @"";
	self.changeIconButton.hidden = NO;


	if (!self.alreadyCalled2) {
		
		[self.selectRowLabel setHidden:YES];
		[self.changeQuickLinkBack setHidden:NO];
		[self.view bringSubviewToFront:self.changeQuickLinkBack];
		if (!self.haveTeamList) {
			[self.activityGettingTeams startAnimating];
			
		}
	}
	self.alreadyCalled2 = true;
	
}

-(void)holdDownCreate{
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

	self.changeIconButton.hidden = YES;
	if (![mainDelegate.quickLinkTwo isEqualToString:@""]) {
		
		if (!self.alreadyCalledCreate) {
		
			[self.changeQuickLinkBack setHidden:NO];
			[self.view bringSubviewToFront:self.changeQuickLinkBack];
			if (!self.haveTeamList) {
				[self.activityGettingTeams startAnimating];
			}
		}
		self.alreadyCalledCreate = true;
		
	}
	
}


-(void)okNewQuickLink{
	
	if (self.rowNewQuickTeam != -1) {
		
		Team *tmpTeam = [self.teamList objectAtIndex:self.rowNewQuickTeam];
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
		
			
		    mainDelegate.quickLinkOne = tmpTeam.teamId;
			if (![self.newQuickLinkAlias.text isEqualToString:@""]) {
				mainDelegate.quickLinkOneName = self.newQuickLinkAlias.text;
			}else {
				mainDelegate.quickLinkOneName = tmpTeam.name;
			}
			
		
				
		[self performSelectorInBackground:@selector(updateUserIcons) withObject:nil];
        self.changingLink = true;

		[self addQuickLinks];
		[self.changeQuickLinkBack setHidden:YES];
		self.alreadyCalled1 = false;

	}else {
		[self.selectRowLabel setHidden:NO];
	}

	
}

-(void)cancelNewQuickLink{
	
    
	self.alreadyCalled1 = false;
	self.alreadyCalled2 = false;
	self.alreadyCalledCreate = false;
    CGRect initFrame = self.changeQuickLinkBack.frame;
    
    [UIView transitionWithView:self.changeQuickLinkBack duration:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{self.changeQuickLinkBack.frame = CGRectOffset(self.changeQuickLinkBack.frame, 0, -self.changeQuickLinkBack.frame.size.height);} completion:^(BOOL finished){
        
        [self.changeQuickLinkBack setHidden:YES];
        self.changeQuickLinkBack.frame = initFrame;

        
    }];
    

}

- (void)viewDidLoad {


	self.currentDisplay = 1;
    self.registrationBackView.hidden = YES;
    homeScoreView = [[HomeScoreView alloc] init];
    homeScoreView.view.frame = CGRectMake(0, 322, 320, 301);
    homeScoreView.view.hidden = YES;
    
    homeAttendanceView = [[HomeAttendanceView alloc] init];
    //homeAttendanceView.homePage = self;
    homeAttendanceView.view.frame = CGRectMake(0, 322, 320, 301);
    homeAttendanceView.view.hidden = YES;
    [self.view addSubview:self.homeAttendanceView.view];
    [self.view addSubview:self.homeScoreView.view];

    
	self.title = @"rTeam";
		
	UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																	   target:self action:@selector(search)];
	
	[self.navigationItem setRightBarButtonItem:btn];
	
	
	int quickOneX;
	int quickTwoX;
	NSString *ios = [[UIDevice currentDevice] systemVersion];

	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		quickOneX = 119;
		quickTwoX = 220;
	}else {
		quickOneX = 50;
		quickTwoX = 190;
	}
	
	self.addMembersButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.addMembersButton.frame = 	CGRectMake(quickTwoX, 149, 82, 66);
	[self.addMembersButton setImage:[UIImage imageNamed:@"width80addMembers.png"] forState:UIControlStateNormal];
	[self.addMembersButton addTarget:self action:@selector(addMembers) forControlEvents:UIControlEventTouchUpInside];
	//[self.view addSubview:self.addMembersButton];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
  


    self.inviteFan = [[UIBarButtonItem alloc] initWithTitle:@"Invite A Fan" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteFanMethod)];
	self.inviteFan.title = @"Invite A Fan";
 
    
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStylePlain target:self action:@selector(question)];
    
    UIBarButtonItem *refresh =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                      target:self action:@selector(refresh)];
    
	refresh.style = UIBarButtonItemStylePlain;
    
	NSArray *items1 = [NSArray arrayWithObjects:question, flexibleSpace, refresh, nil];
	self.bottomBar.items = items1;
	
		
    self.textFrontView.layer.masksToBounds = YES;
	self.textFrontView.layer.cornerRadius = 5.0;
	self.textBackView.layer.masksToBounds = YES;
	self.textBackView.layer.cornerRadius = 5.0;
    
	if ([self.didRegister isEqualToString:@"true"]) {
		
		self.didRegister = @"false";

        self.regTextView.hidden = NO;
        self.registrationBackView.hidden = NO;
        self.regTextView.text = @"Welcome to rTeam!  An activation email has been sent to your account.  Please confirm your email address by clicking the link inside the email.";
		
	}

	if (!(![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
		[self.eventsButton setHidden:YES];
		
	}
	
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComeBack:) 
												 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
 
    
    
    //Set up Help Screen
    self.backViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.backViewTop.backgroundColor = [UIColor clearColor];
    
    self.backViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.backViewBottom.backgroundColor = [UIColor clearColor];
    self.backViewBottom.clipsToBounds = YES;

    
    self.transViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.transViewBottom.backgroundColor = [UIColor blackColor];
    self.transViewBottom.opaque = NO;
    self.transViewBottom.alpha = 0.75;
    
    self.transViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.transViewTop.backgroundColor = [UIColor blackColor];
    self.transViewTop.opaque = NO;
    self.transViewTop.alpha = 0.75;
    
    self.myTeamsQbutton = [[UIButton alloc] initWithFrame:CGRectMake(60, 36, 50, 50)];
    [self.myTeamsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.myTeamsQbutton.opaque = YES;
    [self.myTeamsQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.myTeamsQbutton.tag = 3;

    self.activityQbutton = [[UIButton alloc] initWithFrame:CGRectMake(134, 63, 50, 50)];
    [self.activityQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.activityQbutton.opaque = YES;
    [self.activityQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.activityQbutton.tag = 4;
    
    self.messagesQbutton = [[UIButton alloc] initWithFrame:CGRectMake(208, 36, 50, 50)];
    [self.messagesQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.messagesQbutton.opaque = YES;
    [self.messagesQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.messagesQbutton.tag = 5;
    
    self.eventsQbutton = [[UIButton alloc] initWithFrame:CGRectMake(60, 123, 50, 50)];
    [self.eventsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.eventsQbutton.opaque = YES;
    [self.eventsQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.eventsQbutton.tag = 6;
    
    self.quickLinksQbutton = [[UIButton alloc] initWithFrame:CGRectMake(208, 123, 50, 50)];
    [self.quickLinksQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.quickLinksQbutton.opaque = YES;
    [self.quickLinksQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.quickLinksQbutton.tag = 7;
    
    self.happeningNowQbutton = [[UIButton alloc] initWithFrame:CGRectMake(134, 273, 50, 50)];
    [self.happeningNowQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.happeningNowQbutton.opaque = YES;
    [self.happeningNowQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.happeningNowQbutton.tag = 8;
    
    self.helpQbutton = [[UIButton alloc] initWithFrame:CGRectMake(69, 369, 50, 50)];
    [self.helpQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.helpQbutton.opaque = YES;
    [self.helpQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.helpQbutton.tag = 9;
    
    self.inviteFanQbutton = [[UIButton alloc] initWithFrame:CGRectMake(182, 369, 50, 50)];
    [self.inviteFanQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.inviteFanQbutton.opaque = YES;
    [self.inviteFanQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.inviteFanQbutton.tag = 10;
    
    
    self.refreshQbutton = [[UIButton alloc] initWithFrame:CGRectMake(275, 369, 50, 50)];
    [self.refreshQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.refreshQbutton.opaque = YES;
    [self.refreshQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.refreshQbutton.tag = 11;
    
    
    
    self.settingQbutton = [[UIButton alloc] initWithFrame:CGRectMake(15, -3, 50, 50)];
    [self.settingQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.settingQbutton.opaque = YES;
    [self.settingQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.settingQbutton.tag = 1;
    
    self.searchQbutton = [[UIButton alloc] initWithFrame:CGRectMake(270, -3, 50, 50)];
    [self.searchQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    self.searchQbutton.opaque = YES;
    [self.searchQbutton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchQbutton.tag = 2;
    
    self.aboutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.aboutButton.frame = CGRectMake(85, 375, 150, 35);
    [self.aboutButton setTitle:@"Go To Help Page" forState:UIControlStateNormal];
    [self.aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.aboutButton addTarget:self action:@selector(aboutRteam) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeQuestionButton = [[UIButton alloc] initWithFrame:CGRectMake(122, 6, 75, 30)];
    [self.closeQuestionButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeQuestionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeQuestionButton addTarget:self action:@selector(closeQuestion) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.closeQuestionButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.aboutButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.quickLinkCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.quickLinkChangeButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.quickLinkOkButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.quickLinkCancelTwoButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.regTextButton setBackgroundImage:stretch forState:UIControlStateNormal];


    [self.backViewBottom addSubview:self.transViewBottom];
    [self.backViewBottom addSubview:self.myTeamsQbutton];
    //[self.backViewBottom addSubview:self.activityQbutton];
    [self.backViewBottom addSubview:self.messagesQbutton];
    [self.backViewBottom addSubview:self.eventsQbutton];
    [self.backViewBottom addSubview:self.quickLinksQbutton];
    [self.backViewBottom addSubview:self.happeningNowQbutton];
    //[self.backViewBottom addSubview:self.helpQbutton];
    //[self.backViewBottom addSubview:self.inviteFanQbutton];
    [self.backViewBottom addSubview:self.refreshQbutton];
    [self.backViewBottom addSubview:self.aboutButton];
    
    self.helpExplanation = [[UITextView alloc] initWithFrame:CGRectMake(0, 168, 320, 120)];
    self.helpExplanation.backgroundColor = [UIColor clearColor];
    self.helpExplanation.textColor = [UIColor whiteColor];
    self.helpExplanation.editable = NO;
    self.helpExplanation.scrollEnabled = NO;
    self.helpExplanation.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.backViewBottom addSubview:self.helpExplanation];
    
    [self.backViewTop addSubview:self.transViewTop];
    [self.backViewTop addSubview:self.settingQbutton];
    [self.backViewTop addSubview:self.searchQbutton];
    [self.backViewTop addSubview:self.closeQuestionButton];
    
    
    [self.view addSubview:self.backViewBottom];
    [self.navigationController.navigationBar addSubview:self.backViewTop];

    self.backViewBottom.hidden = YES;
    self.backViewTop.hidden = YES;
    
    
    
}

-(void)didComeBack:(id)sender{
	
	
	if (self == self.navigationController.visibleViewController) {
		
		[self viewWillAppear:NO];
	}
	
}



-(void)search{
	
   
    
    /*
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"View Search Page"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	self.serverError.text = @"";

	Search *tmp = [[Search alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	[navController pushViewController:tmp animated:YES];
	
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self.navigationController presentModalViewController:navController animated:YES];
	*/
}



-(void)inviteFanMethod{
	
	self.serverError.text = @"";

	bool goTeam = true;
	
	while (!self.haveTeamList) {
		//Wait here for the background thread to finish;
		
		if (self.teamListFailed) {
			goTeam = false;
			break;
		}
	}
	
	if (goTeam) {
		
		if ([self.teamList count] == 1) {
			Team *tmpTeam = [self.teamList objectAtIndex:0];
			
			InviteFan2 *tmp = [[InviteFan2 alloc] init];
			tmp.teamId = tmpTeam.teamId;
			
			
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:tmp animated:YES];
			
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:navController animated:YES];
			
			
		}else if ([self.teamList count] > 1) {
			InviteFan *tmp = [[InviteFan alloc] init];
			
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:tmp animated:YES];
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:navController animated:YES];
		}else {
			
			self.serverError.text = @"*You must create or join at least 1 team to invite a fan.";
		}
		
	}else {
		self.serverError.text = @"*Error connecting to server";
		self.teamListFailed = false;
		[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	}

	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	self.alreadyCalled1 = false;
	self.alreadyCalled2 = false;
	
	if(buttonIndex == 1){
		
		//Text
		@try{
			
			NSMutableArray *numbersToCall = [NSMutableArray array];
			bool call = false;
			
			for (int i = 0; i < [self.phoneOnlyArray count]; i++) {
				
				NSString *numberToCall = @"";
				
				NSString *tmpPhone = [self.phoneOnlyArray objectAtIndex:i];
				
				if ([tmpPhone length] == 16) {
					call = true;
					
					NSRange first3 = NSMakeRange(3, 3);
					NSRange sec3 = NSMakeRange(8, 3);
					NSRange end4 = NSMakeRange(12, 4);
					numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
									[tmpPhone substringWithRange:end4]];
					
				}else if ([tmpPhone length] == 14) {
					call = true;
					
					NSRange first3 = NSMakeRange(1, 3);
					NSRange sec3 = NSMakeRange(6, 3);
					NSRange end4 = NSMakeRange(10, 4);
					numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
									[tmpPhone substringWithRange:end4]];
					
				}else if (([tmpPhone length] == 10) || ([tmpPhone length] == 11)) {
					call = true;
					numberToCall = tmpPhone;
				}
				
				[numbersToCall addObject:numberToCall];
			}
			
			if (call) {
				
				NSString *ios = [[UIDevice currentDevice] systemVersion];
				
				if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
					
					if ([MFMessageComposeViewController canSendText]) {
						
						MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
						messageViewController.messageComposeDelegate = self;
						[messageViewController setRecipients:numbersToCall];
						
						rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
						
						mainDelegate.displayName = @"";
						
						NSString *addition = @"";
						
						if (![mainDelegate.displayName isEqualToString:@""]) {
							addition = [NSString stringWithFormat:@" by %@", mainDelegate.displayName];
						}
						
						NSString *teamNameShort = self.justAddName;
                        int strLength = [self.justAddName length];
                        
                        if (strLength > 13){
                            teamNameShort = [[self.justAddName substringToIndex:10] stringByAppendingString:@".."];
                        }
                        
                        NSString *bodyMessage = [NSString stringWithFormat:@"Hi, you have been added via rTeam to the team '%@'. To sign up for our free texting service, send a text to 'join@rteam.com' with the message 'yes'.", teamNameShort];
                        
						[messageViewController setBody:bodyMessage];
                        messageViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
						[self presentModalViewController:messageViewController animated:YES];
						
					}
				}else {
					
					NSString *url = [@"sms://" stringByAppendingString:[numbersToCall objectAtIndex:0]];
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
				}
				
				
			}
			
		}@catch (NSException *e) {
			
		}

		
		
	}
	
	self.phoneOnlyArray = [NSMutableArray array];
}


-(void)newsFeed{
	


	
}


-(void)aboutRteam{
    
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Go to Help Page - From Home"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
    [self closeQuestion];
    
	self.serverError.text = @"";

	HelpAbout *tmp = [[HelpAbout alloc] init];
	//NEW HOME
	//[self.navigationController pushViewController:tmp animated:YES];
	
	UINavigationController *tmpController = [[UINavigationController alloc] init];
	
	[tmpController pushViewController:tmp animated:NO];
	
    tmpController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

	[self.navigationController presentModalViewController:tmpController animated:YES];
	
}
-(void)myTeams{
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"View My Teams"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	self.serverError.text = @"";
    
    MyTeams *tmp = [[MyTeams alloc] init];
	
	if ((self.haveTeamList) && ([self.teamList count] > 0)) {
		
		tmp.haveTeamList = false;
	}
	
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	[navController pushViewController:tmp animated:NO];
	
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self.navigationController presentModalViewController:navController animated:YES];
    
   
    
}

-(void)allEvents{
    
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"View Calendar of Events"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
    
	self.serverError.text = @"";

	AllEventsCalendar *nextController = [[AllEventsCalendar alloc] init];

	UINavigationController *navController = [[UINavigationController alloc] init];

	[navController pushViewController:nextController animated:NO];	
	
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:navController animated:YES];
}

-(void)messages{
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"View Activity"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	self.serverError.text = @"";
	
    NewActivity *tmp = [[NewActivity alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] init];
	
	[navController pushViewController:tmp animated:NO];
	
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self.navigationController presentModalViewController:navController animated:YES];	
 
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.teamList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier: FirstLevelCell];
	}
	
	NSUInteger row = [indexPath row];
	
	Team *tmpTeam = [self.teamList objectAtIndex:row];
	
	cell.textLabel.text = tmpTeam.name;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	
	[self.selectRowLabel setHidden:YES];

	self.rowNewQuickTeam = row;
	
	
}



-(void)endText{

}


-(void)getTeamList{

	@autoreleasepool {
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
                
                if ([self.teamList count] == 1) {
                    Team *tmpTeam = [self.teamList objectAtIndex:0];
                    
                    if ([tmpTeam.userRole isEqualToString:@"creator"] || [tmpTeam.userRole isEqualToString:@"coordinator"]) {
                        
                        self.oneTeam = true;
                        self.membersTeamId = tmpTeam.teamId;
                        self.membersUserRole = tmpTeam.userRole;
                        self.justAddName = tmpTeam.name;
                        
                    }
                    
                }
                self.haveTeamList = true;
            
                
            }else{
                
                self.teamListFailed = true;
       
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

    }
		
}

-(void)doneTeams{
		
    [self.activityGettingTeams stopAnimating];
    [self.newQuickLinkTable reloadData];
    
	if (self.haveTeamList) {

		[self.activityGettingTeams stopAnimating];
		
	}
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

	
	if ([self.teamList count] > 0) {
        if ([mainDelegate.quickLinkOne isEqualToString:@"create"] || [mainDelegate.quickLinkOne isEqualToString:@""]) {
            
            Team *tmpTeam = [self.teamList objectAtIndex:0];
            
            mainDelegate.quickLinkOne = tmpTeam.teamId;
            mainDelegate.quickLinkOneName = tmpTeam.name;
            mainDelegate.quickLinkOneImage = tmpTeam.sport;
            
            
            [mainDelegate saveUserInfo];
            
            [self addQuickLinks];
        }
    }
		
}
-(void)updateUserIcons{

	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :mainDelegate.quickLinkOne 
                                                          :mainDelegate.quickLinkOneName :mainDelegate.quickLinkTwo :mainDelegate.quickLinkTwoName
                                                          :mainDelegate.quickLinkOneImage :mainDelegate.quickLinkTwoImage :@"" :[NSData data] :@"" :@""
                                                          :@"" :@"" :@"" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                [mainDelegate saveUserInfo];
                
            }else{
                
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
            
            
            
            
        }

    }
	
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}

-(void)getMessageThreadCount{
	

	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI getMessageThreadCount:token :@"" :@"" :@"" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                self.newMessagesSuccess = true;
                self.newMessagesCount = [[response valueForKey:@"count"] intValue];
                
                self.newActivity = [[response valueForKey:@"newActivity"] boolValue];
                
            }else{
                
                self.newMessagesSuccess = false;
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
            
            
            
            
        }
        
        [self performSelectorOnMainThread:
         @selector(finishedMessageCount)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
	
}

-(void)finishedMessageCount{
	
	if (self.newMessagesSuccess) {

		if (self.newMessagesCount > 0) {

            self.messageBadge.hidden = NO;

		}else {

			self.messageBadge.hidden = YES;
		}
		
		if (self.newActivity) {
			
		}else {
		}

	}else {
        self.messageBadge.hidden = YES;

	}
	
}


-(void)getEventsNow{

	@autoreleasepool {
        self.eventsToday = [NSMutableArray array];
        self.eventsTomorrow = [NSMutableArray array];
        
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfEventsNow:token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                self.eventsNowSuccess = true;
                self.eventsToday = [response valueForKey:@"eventsToday"];
                self.eventsTomorrow = [response valueForKey:@"eventsTomorrow"];
                
                
            }else{
                self.eventsNowSuccess = false;
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
            
            
            
            
        }
        
        [self performSelectorOnMainThread:
         @selector(finishedEventsNow)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
	
}


-(void)finishedEventsNow{
	
	[self.eventsNowActivity stopAnimating];
	
	if (self.eventsNowSuccess) {
		
		self.numObjects = [self.eventsToday count] + [self.eventsTomorrow count];
        
        if (self.numObjects == 0) {
            self.numberOfPages = 1;
        }else{
            self.numberOfPages = ceil(numObjects/2.0);
        }
				
		[self setBottomArray];
		[self setUpScrollView];
		
	}else {
		
		if (self.eventsNowTryAgain) {
			self.eventsNowTryAgain = false;
			[self.eventsNowActivity startAnimating];
			[self performSelectorInBackground:@selector(getEventsNow) withObject:nil];
		}else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"Please make sure you have a valid internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];

		}

	}

	
}

//Takes the eventsToday Array, eventsTomorrow Array, scores, and new team, and combines it all
// into 1 array, in order of display priority
// - Games in Progress
// - Games Today
// - Practice Today
// - Event Today
// - Games Tomorrow
// - Practice Tomorrow
// - Event Tomorrow
-(void)setBottomArray{
	
	NSMutableArray *gamesToday = [NSMutableArray array];
	NSMutableArray *practicesToday = [NSMutableArray array];
	NSMutableArray *genericToday = [NSMutableArray array];
	NSMutableArray *gamesTomorrow = [NSMutableArray array];
	NSMutableArray *practicesTomorrow = [NSMutableArray array];
	NSMutableArray *genericTomorrow = [NSMutableArray array];
	self.allBottomButtons = [NSMutableArray array];
	
	for (int i = 0; i < [self.eventsToday count]; i++) {
		
		if (i >= 0) {
			
			CurrentEvent *tmp = [self.eventsToday objectAtIndex:i];
            tmp.scoreLabel = @"";
			NSString *startDate = tmp.eventDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:startDate];	
			[dateFormat setDateFormat:@"hh:mm"];
			NSString *startDateString = [dateFormat stringFromDate:formatedDate];

			[dateFormat setDateFormat:@"a"];
			NSString *startDateAmPm = [dateFormat stringFromDate:formatedDate];
	
						
			if ([[startDateString substringToIndex:1] isEqualToString:@"0"]) {
				startDateString  = [startDateString substringFromIndex:1];
			}
			
			if ([startDateAmPm isEqualToString:@"AM"]) {
				startDateAmPm = @"a";
			}
			if ([startDateAmPm isEqualToString:@"PM"]) {
				startDateAmPm = @"p";
			}
			
			if ([tmp.eventType isEqualToString:@"game"]) {
			
				NSString *interval = tmp.gameInterval;
			
				if (![interval isEqualToString:@"0"] && ![interval isEqualToString:@"-1"]) {
					//add it to allBottomButtonsArray
					//remove it from eventsToday
					// i--
					tmp.imageName = @"hbGameInProgress.png";
					tmp.eventLabel = @"Game In Progress!";
                    tmp.scoreLabel = [NSString stringWithFormat:@"Us:%@ Them:%@", tmp.scoreUs, tmp.scoreThem];
					[self.allBottomButtons addObject:tmp];
					[eventsToday removeObjectAtIndex:i];
					i--;
					
				}else {
					//it is a "Game Today"
					tmp.imageName = @"hbGameToday.png";
					tmp.eventLabel = [NSString stringWithFormat:@"Game Today, %@%@", startDateString, startDateAmPm];
                    
                    if ([interval isEqualToString:@"-1"]){
                        NSString *initString = @"";
                        
        
                        if ([tmp.scoreUs intValue] > [tmp.scoreThem intValue]) {
                            initString = @"W";
                        }else if ([tmp.scoreUs intValue] < [tmp.scoreThem intValue]){
                            initString = @"L";
                        }else{
                            initString = @"T";
                        }
                        
                        tmp.scoreLabel = [NSString stringWithFormat:@"%@ %@ - %@", initString, tmp.scoreUs, tmp.scoreThem];

                        
                    }
                   
					[gamesToday addObject:tmp];
					[eventsToday removeObjectAtIndex:i];
					i--;
				}

			}else if ([tmp.eventType isEqualToString:@"practice"]) {
				// "Practice Today"
				tmp.imageName = @"hbPracticeToday.png";
				tmp.eventLabel = [NSString stringWithFormat:@"Practice Today, %@%@", startDateString, startDateAmPm];
				[practicesToday addObject:tmp];
				[eventsToday removeObjectAtIndex:i];
				i--;
			}else if ([tmp.eventType isEqualToString:@"generic"]) {
				// "Event Today
				tmp.imageName = @"hbEventToday.png";
				tmp.eventLabel = [NSString stringWithFormat:@"Event Today, %@%@", startDateString, startDateAmPm];
				[genericToday addObject:tmp];
				[eventsToday removeObjectAtIndex:i];
				i--;
			}
		}
	}
	
	
	for (int i = 0; i < [self.eventsTomorrow count]; i++) {
		
		if (i >= 0) {
			
			CurrentEvent *tmp = [self.eventsTomorrow objectAtIndex:i];
			tmp.scoreLabel = @"";
			NSString *startDate = tmp.eventDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:startDate];	
			[dateFormat setDateFormat:@"hh:mm"];
			NSString *startDateString = [dateFormat stringFromDate:formatedDate];
			
			[dateFormat setDateFormat:@"a"];
			NSString *startDateAmPm = [dateFormat stringFromDate:formatedDate];
			
			
			if ([[startDateString substringToIndex:1] isEqualToString:@"0"]) {
				startDateString  = [startDateString substringFromIndex:1];
			}
			
			if ([startDateAmPm isEqualToString:@"AM"]) {
				startDateAmPm = @"a";
			}
			if ([startDateAmPm isEqualToString:@"PM"]) {
				startDateAmPm = @"p";
			}

			
			if ([tmp.eventType isEqualToString:@"game"]) {
				//it is a "Game Tomorrow"
				tmp.imageName = @"hbGameTomorrow.png";
				tmp.eventLabel = [NSString stringWithFormat:@"Game Tomorrow, %@%@", startDateString, startDateAmPm];
				[gamesTomorrow addObject:tmp];
				[eventsTomorrow removeObjectAtIndex:i];
				i--;
			}else if ([tmp.eventType isEqualToString:@"practice"]) {
				// "Practice Tomorrow"
				tmp.imageName = @"hbPracticeTomorrow.png";
				tmp.eventLabel = [NSString stringWithFormat:@"Practice Tomorrow, %@%@", startDateString, startDateAmPm];
				[practicesTomorrow addObject:tmp];
				[eventsTomorrow removeObjectAtIndex:i];
				i--;
			}else if ([tmp.eventType isEqualToString:@"generic"]) {
				// "Event Tomorrow
				tmp.imageName = @"hbEventTomorrow.png";
				tmp.eventLabel = [NSString stringWithFormat:@"Event Tomorrow, %@%@", startDateString, startDateAmPm];
				[genericTomorrow addObject:tmp];
				[eventsTomorrow removeObjectAtIndex:i];
				i--;
			}
		}
	}
	
	//Add Games Today mini array to main array
	for (int i = 0; i < [gamesToday count]; i++) {
		[self.allBottomButtons addObject:[gamesToday objectAtIndex:i]];
	}
	
	//Add Practices Today mini array to main array
	for (int i = 0; i < [practicesToday count]; i++) {
		[self.allBottomButtons addObject:[practicesToday objectAtIndex:i]];
	}
	
	//Add Events Today mini array to main array
	for (int i = 0; i < [genericToday count]; i++) {
		[self.allBottomButtons addObject:[genericToday objectAtIndex:i]];
	}
	
	//Add Games Tomorrow mini array to main array
	for (int i = 0; i < [gamesTomorrow count]; i++) {
		[self.allBottomButtons addObject:[gamesTomorrow objectAtIndex:i]];
	}
	
	//Add Practices Tomorrow mini array to main array
	for (int i = 0; i < [practicesTomorrow count]; i++) {
		[self.allBottomButtons addObject:[practicesTomorrow objectAtIndex:i]];
	}
	
	//Add Events Tomorrow mini array to main array
	for (int i = 0; i < [genericTomorrow count]; i++) {
		[self.allBottomButtons addObject:[genericTomorrow objectAtIndex:i]];
	}
	
	
	//Add "Scores" and "New Team" to allBottomButtons
	
	CurrentEvent *scores = [[CurrentEvent alloc] init];
	scores.eventType = @"scores";
	scores.imageName = @"hbScores.png";
	scores.eventLabel = @"Scores/Schedule";
	scores.teamName = @"";
	
	//[self.allBottomButtons addObject:scores];
	
	CurrentEvent *newTeam = [[CurrentEvent alloc] init];
	newTeam.eventType = @"newTeam";
	newTeam.imageName = @"hbNewTeam.png";
	newTeam.eventLabel = @"New Team";
	newTeam.teamName = @"";
	
	//[self.allBottomButtons addObject:newTeam];
	
	
	
}
-(void)setUpScrollView{
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.numberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = [NSMutableArray arrayWithArray:controllers];
	
    // a page is the width of the scroll view
	//scrollView.frame = CGRectMake(100, 300, 200, 100);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.numberOfPages, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
	self.scrollView.backgroundColor = [UIColor blackColor];
	
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];

	
}


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= self.numberOfPages) return;
	
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
		UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollimage.png"]];
		[controller.view addSubview:image];
		
        
		for (int j = 0; j < self.numberOfPages; j++) {
			
            if (self.numObjects == 0) {
                
                UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [tmpButton setTitle:@"No events found, click 'Gameday' to create one now!" forState:UIControlStateNormal];
                tmpButton.titleLabel.numberOfLines = 2;
                tmpButton.titleLabel.textAlignment = UITextAlignmentCenter;
                [tmpButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                tmpButton.frame = CGRectMake(0, 0, 320, 110);
                tmpButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
                [controller.view addSubview:tmpButton];
                
              
            }else{
                                
                
                if (page == j) {
                    //want cells j and j+1 from the allBottomButtons array
                    
                    CurrentEvent *tmp1 = [self.allBottomButtons objectAtIndex:2*j];
                                        
                    if ([tmp1.eventType isEqualToString:@"game"]) {
                        
                        
                        if ([tmp1.gameInterval isEqualToString:@"0"]) {
                            //Game hasn't started, display Attendance
                            
                            AttendingButton *tmp1Button = [[AttendingButton alloc] initWithFrame:CGRectMake(36, 20, 92, 55)];
                            tmp1Button.event = tmp1;
                            tmp1Button.isAttendance = true;                            
                            tmp1Button.participantRole = tmp1.participantRole;
                            tmp1Button.teamId = tmp1.teamId;
                            tmp1Button.eventId = tmp1.eventId;
                            tmp1Button.sport = tmp1.sport;
                            
                            if (![tmp1.teamName isEqualToString:@""]) {
                                tmp1Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp1.teamName];
                            }else {
                                tmp1Button.teamLabel.text = @"";
                            }
                            
                            NSString *startDate = tmp1.eventDate;
                            
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                            NSDate *eventDate = [dateFormat dateFromString:startDate];
                            
                            [dateFormat setDateFormat:@"MM/dd"];
                            
                            tmp1Button.eventDate = [dateFormat stringFromDate:eventDate];
                            tmp1Button.eventType = @"Game";
                            tmp1Button.teamName = tmp1.teamName;
                            
                            
                            if (tmp1.isCanceled) {
                                tmp1Button.canceledLabel.text = @"CANCELED";
                            }else{
                                tmp1Button.canceledLabel.text = @"";
                            }
                            
                            // tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                            tmp1Button.eventLabel.text = tmp1.eventLabel;
                            [tmp1Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                            [controller.view addSubview:tmp1Button];
                                                       
                        }else{
                            //game has a score, display the score
                            
                            ScoreButton *tmp1Button = [[ScoreButton alloc] initWithFrame:CGRectMake(36, 20, 92, 55)];
                            tmp1Button.event = tmp1;
                            tmp1Button.isAttendance = false;
                            
                            if (![tmp1.teamName isEqualToString:@""]) {
                                tmp1Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp1.teamName];
                            }else {
                                tmp1Button.teamLabel.text = @"";
                            }
                            
                            tmp1Button.teamName = tmp1.teamName;
                            tmp1Button.interval = tmp1.gameInterval;
                            tmp1Button.scoreUs = tmp1.scoreUs;
                            tmp1Button.scoreThem = tmp1.scoreThem;
                            
                            
                            if (tmp1.isCanceled) {
                                tmp1Button.canceledLabel.text = @"CANCELED";
                            }else{
                                tmp1Button.canceledLabel.text = @"";
                            }
                            
                            tmp1Button.yesCount.text = @"44";
                            
                            tmp1Button.yesCount.text = tmp1.scoreUs;
                            tmp1Button.noCount.text = tmp1.scoreThem;
                            
                            NSString *time = @"";
                            int interval = [tmp1.gameInterval intValue];
                            
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
                                time = [NSString stringWithFormat:@"%@th", tmp1.gameInterval];
                            }
                            
                            if (interval == -1) {
                                time = @"F";
                            }
                            
                            if (interval == -2) {
                                time = @"OT";
                            }
                            
                            
                            if (interval == -3) {
                                time = @"";
                            }
                            
                            tmp1Button.qLabel.text = time;
                            
                            tmp1Button.eventLabel.text = tmp1.eventLabel;
                            [tmp1Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                            [controller.view addSubview:tmp1Button];
                                                        
                        }
                        
                            
                        
                    }else if ([tmp1.eventType isEqualToString:@"scores"] || [tmp1.eventType isEqualToString:@"newTeam"]){
                        
                        
                        EventNowButton *tmp1Button = [[EventNowButton alloc] initWithFrame:CGRectMake(56, 25, 50, 50)];
                        tmp1Button.event = tmp1;
                        
                        if (![tmp1.teamName isEqualToString:@""]) {
                            tmp1Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp1.teamName];
                        }else {
                            tmp1Button.teamLabel.text = @"";
                        }
                        
                        
                        if (tmp1.isCanceled) {
                            tmp1Button.canceledLabel.text = @"CANCELED";
                        }else{
                            tmp1Button.canceledLabel.text = @"";
                        }
                        
                        tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                        tmp1Button.eventLabel.text = tmp1.eventLabel;
                        [tmp1Button setImage:[UIImage imageNamed:tmp1.imageName] forState:UIControlStateNormal];
                        [tmp1Button addTarget:self action:@selector(eventNow:) forControlEvents:UIControlEventTouchUpInside];
                        [controller.view addSubview:tmp1Button];
                        
                    }else{
                         
                        NSString *startDate = tmp1.eventDate;
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                        NSDate *eventDate = [dateFormat dateFromString:startDate];
                        
                       
                        if (![eventDate isEqualToDate:[eventDate earlierDate:[NSDate date]]]) {
                            
                            
                            AttendingButton *tmp1Button = [[AttendingButton alloc] initWithFrame:CGRectMake(36, 20, 92, 55)];
                            tmp1Button.event = tmp1;
                            tmp1Button.participantRole = tmp1.participantRole;
                            tmp1Button.teamId = tmp1.teamId;
                            tmp1Button.eventId = tmp1.eventId;
                            tmp1Button.sport = tmp1.sport;

                            
                            if (![tmp1.teamName isEqualToString:@""]) {
                                tmp1Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp1.teamName];
                            }else {
                                tmp1Button.teamLabel.text = @"";
                            }
                            
                            tmp1Button.teamName = tmp1.teamName;
                            
                            if ([tmp1.eventType isEqualToString:@"practice"]) {
                                tmp1Button.eventType = @"Practice";
                                
                            }else{
                                tmp1Button.eventType = @"Event";
                                
                            }
                            
                            [dateFormat setDateFormat:@"MM/dd"];
                            
                            tmp1Button.eventDate = [dateFormat stringFromDate:eventDate];
                            
                            if (tmp1.isCanceled) {
                                tmp1Button.canceledLabel.text = @"CANCELED";
                            }else{
                                tmp1Button.canceledLabel.text = @"";
                            }
                            
                            // tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                            tmp1Button.eventLabel.text = tmp1.eventLabel;
                            [tmp1Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                            [controller.view addSubview:tmp1Button];
                            
                            
                            
                        }else{ 
                            //present, future, display normally
                            EventNowButton *tmp1Button = [[EventNowButton alloc] initWithFrame:CGRectMake(56, 25, 50, 50)];
                            tmp1Button.event = tmp1;
                            
                            if (![tmp1.teamName isEqualToString:@""]) {
                                tmp1Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp1.teamName];
                            }else {
                                tmp1Button.teamLabel.text = @"";
                            }
                            
                            
                            if (tmp1.isCanceled) {
                                tmp1Button.canceledLabel.text = @"CANCELED";
                            }else{
                                tmp1Button.canceledLabel.text = @"";
                            }
                            
                            tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                            tmp1Button.eventLabel.text = tmp1.eventLabel;
                            [tmp1Button setImage:[UIImage imageNamed:tmp1.imageName] forState:UIControlStateNormal];
                            [tmp1Button addTarget:self action:@selector(eventNow:) forControlEvents:UIControlEventTouchUpInside];
                            [controller.view addSubview:tmp1Button];
                            
                        }
                    }
                    
                    
                    
                    
                    if ((2*j) + 1 < [self.allBottomButtons count]) {
                        
                        CurrentEvent *tmp2 = [self.allBottomButtons objectAtIndex:(2*j)+1];
                                                
                        if ([tmp2.eventType isEqualToString:@"game"]) {
                            
                            if ([tmp2.gameInterval isEqualToString:@"0"]) {
                                
                                
                                AttendingButton *tmp2Button = [[AttendingButton alloc] initWithFrame:CGRectMake(196, 20, 92, 55)];
                                tmp2Button.event = tmp2;
                                tmp2Button.isAttendance = true;
                                tmp2Button.participantRole = tmp2.participantRole;
                                tmp2Button.teamId = tmp2.teamId;
                                tmp2Button.eventId = tmp2.eventId;
                                tmp2Button.sport = tmp2.sport;

                                
                                if (![tmp2.teamName isEqualToString:@""]) {
                                    tmp2Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp2.teamName];
                                }else {
                                    tmp2Button.teamLabel.text = @"";
                                }
                                
                                NSString *startDate = tmp2.eventDate;
                                
                                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                                NSDate *eventDate = [dateFormat dateFromString:startDate];
                                
                                [dateFormat setDateFormat:@"MM/dd"];
                                
                                tmp2Button.eventDate = [dateFormat stringFromDate:eventDate];
                                tmp2Button.teamName = tmp2.teamName;
                                
                                tmp2Button.eventType = @"Game";
                                if (tmp2.isCanceled) {
                                    tmp2Button.canceledLabel.text = @"CANCELED";
                                }else{
                                    tmp2Button.canceledLabel.text = @"";
                                }
                                
                                //tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                                tmp2Button.eventLabel.text = tmp2.eventLabel;
                                //[tmp1Button setImage:[UIImage imageNamed:tmp1.imageName] forState:UIControlStateNormal];
                                [tmp2Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                                [controller.view addSubview:tmp2Button];
                            
                            }else{
                                //display the score
                                
                                ScoreButton *tmp2Button = [[ScoreButton alloc] initWithFrame:CGRectMake(196, 20, 92, 55)];
                                tmp2Button.event = tmp2;
                                tmp2Button.isAttendance = false;
                                
                                if (![tmp2.teamName isEqualToString:@""]) {
                                    tmp2Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp2.teamName];
                                }else {
                                    tmp2Button.teamLabel.text = @"";
                                }
                                
                                tmp2Button.teamName = tmp2.teamName;
                                tmp2Button.interval = tmp2.gameInterval;
                                tmp2Button.scoreUs = tmp2.scoreUs;
                                tmp2Button.scoreThem = tmp2.scoreThem;
                                
                                
                                if (tmp2.isCanceled) {
                                    tmp2Button.canceledLabel.text = @"CANCELED";
                                }else{
                                    tmp2Button.canceledLabel.text = @"";
                                }
                                
                                tmp2Button.yesCount.text = tmp2.scoreUs;
                                tmp2Button.noCount.text = tmp2.scoreThem;
                                
                                NSString *time = @"";
                                int interval = [tmp2.gameInterval intValue];
                                
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
                                    time = [NSString stringWithFormat:@"%@th", tmp2.gameInterval];
                                }
                                
                                if (interval == -1) {
                                    time = @"F";
                                }
                                
                                if (interval == -2) {
                                    time = @"OT";
                                }
                                
                                
                                if (interval == -3) {
                                    time = @"";
                                }
                                
                                tmp2Button.qLabel.text = time;
                                
                                tmp2Button.eventLabel.text = tmp2.eventLabel;
                                // [tmp1Button setImage:[UIImage imageNamed:tmp1.imageName] forState:UIControlStateNormal];
                                [tmp2Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                                [controller.view addSubview:tmp2Button];
                                                              
                            }
                            
                        }else if ([tmp2.eventType isEqualToString:@"scores"] || [tmp2.eventType isEqualToString:@"newTeam"]){
                            
                            
                            EventNowButton *tmp2Button = [[EventNowButton alloc] initWithFrame:CGRectMake(216, 25, 50, 50)];
                            tmp2Button.event = tmp2;
                            
                            if (![tmp2.teamName isEqualToString:@""]) {
                                tmp2Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp2.teamName];
                            }else {
                                tmp2Button.teamLabel.text = @"";
                            }
                            
                            
                            if (tmp2.isCanceled) {
                                tmp2Button.canceledLabel.text = @"CANCELED";
                            }else{
                                tmp2Button.canceledLabel.text = @"";
                            }
                            
                            tmp2Button.scoreLabel.text = tmp2.scoreLabel;
                            tmp2Button.eventLabel.text = tmp2.eventLabel;
                            [tmp2Button setImage:[UIImage imageNamed:tmp2.imageName] forState:UIControlStateNormal];
                            [tmp2Button addTarget:self action:@selector(eventNow:) forControlEvents:UIControlEventTouchUpInside];
                            [controller.view addSubview:tmp2Button];
                            
                        }else{
                            
                            NSString *startDate = tmp2.eventDate;
                            
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                            NSDate *eventDate = [dateFormat dateFromString:startDate];
                            
                            
                            if (![eventDate isEqualToDate:[eventDate earlierDate:[NSDate date]]]) {
                                //past, display attendance
                                
                                AttendingButton *tmp2Button = [[AttendingButton alloc] initWithFrame:CGRectMake(196, 20, 92, 55)];
                                tmp2Button.event = tmp2;
                                tmp2Button.participantRole = tmp2.participantRole;
                                tmp2Button.teamId = tmp2.teamId;
                                tmp2Button.eventId = tmp2.eventId;
                                tmp2Button.sport = tmp2.sport;

                                
                                
                                if (![tmp2.teamName isEqualToString:@""]) {
                                    tmp2Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp2.teamName];
                                }else {
                                    tmp2Button.teamLabel.text = @"";
                                }
                                
                                tmp2Button.teamName = tmp2.teamName;
                                
                                
                                [dateFormat setDateFormat:@"MM/dd"];
                                
                                tmp2Button.eventDate = [dateFormat stringFromDate:eventDate];
                                if ([tmp2.eventType isEqualToString:@"practice"]) {
                                    tmp2Button.eventType = @"Practice";
                                    
                                }else{
                                    tmp2Button.eventType = @"Event";
                                    
                                }
                                
                                if (tmp2.isCanceled) {
                                    tmp2Button.canceledLabel.text = @"CANCELED";
                                }else{
                                    tmp2Button.canceledLabel.text = @"";
                                }
                                
                                // tmp1Button.scoreLabel.text = tmp1.scoreLabel;
                                tmp2Button.eventLabel.text = tmp2.eventLabel;
                                // [tmp1Button setImage:[UIImage imageNamed:tmp1.imageName] forState:UIControlStateNormal];
                                [tmp2Button addTarget:self action:@selector(eventNowAttending:) forControlEvents:UIControlEventTouchUpInside];
                                [controller.view addSubview:tmp2Button];
                                
                                
                            }else{
                                //present, future, display normally
                                EventNowButton *tmp2Button = [[EventNowButton alloc] initWithFrame:CGRectMake(216, 25, 50, 50)];
                                tmp2Button.event = tmp2;
                                
                                if (![tmp2.teamName isEqualToString:@""]) {
                                    tmp2Button.teamLabel.text = [NSString stringWithFormat:@"(%@)", tmp2.teamName];
                                }else {
                                    tmp2Button.teamLabel.text = @"";
                                }
                                
                                if (tmp2.isCanceled) {
                                    tmp2Button.canceledLabel.text = @"CANCELED";
                                }else{
                                    tmp2Button.canceledLabel.text = @"";
                                }
                                
                                tmp2Button.scoreLabel.text = tmp2.scoreLabel;
                                tmp2Button.eventLabel.text = tmp2.eventLabel;
                                [tmp2Button setImage:[UIImage imageNamed:tmp2.imageName] forState:UIControlStateNormal];
                                [tmp2Button addTarget:self action:@selector(eventNow:) forControlEvents:UIControlEventTouchUpInside];
                                [controller.view addSubview:tmp2Button];
                            }
                        }
                        
                        
                    }
                    
                
                }

            }
			
		}
		
		
	
        [self.scrollView addSubview:controller.view];
    }
}

-(void)addScrollViews{
    
}

-(void)eventNowAttending:(id)sender{
    
    if (self.isMoreShowing) {
        
        if ([sender class] == [AttendingButton class]) {
            homeAttendanceView.view.hidden = NO;
            homeScoreView.view.hidden = YES;
            
            AttendingButton *tmp = (AttendingButton *)sender;
            
            
            homeAttendanceView.teamName = tmp.teamName;
            homeAttendanceView.eventDate = tmp.eventDate;
            homeAttendanceView.eventType = tmp.eventType;
            homeAttendanceView.teamId = tmp.teamId;
            homeAttendanceView.participantRole = tmp.participantRole;
            homeAttendanceView.eventId = tmp.eventId;
            homeAttendanceView.sport = tmp.sport;

        
            
            homeAttendanceView.yesCount = @"12";
            homeAttendanceView.noCount = @"2";
            homeAttendanceView.noReplyCount = @"5";
            
            [homeAttendanceView setLabels];

        }else{
            
            ScoreButton *tmp = (ScoreButton *)sender;
            
            homeScoreView.view.hidden = NO;
            homeAttendanceView.view.hidden = YES;
            homeScoreView.teamName = tmp.teamName;
            homeScoreView.scoreUs = tmp.scoreUs;
            homeScoreView.scoreThem = tmp.scoreThem;
            homeScoreView.interval = tmp.interval;
            [homeScoreView setLabels];
        }
        
    }else{
        
        if ([sender class] == [AttendingButton class]) {
            self.homeAttendanceView.view.hidden = NO;
            
            AttendingButton *tmp = (AttendingButton *)sender;
                        
            homeAttendanceView.teamName = tmp.teamName;
            homeAttendanceView.eventDate = tmp.eventDate;
            homeAttendanceView.eventType = tmp.eventType;
            homeAttendanceView.teamId = tmp.teamId;
            homeAttendanceView.participantRole = tmp.participantRole;
            homeAttendanceView.eventId = tmp.eventId;
            homeAttendanceView.sport = tmp.sport;

            
            homeAttendanceView.yesCount = @"12";
            homeAttendanceView.noCount = @"2";
            homeAttendanceView.noReplyCount = @"5";
            
            [homeAttendanceView setLabels];
        }else{
            
            ScoreButton *tmp = (ScoreButton *)sender;
            
            homeScoreView.view.hidden = NO;
            homeScoreView.teamName = tmp.teamName;
            homeScoreView.scoreUs = tmp.scoreUs;
            homeScoreView.scoreThem = tmp.scoreThem;
            homeScoreView.interval = tmp.interval;
            [homeScoreView setLabels];
        }
        
        [self moveDivider];

    }
    
}


-(void)eventNow:(id)sender{
	
	self.serverError.text = @"";

	EventNowButton *tmpButton = (EventNowButton *)sender;
	
	CurrentEvent *tmpEvent = tmpButton.event;
	
	if (tmpEvent.isCanceled) {
		
		self.undoEventType = tmpEvent.eventType;
		self.undoEventId = tmpEvent.eventId;
		self.undoTeamId = tmpEvent.teamId;
		
		self.undoCancel = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
		self.undoCancel.actionSheetStyle = UIActionSheetStyleDefault;
		[self.undoCancel showInView:self.view];
		
	}else {
		        
		NSString *eventType = tmpEvent.eventType;
		
		if ([eventType isEqualToString:@"game"]) {
			
			
			NSString *tmpUserRole = tmpEvent.participantRole;
			NSString *tmpTeamId = tmpEvent.teamId;
			
			if ([tmpUserRole isEqualToString:@"creator"] || [tmpUserRole isEqualToString:@"coordinator"]) {
				GameTabs *currentGameTab = [[GameTabs alloc] init];
				currentGameTab.fromHome = true;
				
				NSArray *tmpViews = currentGameTab.viewControllers;
				currentGameTab.teamId = tmpTeamId;
				currentGameTab.gameId = tmpEvent.eventId;
				currentGameTab.userRole = tmpUserRole;
				currentGameTab.teamName = tmpEvent.teamName;
				
				Gameday *currentNotes = [tmpViews objectAtIndex:0];
				currentNotes.gameId = tmpEvent.eventId;
				currentNotes.teamId = tmpTeamId;
				currentNotes.userRole = tmpUserRole;
				currentNotes.sport = tmpEvent.sport;
				currentNotes.description = tmpEvent.description;
				currentNotes.startDate = tmpEvent.eventDate;
				currentNotes.opponentString = @"";

				GameAttendance *currentAttendance = [tmpViews objectAtIndex:1];
				currentAttendance.gameId = tmpEvent.eventId;
				currentAttendance.teamId = tmpTeamId;
				currentAttendance.startDate = tmpEvent.eventDate;

				Vote *fans = [tmpViews objectAtIndex:2];
				fans.teamId = tmpEvent.teamId;
				fans.userRole = tmpEvent.participantRole;
				fans.gameId = tmpEvent.eventId;
				
				
				UINavigationController *navController = [[UINavigationController alloc] init];
				
				[navController pushViewController:currentGameTab animated:YES];
				
                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
				[self.navigationController presentModalViewController:navController animated:YES];
				
			}else {
				
				GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
				currentGameTab.fromHome = true;
				NSArray *tmpViews = currentGameTab.viewControllers;
				currentGameTab.teamId = tmpTeamId;
				currentGameTab.gameId = tmpEvent.eventId;
				currentGameTab.userRole = tmpUserRole;
				currentGameTab.teamName = tmpEvent.teamName;
	
				Gameday *currentNotes = [tmpViews objectAtIndex:0];
				currentNotes.gameId = tmpEvent.eventId;
				currentNotes.teamId = tmpTeamId;
				currentNotes.userRole = tmpUserRole;
				currentNotes.sport = tmpEvent.sport;
				currentNotes.description = tmpEvent.description;
				currentNotes.startDate = tmpEvent.eventDate;
				currentNotes.opponentString = @"";

				Vote *fans = [tmpViews objectAtIndex:1];
				fans.teamId = tmpEvent.teamId;
				fans.userRole = tmpEvent.participantRole;
				fans.gameId = tmpEvent.eventId;
				
				UINavigationController *navController = [[UINavigationController alloc] init];
				
				[navController pushViewController:currentGameTab animated:YES];
				
                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
				[self.navigationController presentModalViewController:navController animated:YES];
				
			}
			
			
			
		}else if ([eventType isEqualToString:@"practice"]) {
			
			PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
			
			
			currentPracticeTab.fromHome = true;
			
			NSString *tmpUserRole = tmpEvent.participantRole;
			NSString *tmpTeamId = tmpEvent.teamId;
			
			
			
			NSArray *tmpViews = currentPracticeTab.viewControllers;
			currentPracticeTab.teamId = tmpTeamId;
			currentPracticeTab.practiceId = tmpEvent.eventId;
			currentPracticeTab.userRole = tmpUserRole;
			
			PracticeNotes *currentNotes = [tmpViews objectAtIndex:0];
			currentNotes.practiceId = tmpEvent.eventId;
			currentNotes.teamId = tmpTeamId;
			currentNotes.userRole = tmpUserRole;
			
			
			PracticeAttendance *currentAttendance = [tmpViews objectAtIndex:1];
			currentAttendance.practiceId = tmpEvent.eventId;
			currentAttendance.teamId = tmpTeamId;
			currentAttendance.userRole = tmpEvent.participantRole;
			currentAttendance.startDate = tmpEvent.eventDate;
            
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:currentPracticeTab animated:YES];
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:navController animated:YES];
			
			
		}else if ([eventType isEqualToString:@"generic"]) {
			
			EventTabs *currentPracticeTab = [[EventTabs alloc] init];
			
			currentPracticeTab.fromHome = true;
			
			NSString *tmpUserRole = tmpEvent.participantRole;
			NSString *tmpTeamId = tmpEvent.teamId;
			
			
			
			NSArray *tmpViews = currentPracticeTab.viewControllers;
			currentPracticeTab.teamId = tmpTeamId;
			currentPracticeTab.eventId = tmpEvent.eventId;
			currentPracticeTab.userRole = tmpUserRole;
			
			EventNotes *currentNotes = [tmpViews objectAtIndex:0];
			currentNotes.eventId = tmpEvent.eventId;
			currentNotes.teamId = tmpTeamId;
			currentNotes.userRole = tmpUserRole;
			
			
			EventAttendance *currentAttendance = [tmpViews objectAtIndex:1];
			currentAttendance.eventId = tmpEvent.eventId;
			currentAttendance.teamId = tmpTeamId;
			currentAttendance.userRole = tmpEvent.participantRole;
			
			currentAttendance.startDate = tmpEvent.eventDate;
		
			
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:currentPracticeTab animated:YES];
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:navController animated:YES];
			
			
		}else if ([eventType isEqualToString:@"scores"]) {
			//Go to a scores page?
			Scores *tmp = [[Scores alloc] init];
			
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:tmp animated:YES];
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

			[self.navigationController presentModalViewController:navController animated:YES];
			
		}else if ([eventType isEqualToString:@"newTeam"]) {
			//TeamsTabs *tmp = [[TeamsTabs alloc] init];
			//NSArray *views = tmp.viewControllers;
			MyTeams *tmpTeams = [[MyTeams alloc] init];
			tmpTeams.quickCreate = true;
            tmpTeams.fromHome = true;
			
			UINavigationController *navController = [[UINavigationController alloc] init];
			
			[navController pushViewController:tmpTeams animated:NO];
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self.navigationController presentModalViewController:navController animated:NO];
		}
		
	}

}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    	
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
     
    
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)changePage:(id)sender {
    
    int page = self.pageControl.currentPage;
	
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}



-(void)fast{
	
}

//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
    
    [self.view bringSubviewToFront:self.backViewBottom];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	    
    if (!self.bannerIsVisible) {
        
        self.bannerIsVisible = YES;
        myAd.hidden = NO;
        [self.view bringSubviewToFront:myAd];  
        
        if (self.isMoreShowing) {
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            
            
            
            CGRect attFrame;
            attFrame = self.homeAttendanceView.view.frame;
            attFrame.size.height -= 50;
            self.homeAttendanceView.view.frame = attFrame;
            
            
            [UIView commitAnimations];
            
        }else{
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            
            [self.view bringSubviewToFront:self.registrationBackView];
            
            CGRect hapFrame;
            hapFrame = self.happeningNowView.frame;
            hapFrame.origin.y -= 50;
            self.happeningNowView.frame = hapFrame;
            
            CGRect attFrame;
            attFrame = self.homeAttendanceView.view.frame;
            attFrame.origin.y -= 50;
            self.homeAttendanceView.view.frame = attFrame;
            
            CGRect scoreFrame;
            scoreFrame = self.homeScoreView.view.frame;
            scoreFrame.origin.y -= 50;
            self.homeScoreView.view.frame = scoreFrame;
            
            self.bottomBar.frame = CGRectMake(0, 322, 320, 44);
            self.refreshQbutton.frame = CGRectMake(275, 319, 50, 50);
            self.aboutButton.frame = CGRectMake(85, 325, 150, 35);
            
            [UIView commitAnimations];
            
            [self.view bringSubviewToFront:self.bottomBar];
            
            if (!self.changeQuickLinkBack.hidden) {
                [self.view bringSubviewToFront:self.changeQuickLinkBack];
                
                if (!self.displayIconsScroll.hidden) {
                    [self.view bringSubviewToFront:self.displayIconsScroll];
                }
            }
            
        }
        
        
        
        
        
        if (self.backViewBottom.hidden == NO) {
            [self.view bringSubviewToFront:self.backViewBottom];
            CGRect frame = self.backViewBottom.frame;
            frame.size.height -= 50;
            self.backViewBottom.frame = frame;
            [self.navigationController.navigationBar bringSubviewToFront:self.backViewTop];
        }
        
        [self.view bringSubviewToFront:self.blueArrow];
	}

    
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{

    
    self.myAd.hidden = YES;
	if (self.bannerIsVisible) {

		self.bannerIsVisible = NO;
        
        
        self.bottomBar.frame = CGRectMake(0, 372, 320, 44);
        self.refreshQbutton.frame = CGRectMake(275, 369, 50, 50);
        self.aboutButton.frame = CGRectMake(85, 375, 150, 35);
        
   

        

	}
	
	
}

-(void)newIconSelected:(id)sender{
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	UIButton *tmp = (UIButton *)sender;
	int buttonTag = tmp.tag;
	
		self.alreadyCalled1 = false;
		
		if (buttonTag == 0) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"footballOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"football";
		}else if (buttonTag == 1) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"basketballOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"basketball";

		}else if (buttonTag == 2) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"baseballOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"baseball";

		}else if (buttonTag == 3) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"soccerOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"soccer";

		}else if (buttonTag == 4) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"hockeyOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"hockey";

		}else if (buttonTag == 5) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"lacrosseOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"lacrosse";

		}else if (buttonTag == 6) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"tennisOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"tennis";

		}else if (buttonTag == 7) {
			[self.shortcutButton setImage:[UIImage imageNamed:@"volleyballOnly.png"] forState:UIControlStateNormal];
			mainDelegate.quickLinkOneImage = @"volleyball";

		}else {
			[self.shortcutButton setImage:[UIImage imageNamed:@"gen80.png"] forState:UIControlStateNormal];
			 mainDelegate.quickLinkOneImage = @"";
		}


		
	[self performSelectorInBackground:@selector(updateUserIcons) withObject:nil];

	self.displayIconsScrollBack.hidden = YES;
	self.changeQuickLinkBack.hidden = YES;

}

-(void)cancelNewIcons{
	
	self.displayIconsScrollBack.hidden = YES;
}

-(void)changeQuickLinkIcon{
	
	self.displayIconsScrollBack.hidden = NO;
	[self.view bringSubviewToFront:self.displayIconsScrollBack];
}

-(NSString *)getQuickLinkImageOne{
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (mainDelegate.quickLinkOneImage == nil) {
		mainDelegate.quickLinkOneImage = @"";
	}
	
	NSString *tmp = mainDelegate.quickLinkOneImage;
	
	tmp = [tmp lowercaseString];

	if ([tmp isEqualToString:@""]) {
		return @"gen80.png";
	}else if ([tmp isEqualToString:@"football"]) {
		return @"footballOnly.png";
	}else if ([tmp isEqualToString:@"soccer"]) {
		return @"soccerOnly.png";
	}else if ([tmp isEqualToString:@"basketball"]) {
		return @"basketballOnly.png";
	}else if ([tmp isEqualToString:@"baseball"]) {
		return @"baseballOnly.png";
	}else if ([tmp isEqualToString:@"hockey"]) {
		return @"hockeyOnly.png";
	}else if ([tmp isEqualToString:@"lacrosse"]) {
		return @"lacrosseOnly.png";
	}else if ([tmp isEqualToString:@"tennis"]) {
		return @"tennisOnly.png";
	}else if ([tmp isEqualToString:@"volleyball"]) {
		return @"volleyballOnly.png";
	}
	
	return @"gen80.png";
}


-(int)getIconHeight:(NSString *)sport{

    if ([sport isEqualToString:@"lacrosse"]) {
		return 150;
	}else if ([sport isEqualToString:@"hockey"]) {
		return 154;
	}else if ([sport isEqualToString:@""]) {
		//generic
		return 146;
	}else {
		return 149;
	}

	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheetHome *actionSheet = [[FastActionSheetHome alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.undoCancel) {
		
		if (buttonIndex == 1) {
			//Undo cancel
            
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Activate Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			
			[self.eventsNowActivity startAnimating];
			[self performSelectorInBackground:@selector(activateEvent) withObject:nil];			
			
		}else if (buttonIndex == 0) {
			[self.eventsNowActivity startAnimating];
			
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Delete Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			[self performSelectorInBackground:@selector(deleteEvent) withObject:nil];
			
		}else {
			
		}
		
	}else {
		[FastActionSheetHome doAction:self :buttonIndex];

	}

	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)getUserInfo{

	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI getUserInfo:token :@"false"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *info = [response valueForKey:@"userInfo"];
                
                NSString *firstName = [info valueForKey:@"firstName"];
                NSString *lastName = [info valueForKey:@"lastName"];
                
                mainDelegate.displayName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
                
            }else{
                
                
            }
            
            
        }

    }
	
}


-(void)deleteEvent{

	@autoreleasepool {
        //Delete Event
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([self.undoEventType isEqualToString:@"game"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteGame:token :self.undoTeamId :self.undoEventId];
                
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
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
                
                
            }
            
        }else if ([self.undoEventType isEqualToString:@"practice"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.undoTeamId :self.undoEventId];
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
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
        }else {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.undoTeamId :self.undoEventId];
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
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
            
            
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];
    }
	
}


-(void)activateEvent{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([self.undoEventType isEqualToString:@"game"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateGame:token :self.undoTeamId :self.undoEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"" :@"" :@""];
                
                
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
            
        }else if ([self.undoEventType isEqualToString:@"practice"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.undoTeamId :self.undoEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
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
                            ///self.error.text = @"*Error connecting to server";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
        }else {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.undoTeamId :self.undoEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            ///null parameter
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
        
        
        [self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];

    }
		
}

-(void)doneEventEdit{
	
    if ([self.errorString isEqualToString:@"NA"]) {
        self.errorString = @"";
        NSString *tmp = @"You are not a coordinator, or you have not confirmed your email.  Only User's with confirmed email addresses can delete events.  To confirm your email, please click on the activation link in the email we sent you.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
	[self performSelectorInBackground:@selector(getEventsNow) withObject:nil];
	
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString = @"";
			break;
		case MessageComposeResultSent:
			displayString = @"Text sent successfully!";
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
			break;
		default:
			displayString = @"Text send failed.";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	
	
}

-(void)refresh{
    
    [self.eventsNowActivity startAnimating];
    self.serverError.text = @"";
    [self viewWillAppear:NO];
    //[self.view bringSubviewToFront:myAd];

}

-(void)question{
    
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Click Help Question Mark"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
    if (self.bannerIsVisible) {
        self.refreshQbutton.frame = CGRectMake(275, 319, 50, 50);
        self.aboutButton.frame = CGRectMake(85, 325, 150, 35);
        self.backViewBottom.frame = CGRectMake(0, 0, 320, 366);


    }else{
        self.refreshQbutton.frame = CGRectMake(275, 369, 50, 50);
        self.aboutButton.frame = CGRectMake(85, 375, 150, 35);
        self.backViewBottom.frame = CGRectMake(0, 0, 320, 416);


    }
    self.helpExplanation.text = @"";
    self.backViewBottom.hidden = NO;
    self.backViewTop.hidden = NO;
    [self.view bringSubviewToFront:self.backViewBottom];
    [self.navigationController.navigationBar bringSubviewToFront:self.backViewTop];
    //[self.view bringSubviewToFront:myAd];
    

}

-(void)helpButtonClicked:(id)sender{
    
    UIButton *tmpButton = (UIButton *)sender;
    
    [self.myTeamsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.activityQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.messagesQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.eventsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.quickLinksQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.happeningNowQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.helpQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.inviteFanQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.refreshQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.settingQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.searchQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];

    int location = tmpButton.tag;

    
    if (location == 1){
        
        self.helpExplanation.text = @"The Settings page allows you to do things like change password information, your profile picture, or log out of the app.  You can also sync your rTeam Events to your iPhone Calendar in 'Settings'.";
         [self.settingQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];
        
    }else if (location == 2){
        
        self.helpExplanation.text = @"Going to the 'Search' page will allow you to search for any Team, Member, or Fan that you are connected with via rTeam.";
         [self.searchQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];
        
    }else if (location == 3){
        
        self.helpExplanation.text = @"The 'Teams' page will show you a list of all teams you are a Member or Fan of.  You can also create new teams from this page.";
        [self.myTeamsQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 4){
        
        self.helpExplanation.text = @"The 'Activity' page allows you to post text, pictures, or videos to a live feed that is viewable by anybody on your team.  You also have the option of connecting this feed to Twitter.";
        [self.activityQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 5){
        
        self.helpExplanation.text = @"The 'Activity' page will show you all of the messages or polls that you have sent or received, in a live feed format.  You may also send messages from this page.";
        [self.messagesQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 6){
        
        self.helpExplanation.text = @"The 'Events' page shows all of the Games, Practices, and Events that are scheduled for all of your teams.  You can see all of these events in a Calendar View, or a List View.";
        [self.eventsQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 7){
        
        self.helpExplanation.text = @"The team shortcut icon will take you directly to this team's Home page.  You can change which team this shortcut is for by pressing and holding on the icon.";
        [self.quickLinksQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 8){
        
        self.helpExplanation.text = @"The 'Happening Now' section shows all of the Games, Practices, or Events you have scheduled within the next two days.  Games will display a current or final score, if there is one.";
        [self.happeningNowQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 9){
        
        self.helpExplanation.text = @"The 'Help' button takes you to a page that has tutorials on how to use rTeam.  Learn how to Create a Team, Add Members, Events, or anything else to get your team going.  You can also leave us feedback.";
        [self.helpQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 10){
        
        self.helpExplanation.text = @"This button allows you to invite a fan to any of your teams.  Fans can follow along with the Schedules, Rosters, and Scores either by Email, SMS, or by downloading the rTeam app.";
        [self.inviteFanQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

        
    }else if (location == 11){
        
        self.helpExplanation.text = @"The 'Refresh' button refreshes your Home screen, and updates any changed information in your Message/Activity counts, as well as the entire 'Whats Happening Now' section.";
        [self.refreshQbutton setImage:[UIImage imageNamed:@"qcircleSelected.png"] forState:UIControlStateNormal];

    }
    
}

-(void)closeQuestion{
    
    [self.myTeamsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.activityQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.messagesQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.eventsQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.quickLinksQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.happeningNowQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.helpQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.inviteFanQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.refreshQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.settingQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    [self.searchQbutton setImage:[UIImage imageNamed:@"qcircle.png"] forState:UIControlStateNormal];
    
    self.helpExplanation.text = @"";
    self.backViewBottom.hidden = YES;
    self.backViewTop.hidden = YES;
    
}


-(void)hide{
    homeScoreView.view.hidden = YES;
    homeAttendanceView.view.hidden = YES;

}

-(void)moveDivider{
  
    if (self.isMoreShowing) {
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        
        self.bottomBar.hidden = NO;
        [self.view bringSubviewToFront:self.bottomBar];

        CGRect frame = self.happeningNowView.frame;
        if (self.bannerIsVisible) {
            frame.origin.y = 201;
        }else{
            frame.origin.y = 251;
        }
        self.happeningNowView.frame = frame;

        
        CGRect frame1 = self.homeAttendanceView.view.frame;
        if (self.bannerIsVisible) {
            frame1.origin.y = 322;
        }else{
            frame1.origin.y = 372;
        }
        self.homeAttendanceView.view.frame = frame1;
        
        CGRect frame2 = self.homeScoreView.view.frame;
        if (self.bannerIsVisible) {
            frame2.origin.y = 322;
        }else{
            frame2.origin.y = 372;
        }
        self.homeScoreView.view.frame = frame2;
        
     
        [UIView commitAnimations];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.0];

        self.isMoreShowing = NO;

    }else{
   
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        
        int init = 0;
        bool isAd = false;
        if (self.bannerIsVisible) {
            init = 50;
            isAd = true;
        }
  
        homeAttendanceView.view.clipsToBounds = YES;
        
        
        CGRect frame = self.happeningNowView.frame;
        frame.origin.y = 0;
        self.happeningNowView.frame = frame;
        
        CGRect frame1 = self.homeAttendanceView.view.frame;
        frame1.origin.y = 121;
        if (isAd) {
            frame1.size.height = 245;
        }else{
            frame1.size.height = 295;
        }
        self.homeAttendanceView.view.frame = frame1;
        
        CGRect frame2 = self.homeScoreView.view.frame;
        frame2.origin.y = 121;
        if (isAd) {
            frame2.size.height = 245;
        }else{
            frame2.size.height = 295;
        }
        self.homeScoreView.view.frame = frame2;

        self.bottomBar.hidden = YES;
       
        
        [UIView commitAnimations];
        
        homeScoreView.initY = init;
        homeAttendanceView.initY = 0;
        self.isMoreShowing = YES;
        
        if (self.bannerIsVisible){
            [self.view bringSubviewToFront:myAd];

        }
        


    }
     

}

-(void)regText{
    [self.view bringSubviewToFront:self.registrationBackView];
    [self.view bringSubviewToFront:self.blueArrow];
    self.blueArrow.hidden = YES;
    
    if(self.currentDisplay == 1){
        
        self.currentDisplay = 2;
        self.regTextView.text = @"This is your Home screen.  To get back here from anywhere else, just shake your phone to activate the 'Quick Link' menu, then select 'Home'.";
    }else if (self.currentDisplay == 2){
    
        if (self.createdTeam) {
            self.currentDisplay =3;
            
            self.regTextView.text = @"We have created your first team for you!  This shortcut will take you to your team page.  To edit this shortcut, press and hold the icon.";
            
            self.textBackView.frame = CGRectMake(10, 10, 170, 200);
            self.textFrontView.frame = CGRectMake(2, 2, 166, 196);
            self.blueArrow.hidden = NO;
            self.blueArrow.frame = CGRectMake(118, 120, 75, 44);
            self.regTextButton.frame = CGRectMake(20, 145, 67, 37);
        }else{
            self.registrationBackView.hidden = YES;
        }
       
 
 
        
    }else{
        self.registrationBackView.hidden = YES;
    }
    
}
- (void)viewDidUnload {

	bottomBar = nil;
    backHelpView = nil;
	inviteFan = nil;
	serverError = nil;

	changeQuickLink = nil;
	newQuickLinkAlias = nil;
	newQuickLinkTable = nil;
	messageBadge = nil;
	activityGettingTeams = nil;
	eventsNowActivity = nil;
	selectRowLabel = nil;
	eventsButton = nil;
	myTeamsButton = nil;
	messagesButton = nil;
    myAd.delegate = nil;
	myAd = nil;
	displayIconsScroll = nil;
	changeIconButton = nil;

	displayIconsScrollBack = nil;
	changeQuickLinkBack = nil;
    refreshButton = nil;
    questionButton = nil;

    registrationBackView = nil;
    regTextButton = nil;
    regTextView = nil;
    textBackView = nil;
    textFrontView = nil;
    shortcutButton = nil;
    quickLinkChangeButton = nil;
    quickLinkCancelButton = nil;
    quickLinkOkButton = nil;
    quickLinkCancelTwoButton = nil;
    blueArrow = nil;
    
    homeScoreView = nil;
    homeAttendanceView = nil;
    happeningNowView = nil;
    scrollView = nil;
    pageControl = nil;
    
	[super viewDidUnload];
	

	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

