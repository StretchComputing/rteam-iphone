//
//  HomeAttendanceView.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeAttendanceView.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "PracticeTabs.h"
#import "EventTabs.h"
#import "Gameday.h"
#import "GameAttendance.h"
#import "Vote.h"
#import "PracticeAttendance.h"
#import "EventAttendance.h"
#import "PracticeNotes.h"
#import "EventNotes.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "GANTracker.h"
#import "ViewDetailPollRepliesNow.h"
#import "GoogleAppEngine.h"
#import "TraceSession.h"
#import "MapLocation.h"
#import "HomeScoreView.h"



@implementation HomeAttendanceView
@synthesize initY, teamName, teamLabel, yesCount, yesLabel, noCount, noLabel, noReplyCount, noReplyLabel, dateLabel, eventDate, eventType, pollButton, goToButton, participantRole, teamId, eventId, sport, pollActivity, pollLabel, maybeCount, maybeLabel, pollDescription, currentMemberId, currentMemberResponse, statusReply, statusButton, messageThreadId, eventDescription, eventStringDate, attendees, eventLinkLabel, lineView, isFullScreen, fullScreenButton, homeSuperView, latitude, longitude, mapButton, startScoreButton, opponent, startedScoring, myAd, bannerIsVisible, frontView;

-(void)viewDidAppear:(BOOL)animated{
    
    
    if (self.startedScoring) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self dismissModalViewControllerAnimated:NO];
    }else{
        if (self.bannerIsVisible) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            
            myAd.frame = CGRectMake(0, 430, 320, 50);
            self.frontView.frame = CGRectMake(0, 0, 320, 430);
            
            
            
            [UIView commitAnimations];
        }else{
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];
            
            self.frontView.frame = self.view.frame;
            
            [UIView commitAnimations];
            
        }
    }
   
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    if (self.startedScoring) {
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        
        UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLogoNoCrowd.png"]];
        tmp.frame = CGRectMake(0, 0, 320, 480);
        [self.view addSubview:tmp];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140, 100, 40, 40);
        [activity startAnimating];
        
        [self.view addSubview:activity];
            
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        
        [self setLabels];
    }
   
    

    
}

- (void)viewDidLoad
{
    [TraceSession addEventToSession:@"HomeAttendanceView - View Did Load"];

    myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 480, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.pollButton setBackgroundImage:stretch forState:UIControlStateNormal];
    

    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.statusButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
    [self.startScoreButton setBackgroundImage:stretch1 forState:UIControlStateNormal];



    [super viewDidLoad];
}

-(void)setLabels{
    
    if ([self.eventType isEqualToString:@"Game"]) {
        self.startScoreButton.hidden = NO;
    }else{
        self.startScoreButton.hidden = YES;
    }
    
    if (![self.latitude isEqualToString:@""] && (self.latitude != nil)) {
        self.mapButton.hidden = NO;
    }else{
        self.mapButton.hidden = YES;
        
    }
    
    bool resend = false;
    if (self.messageThreadId != nil) {
        if (![self.messageThreadId isEqualToString:@""]) {
            resend = true;
        }
    }
    
    if (resend) {
        [self.pollButton setTitle:@"Re-Send Attendance Poll" forState:UIControlStateNormal];
    }else{
        [self.pollButton setTitle:@"Send Attendance Poll" forState:UIControlStateNormal];

    }
    self.teamLabel.text = [NSString stringWithFormat:@"%@", self.teamName];
    

    self.eventLinkLabel.frame = CGRectMake(191, 60, 175, 21);
    self.eventLinkLabel.backgroundColor = [UIColor clearColor];
    self.eventLinkLabel.text = [NSString stringWithFormat:@"%@ on %@", self.eventType, self.eventDate];
    self.eventLinkLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.eventLinkLabel.textColor = [UIColor blueColor];
    
    if ([self.eventType isEqualToString:@"Practice"]) {
        self.dateLabel.text = [NSString stringWithFormat:@"(expected attendance for                               )", self.eventType, self.eventDate];
        
        CGRect frame = self.eventLinkLabel.frame;
        frame.origin.x -= 10;
        self.eventLinkLabel.frame = frame;

    }else{
        self.dateLabel.text = [NSString stringWithFormat:@"(expected attendance for                           )", self.eventType, self.eventDate];


    }
    
    
    self.lineView.backgroundColor = [UIColor blueColor];
    int x = self.eventLinkLabel.frame.origin.x;
    
    CGSize constraints = CGSizeMake(900, 900);
    CGSize totalSize = [self.eventLinkLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] constrainedToSize:constraints];
    
    
    int width = totalSize.width;
    
    self.lineView.frame = CGRectMake(x+1, 78, width-2, 2);
    
    [self.goToButton setTitle:[NSString stringWithFormat:@"Poll Details", self.eventType] forState:UIControlStateNormal];
    self.yesLabel.text = self.yesCount;
    self.noLabel.text = self.noCount;
    self.noReplyLabel.text = noReplyCount;
    self.maybeLabel.text = self.maybeCount;
    
    //int totalHeight = self.view.frame.size.height;
    
    NSString *myReply = @"";
    
    if ([self.currentMemberResponse isEqualToString:@"yes"]) {
        myReply = @"Yes";
    }else if ([self.currentMemberResponse isEqualToString:@"no"]){
        myReply = @"No";
    }else if ([self.currentMemberResponse isEqualToString:@"maybe"]){
        myReply = @"Maybe";
    }else{
        myReply = @"No Reply";
    }
    self.statusReply.text = [NSString stringWithFormat:@"Your current status is '%@'", myReply];
    
    
    if ([self.participantRole isEqualToString:@"creator"] || [self.participantRole isEqualToString:@"coordinator"]) {
        self.pollButton.hidden = NO;
        self.pollDescription.hidden = NO;
        
        self.goToButton.frame = CGRectMake(191, self.goToButton.frame.origin.y, 109, 35);
        self.statusButton.frame = CGRectMake(20, self.statusButton.frame.origin.y, 129, 35);
        self.statusReply.frame = CGRectMake(-6, self.statusReply.frame.origin.y, 180, 21);
       
        [self.goToButton setTitle:[NSString stringWithFormat:@"Poll Details", self.eventType] forState:UIControlStateNormal];

        
    }else{
        self.pollButton.hidden = YES;
        self.pollDescription.hidden = YES;
        
        self.goToButton.frame = CGRectMake(80, self.goToButton.frame.origin.y, 160, 35);
        self.statusButton.frame = CGRectMake(95, self.statusButton.frame.origin.y, 130, 35);
        self.statusReply.frame = CGRectMake(0, self.statusReply.frame.origin.y, 320, 21);
        
        [self.goToButton setTitle:[NSString stringWithFormat:@"Poll Details", self.eventType] forState:UIControlStateNormal];


    }
    
    if ([self.participantRole isEqualToString:@"fan"]) {
        self.statusReply.hidden = YES;
        self.statusButton.hidden = YES;
        
    }else{
        self.statusButton.hidden = NO;
        self.statusReply.hidden = NO;
    }
    
    
   
    
}



-(void)sendPoll{
    [self.pollActivity startAnimating];
    self.pollButton.hidden = YES;
    if ([pollButton.titleLabel.text isEqualToString:@"Re-Send Attendance Poll"]) {
        [self performSelectorInBackground:@selector(resenedPoll) withObject:nil];
    }else{
        [self performSelectorInBackground:@selector(sendWhoPoll) withObject:nil];

    }
 
}

-(void)sendWhoPoll{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

        NSDictionary *response = [ServerAPI createMessageThread:mainDelegate.token teamId:self.teamId subject:@"" body:@"" type:@"whoiscoming" eventId:self.eventId eventType:self.eventType isAlert:@"" pollChoices:@[] recipients:@[] displayResults:@"" includeFans:@"" coordinatorsOnly:@""];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSString *didSucceed;
        if ([status isEqualToString:@"100"]) {
            //success
            didSucceed = @"yes";
            self.messageThreadId = [response valueForKey:@"messageThreadId"];
        }else{
            didSucceed = @"no";
            self.messageThreadId = @"";
        }

        
        [self performSelectorOnMainThread:@selector(donePoll:) withObject:didSucceed waitUntilDone:NO];
        
    }
}

-(void)donePoll:(NSString *)didSucceed{
    
    [self.pollActivity stopAnimating];
    
    if ([didSucceed isEqualToString:@"yes"]) {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Who's Coming Poll Sent - Happening Now"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        self.pollLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        self.pollLabel.text = @"Poll Sent!";
    }else{
        self.pollLabel.textColor = [UIColor redColor];
        self.pollLabel.text = @"*Poll Failed to Send*";
    }
    
    [self performSelector:@selector(resetUi) withObject:nil afterDelay:1.0];
    
}

-(void)resetUi{
    self.pollButton.hidden = NO;
    self.pollLabel.hidden = YES;
    [self setLabels];
}


-(void)pollDetails{
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    ViewDetailPollRepliesNow *tmp = [[ViewDetailPollRepliesNow alloc] init];
	tmp.replyArray = [NSArray arrayWithArray:self.attendees];
	tmp.teamId = self.teamId;
	tmp.isSender = true;
	
    tmp.finalized = false;
	
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    
    [navController pushViewController:tmp animated:YES];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
  
    [self presentModalViewController:navController animated:YES];
        
    
    
    
}
-(void)goToPage{
        
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Go To Event Page - Happening Now"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    if ([self.eventType isEqualToString:@"Game"]) {
        
        
        NSString *tmpUserRole = self.participantRole;
        NSString *tmpTeamId = self.teamId;
                
        if ([tmpUserRole isEqualToString:@"creator"] || [tmpUserRole isEqualToString:@"coordinator"]) {
            GameTabs *currentGameTab = [[GameTabs alloc] init];
            currentGameTab.fromHome = true;
            
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = self.eventId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = tmpViews[0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            currentNotes.startDate = self.eventStringDate;
            currentNotes.opponentString = @"";
            currentNotes.description = self.description;
            
  
            
            GameAttendance *currentAttendance = tmpViews[1];
            currentAttendance.gameId = self.eventId;
            currentAttendance.teamId = tmpTeamId;
            currentAttendance.startDate = self.eventStringDate;
            
            Vote *fans = tmpViews[2];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentModalViewController:navController animated:YES];
            
        }else {
            
            GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
            currentGameTab.fromHome = true;
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = self.eventId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = tmpViews[0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            currentNotes.description = self.eventDescription;
            currentNotes.startDate = self.eventStringDate;
            currentNotes.opponentString = @"";
            
            Vote *fans = tmpViews[1];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentModalViewController:navController animated:YES];

            
        }
        
        
        
    }else if ([self.eventType isEqualToString:@"Practice"]) {
        
        PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
        
        
        currentPracticeTab.fromHome = true;
        
        NSString *tmpUserRole = self.participantRole;
        NSString *tmpTeamId = self.teamId;
        
        
        
        NSArray *tmpViews = currentPracticeTab.viewControllers;
        currentPracticeTab.teamId = tmpTeamId;
        currentPracticeTab.practiceId = self.eventId;
        currentPracticeTab.userRole = tmpUserRole;
        
        PracticeNotes *currentNotes = tmpViews[0];
        currentNotes.practiceId = self.eventId;
        currentNotes.teamId = tmpTeamId;
        currentNotes.userRole = tmpUserRole;
        currentNotes.descriptionString = self.eventDescription;
        
        
        PracticeAttendance *currentAttendance = tmpViews[1];
        currentAttendance.practiceId = self.eventId;
        currentAttendance.teamId = tmpTeamId;
        currentAttendance.userRole = self.participantRole;
        currentAttendance.startDate = self.eventStringDate;
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        
        [navController pushViewController:currentPracticeTab animated:YES];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentModalViewController:navController animated:YES];

        
        
    }else{
        
        EventTabs *currentPracticeTab = [[EventTabs alloc] init];
        
        currentPracticeTab.fromHome = true;
        
        NSString *tmpUserRole = self.participantRole;
        NSString *tmpTeamId = self.teamId;
        
        
        
        NSArray *tmpViews = currentPracticeTab.viewControllers;
        currentPracticeTab.teamId = tmpTeamId;
        currentPracticeTab.eventId = self.eventId;
        currentPracticeTab.userRole = tmpUserRole;
        
        EventNotes *currentNotes = tmpViews[0];
        currentNotes.eventId = self.eventId;
        currentNotes.teamId = tmpTeamId;
        currentNotes.userRole = tmpUserRole;
        currentNotes.descriptionString = self.eventDescription;

        
        EventAttendance *currentAttendance = tmpViews[1];
        currentAttendance.eventId = self.eventId;
        currentAttendance.teamId = tmpTeamId;
        currentAttendance.userRole = self.participantRole;
        
        currentAttendance.startDate = self.eventStringDate;
		
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        
        [navController pushViewController:currentPracticeTab animated:YES];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentModalViewController:navController animated:YES];

        
        
    }
}

-(void)resenedPoll{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Who's Coming Poll Resent - Happening Now"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

        
        
        NSDictionary *response = [ServerAPI updateMessageThread:mainDelegate.token :self.teamId :self.messageThreadId :@"" :@"" :@"" :@"" :@"true"];
        
        NSString *status = [response valueForKey:@"status"];
        
        NSString *didSucceed;
        if ([status isEqualToString:@"100"]) {
            //success
            didSucceed = @"yes";
            self.messageThreadId = [response valueForKey:@"messageThreadId"];
        }else{
            didSucceed = @"no";
            self.messageThreadId = @"";
        }
        
        
        [self performSelectorOnMainThread:@selector(donePollRe:) withObject:didSucceed waitUntilDone:NO];
    }
         
}

-(void)donePollRe:(NSString *)didSucceed{
    
    [self.pollActivity stopAnimating];
    
    if ([didSucceed isEqualToString:@"yes"]) {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Who's Coming Poll Sent - Happening Now"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        self.pollLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        self.pollLabel.text = @"Poll Sent!";
    }else{
        self.pollLabel.textColor = [UIColor redColor];
        self.pollLabel.text = @"*Poll Failed to Send*";
    }
    
    [self performSelector:@selector(resetUiResend) withObject:nil afterDelay:1.0];

}

-(void)resetUiResend{
    
    [self.pollButton setTitle:@"Re-Send Attendance Poll" forState:UIControlStateNormal];
    
    self.pollButton.hidden = NO;
    self.pollLabel.hidden = YES;

    
}
-(void)setStatus{
    
    UIActionSheet *tmpAction = [[UIActionSheet alloc] initWithTitle:@"Will you be at this event?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No", @"Maybe", nil];
    
    [tmpAction showInView:self.view.superview];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //Yes
        [self performSelectorInBackground:@selector(updateAttendance:) withObject:@"yes"];
    }else if (buttonIndex == 1){
       //No
        [self performSelectorInBackground:@selector(updateAttendance:) withObject:@"no"];

    }else if (buttonIndex == 2){
       //Maybe
        [self performSelectorInBackground:@selector(updateAttendance:) withObject:@"maybe"];

    }else{
        //Cancel
    }
}

-(void)updateAttendance:(NSString *)replyResponse{
    @autoreleasepool {
        //self.players is the array of Player objects
        //self.attMarker is the corresponding array of whether they were present or absent
        NSMutableArray *attendance = [NSMutableArray array];
        NSArray *finalAttendance = @[];
        NSMutableDictionary *attList = [NSMutableDictionary dictionary];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

        if (self.currentMemberId == nil) {
            self.currentMemberId = @"";
            
            NSException *exception = [NSException exceptionWithName:@"Nil Argument" reason:@"nullPointer" userInfo:nil];
            
            [GoogleAppEngine sendClientLog:@"HomeAttendanceView.m - currentMemberId = nil" logMessage:[exception reason] logLevel:@"exception" exception:exception];


        }
    
        attList[@"memberId"] = self.currentMemberId;
        attList[@"preGameStatus"] = replyResponse;
        
        [attendance addObject:attList];
        
        finalAttendance = [NSArray arrayWithArray:attendance];
        
            
            NSString *token = @"";
            
            
            
            if (mainDelegate.token != nil){
                token = mainDelegate.token;
            }
            
            NSDictionary *response = @{};
            if (![token isEqualToString:@""]){
                
                response = [ServerAPI updateAttendees:token :self.teamId :self.eventId :self.eventType :finalAttendance :@""];
                
                NSString *status = [response valueForKey:@"status"];
                                
                if ([status isEqualToString:@"100"]){
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                        default:
                            //should never get here
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                    }
                }
                
            }

        [self performSelectorOnMainThread:
         @selector(didFinishAtt:)
                               withObject:replyResponse
                            waitUntilDone:NO
         ];
        
    }

}
    
-(void)didFinishAtt:(NSString *)response{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Update Own Attendance Status - Happening Now"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    
    if ([self.currentMemberResponse isEqualToString:@"yes"]) {
        int count = [self.yesCount intValue];
        count--;
        self.yesCount = [NSString stringWithFormat:@"%d", count];
        
    }else if ([self.currentMemberResponse isEqualToString:@"no"]){
        int count = [self.noCount intValue];
        count--;
        self.noCount = [NSString stringWithFormat:@"%d", count];
    }else if ([self.currentMemberResponse isEqualToString:@"maybe"]){
        int count = [self.maybeCount intValue];
        count--;
        self.maybeCount = [NSString stringWithFormat:@"%d", count];
    }else{
        int count = [self.noReplyCount intValue];
        count--;
        self.noReplyCount = [NSString stringWithFormat:@"%d", count];
    }
    
    self.currentMemberResponse = [NSString stringWithString:response];
    
    
    if ([self.currentMemberResponse isEqualToString:@"yes"]) {
        int count = [self.yesCount intValue];
        count++;
        self.yesCount = [NSString stringWithFormat:@"%d", count];
        
    }else if ([self.currentMemberResponse isEqualToString:@"no"]){
        int count = [self.noCount intValue];
        count++;
        self.noCount = [NSString stringWithFormat:@"%d", count];
    }else if ([self.currentMemberResponse isEqualToString:@"maybe"]){
        int count = [self.maybeCount intValue];
        count++;
        self.maybeCount = [NSString stringWithFormat:@"%d", count];
    }else{
        int count = [self.noReplyCount intValue];
        count++;
        self.noReplyCount = [NSString stringWithFormat:@"%d", count];
    }
    
    [self setLabels];
        
}


-(void)fullScreen{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)mapAction{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    MapLocation *next = [[MapLocation alloc] init];
    next.eventLatCoord = [self.latitude doubleValue];
    next.eventLongCoord = [self.longitude doubleValue];
    next.cancelButton = true;
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    
    [navController pushViewController:next animated:YES];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:navController animated:YES];
    
    
    
}

-(void)startScore{
    
    [self performSelectorInBackground:@selector(startGame) withObject:nil];
    
  
    self.startedScoring = true;
    
    HomeScoreView *homeScoreView = [[HomeScoreView alloc] init];
    
    homeScoreView.home = true;
    
    homeScoreView.teamName = self.teamName;
    homeScoreView.scoreUs = @"0";
    homeScoreView.scoreThem = @"0";
    homeScoreView.interval = @"1";
    homeScoreView.isSwitch = true;
    
    homeScoreView.eventDate = self.eventDate;
    
    homeScoreView.teamId = self.teamId;
    homeScoreView.eventDescription = self.eventDescription;
    
    homeScoreView.participantRole = self.participantRole;
    homeScoreView.eventId = self.eventId;
    homeScoreView.sport = self.sport;
    
    homeScoreView.eventStringDate = self.eventStringDate;
    
    homeScoreView.latitude = self.latitude;
    homeScoreView.longitude = self.longitude;
    homeScoreView.opponent = self.opponent;
    
    [homeScoreView setLabels];
    
    
    [homeScoreView startTimer];
    
    [self presentModalViewController:homeScoreView animated:NO];

    
}


- (void)startGame {
    
	
	@autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        token = mainDelegate.token;
   
        
        NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"0" :@"1" :@"" :@"" :@""];
        
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
                    //should never get here
                    //self.error.text = @"*Error connecting to server";
                    break;
            }
        }
        
    }	
	
	
}

//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    if (!self.bannerIsVisible) {
        
        self.bannerIsVisible = YES;
        myAd.hidden = NO;
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        myAd.frame = CGRectMake(0, 430, 320, 50);
        self.frontView.frame = CGRectMake(0, 0, 320, 430);
        
        
        
        [UIView commitAnimations];
        
        [self.view bringSubviewToFront:myAd]; 
    }
    
    
    
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    
    self.myAd.hidden = YES;
	if (self.bannerIsVisible) {
        
		self.bannerIsVisible = NO;
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        self.frontView.frame = CGRectMake(0, 0, 320, 480);
        
        
        
        [UIView commitAnimations];
        
        
	}
	
	
}


- (void)viewDidUnload
{
    teamLabel = nil;
    dateLabel = nil;
    yesLabel = nil;
    noLabel = nil;
    noReplyLabel = nil;
    pollButton = nil;
    goToButton = nil;
    pollActivity = nil;
    pollLabel = nil;
    maybeLabel = nil;
    pollDescription = nil;
    statusReply = nil;
    statusButton = nil;
    eventLinkLabel = nil;
    lineView = nil;
    startScoreButton = nil;
    mapButton = nil;
    [super viewDidUnload];
    
}


@end
