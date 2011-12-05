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



@implementation HomeAttendanceView
@synthesize initY, teamName, teamLabel, yesCount, yesLabel, noCount, noLabel, noReplyCount, noReplyLabel, dateLabel, eventDate, eventType, pollButton, goToButton, participantRole, teamId, eventId, sport;

- (void)viewDidLoad
{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.pollButton setBackgroundImage:stretch forState:UIControlStateNormal];


    [super viewDidLoad];
}

-(void)setLabels{
    
    self.teamLabel.text = [NSString stringWithFormat:@"%@ Attendance", self.teamName];
    self.dateLabel.text = [NSString stringWithFormat:@"(for %@ on %@)", self.eventType, self.eventDate];
    
    [self.goToButton setTitle:[NSString stringWithFormat:@"Go To %@ Page"] forState:UIControlStateNormal];
    self.yesLabel.text = self.yesCount;
    self.noLabel.text = self.noCount;
    self.noReplyLabel.text = noReplyCount;
    
}



-(void)sendPoll{
    
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

- (void)viewDidUnload
{
    teamLabel = nil;
    dateLabel = nil;
    yesLabel = nil;
    noLabel = nil;
    noReplyLabel = nil;
    pollButton = nil;
    goToButton = nil;
    [super viewDidUnload];
    
}


@end
