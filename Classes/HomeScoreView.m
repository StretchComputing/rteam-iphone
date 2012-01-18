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
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"

@implementation HomeScoreView
@synthesize fullScreenButton, isFullScreen, initY, teamName, scoreUs, scoreThem, interval, scoreUsLabel, scoreThemLabel, topLabel, usLabel, themLabel, intervalLabel, teamId, eventId, sport, participantRole, goToButton, scoreButton, eventDate, addUsButton, addThemButton, subUsButton, subThemButton, addIntervalButton, subIntervalButton, isKeepingScore, eventDescription, eventStringDate;

- (void)viewDidLoad
{
    self.addUsButton.hidden = YES;
    self.subUsButton.hidden = YES;
    self.addThemButton.hidden = YES;
    self.subThemButton.hidden = YES;
    self.addIntervalButton.hidden = YES;
    self.subIntervalButton.hidden = YES;

    //To make this view go full screen:         
    self.isFullScreen = false;
    self.view.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
    [super viewDidLoad];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.scoreButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addUsButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addThemButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subUsButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subThemButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addIntervalButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subIntervalButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    
   


    
}

-(void)setLabels{
    
    if ([self.participantRole isEqualToString:@"creator"] || [self.participantRole isEqualToString:@"coordinator"]) {
        self.scoreButton.hidden = NO;
        CGRect frame = self.goToButton.frame;
        frame.origin.x = 146;
        self.goToButton.frame = frame;
    }else{
        self.scoreButton.hidden = YES;
        CGRect frame = self.goToButton.frame;
        frame.origin.x = 83;
        self.goToButton.frame = frame;
    }
    
    self.topLabel.text = [NSString stringWithFormat:@"%@ Game", self.teamName];
    self.scoreUsLabel.text = self.scoreUs;
    self.scoreThemLabel.text = self.scoreThem;
    
    [self setNewInterval];
    
}
-(void)setNewInterval{
    
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
        
        if (self.isKeepingScore) {
            [self keepScore];
        }


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
    
    if (self.isKeepingScore) {
        
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];

        [self.scoreButton setTitle:@"Keep Score" forState:UIControlStateNormal];
        
        self.isKeepingScore = false;
        
        self.addUsButton.hidden = YES;
        self.subUsButton.hidden = YES;
        self.addThemButton.hidden = YES;
        self.subThemButton.hidden = YES;
        self.addIntervalButton.hidden = YES;
        self.subIntervalButton.hidden = YES;
        
    }else{
        
        [self.scoreButton setTitle:@"Save Score" forState:UIControlStateNormal];

        
        if (!self.isFullScreen) {
            [self fullScreen];
        }
        self.isKeepingScore = true;
        
        self.addUsButton.hidden = NO;
        self.subUsButton.hidden = NO;
        self.addThemButton.hidden = NO;
        self.subThemButton.hidden = NO;
        
        if (![self.interval isEqualToString:@"-3"]){
            self.addIntervalButton.hidden = NO;
            self.subIntervalButton.hidden = NO;
        }
   
    }
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
            currentNotes.description = self.eventDescription;
            currentNotes.startDate = self.eventStringDate;
            currentNotes.opponentString = @"";
            
            GameAttendance *currentAttendance = [tmpViews objectAtIndex:1];
            currentAttendance.gameId = self.eventId;
            currentAttendance.teamId = tmpTeamId;
            currentAttendance.startDate = self.eventStringDate;
            
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
            currentNotes.description = self.eventDescription;
            currentNotes.startDate = self.eventStringDate;
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

-(void)addUs{
    
    int scoreInt = [self.scoreUs intValue];
    scoreInt = scoreInt + 1;
    self.scoreUs = [NSString stringWithFormat:@"%d", scoreInt];
    
    self.scoreUsLabel.text = [NSString stringWithFormat:self.scoreUs];
    [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    
}

-(void)addThem{
    
    int scoreInt = [self.scoreThem intValue];
    scoreInt = scoreInt + 1;
    self.scoreThem = [NSString stringWithFormat:@"%d", scoreInt];
    
    self.scoreThemLabel.text = [NSString stringWithFormat:self.scoreThem];
    [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    
}

-(void)subUs{
    
    int scoreInt = [self.scoreUs intValue];
    
    if (scoreInt > 0) {
        scoreInt = scoreInt - 1;
        self.scoreUs = [NSString stringWithFormat:@"%d", scoreInt];
        
        self.scoreUsLabel.text = [NSString stringWithFormat:self.scoreUs];
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    }

    
}

-(void)subThem{
    
    
    int scoreInt = [self.scoreThem intValue];
    
    if (scoreInt > 0) {
        scoreInt = scoreInt - 1;
        self.scoreThem = [NSString stringWithFormat:@"%d", scoreInt];
        
        self.scoreThemLabel.text = [NSString stringWithFormat:self.scoreThem];
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    }
}

-(void)addInterval{
    
    int theInterval = [self.interval intValue];
    
    if (theInterval == -1) {
        
    }else if (theInterval == -2){
        theInterval = -1;
    }else if (theInterval == 9){
        theInterval = -2;
    }else{
        //1-8
        theInterval = theInterval + 1;
    }
    
    self.interval = [NSString stringWithFormat:@"%d", theInterval];
    [self setNewInterval];

}


-(void)subInterval{
    
    int theInterval = [self.interval intValue];
    
    if (theInterval == -1) {
        theInterval = -2;
    }else if (theInterval == -2){
        theInterval = 9;
    }else if (theInterval == 1){

    }else{
        //2-9
        theInterval = theInterval - 1;
    }
    
    self.interval = [NSString stringWithFormat:@"%d", theInterval];
    [self setNewInterval];
    
}




- (void)runRequest {
    
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
        
	NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.scoreUs 
												  :self.scoreThem :self.interval :@"" :@"" :@""];
	
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

-(void)doReset{
    
    self.isFullScreen = false;
    self.isKeepingScore = false;
    [self.scoreButton setTitle:@"Keep Score" forState:UIControlStateNormal];
    self.addUsButton.hidden = YES;
    self.subUsButton.hidden = YES;
    self.addThemButton.hidden = YES;
    self.subThemButton.hidden = YES;
    self.addIntervalButton.hidden = YES;
    self.subIntervalButton.hidden = YES;
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
    addThemButton = nil;
    addUsButton = nil;
    subUsButton = nil;
    subThemButton = nil;
    addIntervalButton = nil;
    subIntervalButton = nil;
    [super viewDidUnload];

}


@end
