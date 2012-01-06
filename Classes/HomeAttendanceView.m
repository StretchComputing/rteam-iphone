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



@implementation HomeAttendanceView
@synthesize initY, teamName, teamLabel, yesCount, yesLabel, noCount, noLabel, noReplyCount, noReplyLabel, dateLabel, eventDate, eventType, pollButton, goToButton, participantRole, teamId, eventId, sport, pollActivity, pollLabel, maybeCount, maybeLabel, pollDescription, currentMemberId, currentMemberResponse, statusReply, statusButton, messageThreadId;

- (void)viewDidLoad
{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.pollButton setBackgroundImage:stretch forState:UIControlStateNormal];
    

    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.statusButton setBackgroundImage:stretch1 forState:UIControlStateNormal];


    [super viewDidLoad];
}

-(void)setLabels{
    
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
    self.dateLabel.text = [NSString stringWithFormat:@"(expected attendance for %@ on %@)", self.eventType, self.eventDate];
    
    [self.goToButton setTitle:[NSString stringWithFormat:@"Event Page", self.eventType] forState:UIControlStateNormal];
    self.yesLabel.text = self.yesCount;
    self.noLabel.text = self.noCount;
    self.noReplyLabel.text = noReplyCount;
    self.maybeLabel.text = self.maybeCount;
    
    int totalHeight = self.view.frame.size.height;
    
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
        
        self.goToButton.frame = CGRectMake(191, totalHeight - 57, 109, 35);
        self.statusButton.frame = CGRectMake(20, totalHeight - 57, 129, 35);
        self.statusReply.frame = CGRectMake(-6, totalHeight - 27, 180, 21);
       
        [self.goToButton setTitle:[NSString stringWithFormat:@"Event Page", self.eventType] forState:UIControlStateNormal];

        
    }else{
        self.pollButton.hidden = YES;
        self.pollDescription.hidden = YES;
        
        self.goToButton.frame = CGRectMake(80, totalHeight - 45, 160, 35);
        self.statusButton.frame = CGRectMake(95, totalHeight - 109, 130, 35);
        self.statusReply.frame = CGRectMake(0, totalHeight - 79, 320, 21);
        
        [self.goToButton setTitle:[NSString stringWithFormat:@"Go To %@ Page", self.eventType] forState:UIControlStateNormal];


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

        NSDictionary *response = [ServerAPI createMessageThread:mainDelegate.token teamId:self.teamId subject:@"" body:@"" type:@"whoiscoming" eventId:self.eventId eventType:self.eventType isAlert:@"" pollChoices:[NSArray array] recipients:[NSArray array] displayResults:@"" includeFans:@"" coordinatorsOnly:@""];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSString *didSucceed;
        if ([status isEqualToString:@"100"]) {
            //success
            didSucceed = @"yes";
        }else{
            didSucceed = @"no";
        }

        
        [self performSelectorOnMainThread:@selector(donePoll:) withObject:didSucceed waitUntilDone:NO];
        
    }
}

-(void)donePoll:(NSString *)didSucceed{
    
    [self.pollActivity stopAnimating];
    
    if ([didSucceed isEqualToString:@"yes"]) {
        
        self.pollLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        self.pollLabel.text = @"Poll Sent!";
    }else{
        self.pollLabel.textColor = [UIColor redColor];
        self.pollLabel.text = @"*Poll Failed to Send*";
    }
    
}
-(void)goToPage{
        
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
            
            Gameday *currentNotes = [tmpViews objectAtIndex:0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            //*******currentNotes.description = tmpEvent.description;
            currentNotes.startDate = self.eventDate;
            currentNotes.opponentString = @"";
            
            GameAttendance *currentAttendance = [tmpViews objectAtIndex:1];
            currentAttendance.gameId = self.eventId;
            currentAttendance.teamId = tmpTeamId;
            currentAttendance.startDate = self.eventDate;
            
            Vote *fans = [tmpViews objectAtIndex:2];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            id mainViewController = [self.view.superview nextResponder];
            
            if ([mainViewController class] == [Home class]) {
                Home *tmp = (Home *)mainViewController;
                [tmp.navigationController presentModalViewController:navController animated:YES];
                
            }
            
        }else {
            
            GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
            currentGameTab.fromHome = true;
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = self.eventId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = [tmpViews objectAtIndex:0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            currentNotes.description = self.description;
            currentNotes.startDate = self.eventDate;
            currentNotes.opponentString = @"";
            
            Vote *fans = [tmpViews objectAtIndex:1];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            id mainViewController = [self.view.superview nextResponder];
            
            if ([mainViewController class] == [Home class]) {
                Home *tmp = (Home *)mainViewController;
                [tmp.navigationController presentModalViewController:navController animated:YES];
                
            }
            
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
        
        PracticeNotes *currentNotes = [tmpViews objectAtIndex:0];
        currentNotes.practiceId = self.eventId;
        currentNotes.teamId = tmpTeamId;
        currentNotes.userRole = tmpUserRole;
        
        
        PracticeAttendance *currentAttendance = [tmpViews objectAtIndex:1];
        currentAttendance.practiceId = self.eventId;
        currentAttendance.teamId = tmpTeamId;
        currentAttendance.userRole = self.participantRole;
        currentAttendance.startDate = self.eventDate;
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        
        [navController pushViewController:currentPracticeTab animated:YES];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        id mainViewController = [self.view.superview nextResponder];
        
        if ([mainViewController class] == [Home class]) {
            Home *tmp = (Home *)mainViewController;
            [tmp.navigationController presentModalViewController:navController animated:YES];
            
        }
        
        
    }else{
        
        EventTabs *currentPracticeTab = [[EventTabs alloc] init];
        
        currentPracticeTab.fromHome = true;
        
        NSString *tmpUserRole = self.participantRole;
        NSString *tmpTeamId = self.teamId;
        
        
        
        NSArray *tmpViews = currentPracticeTab.viewControllers;
        currentPracticeTab.teamId = tmpTeamId;
        currentPracticeTab.eventId = self.eventId;
        currentPracticeTab.userRole = tmpUserRole;
        
        EventNotes *currentNotes = [tmpViews objectAtIndex:0];
        currentNotes.eventId = self.eventId;
        currentNotes.teamId = tmpTeamId;
        currentNotes.userRole = tmpUserRole;
        
        
        EventAttendance *currentAttendance = [tmpViews objectAtIndex:1];
        currentAttendance.eventId = self.eventId;
        currentAttendance.teamId = tmpTeamId;
        currentAttendance.userRole = self.participantRole;
        
        currentAttendance.startDate = self.eventDate;
		
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        
        [navController pushViewController:currentPracticeTab animated:YES];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        id mainViewController = [self.view.superview nextResponder];
        
        if ([mainViewController class] == [Home class]) {
            Home *tmp = (Home *)mainViewController;
            [tmp.navigationController presentModalViewController:navController animated:YES];
            
        }
        
        
    }
}

-(void)resenedPoll{
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

        [ServerAPI updateMessageThread:mainDelegate.token :self.teamId :self.messageThreadId :@"" :@"" :@"" :@"" :@"true"];
    }
         
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
        NSArray *finalAttendance = [NSArray array];
        NSMutableDictionary *attList = [NSMutableDictionary dictionary];

    
        [attList setObject:self.currentMemberId forKey:@"memberId"];
        [attList setObject:replyResponse forKey:@"preGameStatus"];
        
        [attendance addObject:attList];
        
        finalAttendance = [NSArray arrayWithArray:attendance];
        
            
            NSString *token = @"";
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            if (mainDelegate.token != nil){
                token = mainDelegate.token;
            }
            
            NSDictionary *response = [NSDictionary dictionary];
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
    
    self.currentMemberResponse = [NSString stringWithString:response];
    [self setLabels];
        
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
    [super viewDidUnload];
    
}


@end
