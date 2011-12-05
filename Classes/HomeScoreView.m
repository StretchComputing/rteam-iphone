//
//  HomeScoreView.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeScoreView.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "Gameday.h"
#import "GameAttendance.h"
#import "Vote.h"
#import "Home.h"

@implementation HomeScoreView
@synthesize fullScreenButton, isFullScreen, initY, teamName, scoreUs, scoreThem, interval, scoreUsLabel, scoreThemLabel, topLabel, usLabel, themLabel, intervalLabel, teamId, eventId, sport, participantRole, goToButton, scoreButton, eventDate;

- (void)viewDidLoad
{
    //To make this view go full screen:         
    self.isFullScreen = false;
    self.view.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
    [super viewDidLoad];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.scoreButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
}

-(void)setLabels{
    
    self.topLabel.text = [NSString stringWithFormat:@"%@ Game", self.teamName];
    self.scoreUsLabel.text = self.scoreUs;
    self.scoreThemLabel.text = self.scoreThem;
    
    NSString *time = @"";
    int intInterval = [self.interval intValue];
    
    if (intInterval == 1) {
        time = @"1st";
    }
    
    if (intInterval == 2) {
        time = @"2nd";
    }
    
    if (intInterval == 3) {
        time = @"3rd";
    }
    
    if (intInterval >= 4) {
        time = [NSString stringWithFormat:@"%@th", self.interval];
    }
    
    if (intInterval == -1) {
        time = @"F";
    }
    
    if (intInterval == -2) {
        time = @"OT";
    }
    
    
    if (intInterval == -3) {
        time = @"";
    }
    
    self.intervalLabel.text = time;
    
}
-(void)fullScreen{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
        
    if (self.isFullScreen) {
        self.isFullScreen = false;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"fullScreen.jpeg"] forState:UIControlStateNormal];

        CGRect frame = self.view.frame;
        frame.origin.y = 121;
        frame.size.height -= 121;
        self.view.frame = frame;


    }else{
        self.isFullScreen = true;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"smallScreen.png"] forState:UIControlStateNormal];

        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        frame.size.height += 121;
        self.view.frame = frame;
    }
    
    [UIView commitAnimations];
}

-(void)keepScore{
    
}

-(void)goToPage{
        
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
        
        
        
}


- (void)viewDidUnload
{
    fullScreenButton = nil;
    scoreUsLabel = nil;
    scoreThemLabel = nil;
    topLabel = nil;
    usLabel = nil;
    themLabel = nil;
    intervalLabel = nil;
    goToButton = nil;
    scoreButton = nil;
    [super viewDidUnload];

}


@end
