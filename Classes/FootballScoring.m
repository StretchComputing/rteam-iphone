//
//  FootballScoring.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FootballScoring.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"

@implementation FootballScoring
@synthesize topOrBottom, subUs, subThem, addQuart, subQuart, scoreUs, scoreThem, quarter, isGameOver, gameOverLabel, finalScore, 
labelUs, labelThem, labelQuart, gameOverButton, editFinalButton, gameId, teamId, createSuccess, error, initScoreUs, initScoreThem, interval,
isCoord, refreshButton, refreshActivity, addThem1, addThem2, addThem3, addUs1, addUs2, addUs3, addThem1Label, addThem2Label, addThem3Label, 
addUs1Label, addUs2Label, addUs3Label;

-(void)viewDidLoad{
	
	self.scoreUs.text = self.initScoreUs;
	self.scoreThem.text = self.initScoreThem;
	self.quarter.text = self.interval;
	[self.finalScore setHidden:YES];
	[self.gameOverLabel setHidden:YES];
	[self.editFinalButton setHidden:YES];
	[self.refreshButton setHidden:NO];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.gameOverButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.editFinalButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
	if ([self.interval isEqualToString:@"-1"]) {
		//Game is over
		[self gameOverView];
	}
	
	if (!self.isCoord) {
		[self.subThem setHidden:YES];
		[self.subUs setHidden:YES];
		[self.addQuart setHidden:YES];
		[self.subQuart setHidden:YES];
		[self.gameOverButton setHidden:YES];
		[self.addThem1 setHidden:YES];
		[self.addThem2 setHidden:YES];
		[self.addThem3 setHidden:YES];
		[self.addUs1 setHidden:YES];
		[self.addUs2 setHidden:YES];
		[self.addUs3 setHidden:YES];
		[self.addThem1Label setHidden:YES];
		[self.addThem2Label setHidden:YES];
		[self.addThem3Label setHidden:YES];
		[self.addUs1Label setHidden:YES];
		[self.addUs2Label setHidden:YES];
		[self.addUs3Label setHidden:YES];
	}
	
}

-(void)addU:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	int increase = tmp.tag;
	
	int us = [self.scoreUs.text intValue];
	us = us + increase;
	self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
}

-(void)subU{
	
	int us = [self.scoreUs.text intValue];
	if (us != 0) {
		us--;
		self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}
	
}


-(void)addT:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	int increase = tmp.tag;
	
	int them = [self.scoreThem.text intValue];
	them = them + increase;
	self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
}

-(void)subT{
	
	int them = [self.scoreThem.text intValue];
	if (them != 0) {
		them--;
		self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}
	
	
}

-(void)addQ{
	
	//Quarter.text can be 0,1,2,3,4, or OT
	
	if (![self.quarter.text isEqualToString:@"OT"]) {
		
		if ([self.quarter.text isEqualToString:@"4"]) {
			self.quarter.text = @"OT";
		}else {
			int quart = [self.quarter.text intValue];
			quart++;
			self.quarter.text = [NSString stringWithFormat:@"%d", quart];
		}
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}

-(void)subQ{
	
	if ([self.quarter.text isEqualToString:@"OT"]) {
		self.quarter.text = @"4";
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}else {
		int quart = [self.quarter.text intValue];
		
		if ((quart != 0) && (quart != 1)) {
			quart--;
			self.quarter.text = [NSString stringWithFormat:@"%d", quart];
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		}		
	}
	
	
	
}

-(void)gameOver{
	
	NSString *message = [NSString stringWithFormat:@"Was the final score %d-%d?", [self.scoreUs.text intValue], [self.scoreThem.text intValue]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		self.quarter.text = @"-1";
		//[self.refreshButton setHidden:YES];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		self.isGameOver = true;
		
		[self hideGameScoring];
		[self.gameOverLabel setHidden:NO];
		
		int us = [self.scoreUs.text intValue];
		int them = [self.scoreThem.text intValue];
		
		NSString *res = @"";
		if (us > them) {
			res = @"W";
		}else if (them > us) {
			res = @"L";
		}else {
			res = @"T";
		}
		
		
		NSString *over = [NSString stringWithFormat:@"Final Result: %@ %d-%d", res, us, them];
		self.finalScore.text = over;
		self.finalScore.textAlignment = UITextAlignmentCenter;
		self.finalScore.textColor = [UIColor blackColor];
		[self.finalScore setHidden:NO];
		[self.editFinalButton setHidden:NO];
		
	}
	
}

-(void)gameOverView{
	
	//[self.refreshButton setHidden:YES];
	
	self.isGameOver = true;
	
	[self hideGameScoring];
	[self.gameOverLabel setHidden:NO];
	
	int us = [self.scoreUs.text intValue];
	int them = [self.scoreThem.text intValue];
	
	NSString *res = @"";
	if (us > them) {
		res = @"W";
	}else if (them > us) {
		res = @"L";
	}else {
		res = @"T";
	}
	
	
	NSString *over = [NSString stringWithFormat:@"Final Result: %@ %d-%d", res, us, them];
	self.finalScore.text = over;
	self.finalScore.textAlignment = UITextAlignmentCenter;
	self.finalScore.textColor = [UIColor blackColor];
	[self.finalScore setHidden:NO];
	
	if (self.isCoord) {
		[self.editFinalButton setHidden:NO];
	}else {
		[self.editFinalButton setHidden:YES];
	}
	
	
}

- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
	
	if ([self.quarter.text isEqualToString:@"0"]) {
		self.quarter.text = @"1";
	}
	
	NSString *sendInterval = @"";
	if ([self.quarter.text isEqualToString:@"OT"]) {
		sendInterval = @"-2";
	}else {
		sendInterval = self.quarter.text;
	}
	
	
	NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.scoreUs.text 
												  :self.scoreThem.text :sendInterval :@""];
	
	NSString *status = [response valueForKey:@"status"];
	
	if ([status isEqualToString:@"100"]){
		
		
		self.createSuccess = true;
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		self.createSuccess = false;
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
				//should never get here
				self.error.text = @"*Error connecting to server";
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

- (void)didFinish{
	
	
	
}

-(void)hideGameScoring{
	
	[self.labelUs setHidden:YES];
	[self.scoreUs setHidden:YES];
	[self.subThem setHidden:YES];
	[self.subUs setHidden:YES];
	
	[self.labelThem setHidden:YES];
	[self.scoreThem setHidden:YES];
	[self.addThem1 setHidden:YES];
	[self.addThem2 setHidden:YES];
	[self.addThem3 setHidden:YES];
	[self.addUs1 setHidden:YES];
	[self.addUs2 setHidden:YES];
	[self.addUs3 setHidden:YES];
	[self.addThem1Label setHidden:YES];
	[self.addThem2Label setHidden:YES];
	[self.addThem3Label setHidden:YES];
	[self.addUs1Label setHidden:YES];
	[self.addUs2Label setHidden:YES];
	[self.addUs3Label setHidden:YES];
	
	[self.labelQuart setHidden:YES];
	[self.quarter setHidden:YES];
	[self.addQuart setHidden:YES];
	[self.subQuart setHidden:YES];
	
	[self.topOrBottom setHidden:YES];
	[self.gameOverButton setHidden:YES];
	
}

-(void)showGameScoring{
	
	[self.labelUs setHidden:NO];
	[self.scoreUs setHidden:NO];
	[self.subThem setHidden:NO];
	[self.subUs setHidden:NO];
	
	[self.labelThem setHidden:NO];
	[self.scoreThem setHidden:NO];
	[self.addThem1 setHidden:NO];
	[self.addThem2 setHidden:NO];
	[self.addThem3 setHidden:NO];
	[self.addUs1 setHidden:NO];
	[self.addUs2 setHidden:NO];
	[self.addUs3 setHidden:NO];
	[self.addThem1Label setHidden:NO];
	[self.addThem2Label setHidden:NO];
	[self.addThem3Label setHidden:NO];
	[self.addUs1Label setHidden:NO];
	[self.addUs2Label setHidden:NO];
	[self.addUs3Label setHidden:NO];
	
	[self.labelQuart setHidden:NO];
	[self.quarter setHidden:NO];
	[self.addQuart setHidden:NO];
	[self.subQuart setHidden:NO];
	
	[self.topOrBottom setHidden:NO];
	[self.gameOverButton setHidden:NO];
	
}



-(void)refresh{
	
	[refreshActivity startAnimating];
	[self performSelectorInBackground:@selector(refreshRequest) withObject:nil];
	
}

- (void)refreshRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
    NSDictionary *response;
	NSDictionary *gameInfo;
	//If there is a token, do a DB lookup to find the game info 
	if (![token isEqualToString:@""]){
		
		response = [ServerAPI getGameInfo:self.gameId :self.teamId :token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			gameInfo = [response valueForKey:@"gameInfo"];
			
			
			if ([gameInfo valueForKey:@"interval"] != nil) {
				
				self.scoreUs.text = [[gameInfo valueForKey:@"scoreUs"] stringValue];
				self.scoreThem.text = [[gameInfo valueForKey:@"scoreThem"] stringValue];
				
				if ([self.quarter.text isEqualToString:@"-1"]) {
					[self gameOverView];
				}else if ([self.quarter.text isEqualToString:@"-2"]) {
					self.quarter.text = @"OT";
				}else {
					self.quarter.text = [[gameInfo valueForKey:@"interval"] stringValue];
				}
				
				
			}
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//	self.error.text = @"*Error connecting to server";
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
	
	[self performSelectorOnMainThread:
	 @selector(refreshFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)refreshFinish{
	
	[refreshActivity stopAnimating];
	
}

-(void)editFinal{
	
	self.quarter.text = @"1";
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	[self.refreshButton setHidden:NO];
	
	self.isGameOver = false;
	
	[self showGameScoring];
	
	[self.gameOverLabel setHidden:YES];
	
	[self.finalScore setHidden:YES];
	
	[self.gameOverButton setHidden:NO];
	[self.editFinalButton setHidden:YES];
	
	
}

- (void)dealloc {
	[subThem release];
	[subUs release];
	[addThem1 release];
	[addThem2 release];
	[addThem3 release];
	[addUs1 release];
	[addUs2 release];
	[addUs3 release];
	[addThem1Label release];
	[addThem2Label release];
	[addThem3Label release];
	[addUs1Label release];
	[addUs2Label release];
	[addUs3Label release];
	
	[addQuart release];
	[subQuart release];
	[scoreUs release];
	[scoreThem release];
	[quarter release];
	[topOrBottom release];
	[gameOverLabel release];
	[finalScore release];
	[labelUs release];
	[labelThem release];
	[labelQuart release];
	[editFinalButton release];
	[gameOverButton release];
	[gameId release];
	[teamId release];
	[error release];
	[initScoreUs release];
	[initScoreThem release];
	[interval release];
	[refreshButton release];
	[refreshActivity release];
    [super dealloc];
}


@end
