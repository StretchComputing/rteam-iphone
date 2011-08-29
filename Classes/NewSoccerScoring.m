//
//  NewSoccerScoring.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewSoccerScoring.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "Gameday.h"

@implementation NewSoccerScoring
@synthesize topOrBottom, subUs, subThem, addQuart, subQuart, scoreUs, scoreThem, quarter, isGameOver, orHalfLabel,
labelUs, labelThem, labelQuart, gameOverButton, gameId, teamId, createSuccess, initScoreUs, initScoreThem, interval,
isCoord, addThem, addUs, cancelScoringButton, activity;

-(void)viewDidLoad{
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.view.bounds;
	UIColor *color1 =  [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1];
	UIColor *color2 = [UIColor colorWithRed:0.69 green:0.769 blue:0.871 alpha:1.0];
	gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor], (id)[color2 CGColor], nil];
	[self.view.layer insertSublayer:gradient atIndex:0];
	
	
	
	
	self.scoreUs.text = self.initScoreUs;
	self.scoreThem.text = self.initScoreThem;
	self.quarter.text = self.interval;
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.gameOverButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addUs setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	[self.subUs setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.addThem setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	[self.subThem setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.addQuart setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.subQuart setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.cancelScoringButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
	
	
	if ([self.interval isEqualToString:@"-1"]) {
		//Game is over
	}
	
	if (!self.isCoord) {
		[self.subThem setHidden:YES];
		[self.subUs setHidden:YES];
		[self.addQuart setHidden:YES];
		[self.subQuart setHidden:YES];
		[self.gameOverButton setHidden:YES];
		[self.addThem setHidden:YES];
	
		[self.addUs setHidden:YES];

	}
	
}

-(void)addU{
	
	
	int us = [self.scoreUs.text intValue];
	us = us++;
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


-(void)addT{
	
	int them = [self.scoreThem.text intValue];
	them = them ++;
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
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		self.quarter.text = @"-1";
        [self.activity startAnimating];
        self.quarter.hidden = YES;
        
        self.addUs.enabled = NO;
        self.subUs.enabled = NO;
        self.addThem.enabled = NO;
        self.subThem.enabled = NO;
        self.gameOverButton.enabled = NO;
        self.cancelScoringButton.enabled = NO;
        
		[self performSelectorInBackground:@selector(runRequestOver) withObject:nil];
		
        /*
		[self.view setHidden:YES];
		
		id mainViewController = [self.view.superview nextResponder];
		
		if ([mainViewController class] == [Gameday class]) {
			Gameday *tmp = (Gameday *)mainViewController;
			[tmp.refreshActivity startAnimating];
			[tmp performSelectorInBackground:@selector(getGameInfo) withObject:nil];
			
		}
         */
		
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
												  :self.scoreThem.text :sendInterval :@"" :@"" :@""];
	
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
				//self.error.text = @"*Error connecting to server";
				break;
			case 1:
				///error connecting to server
				//self.error.text = @"*Error connecting to server";
				break;
				
			default:
				//should never get here
				//self.error.text = @"*Error connecting to server";
				break;
		}
	}
	

    [pool drain];
}

- (void)runRequestOver {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
	
	
	NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.scoreUs.text 
												  :self.scoreThem.text :@"-1" :@"" :@"" :@""];
	
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
				//self.error.text = @"*Error connecting to server";
				break;
			case 1:
				///error connecting to server
				//self.error.text = @"*Error connecting to server";
				break;
				
			default:
				//should never get here
				//self.error.text = @"*Error connecting to server";
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
	
    self.addUs.enabled = YES;
    self.subUs.enabled = YES;
    self.addThem.enabled = YES;
    self.subThem.enabled = YES;
    self.gameOverButton.enabled = YES;
    self.cancelScoringButton.enabled = YES;
    
    [self.activity stopAnimating];
    self.quarter.hidden = NO;
	[self.view setHidden:YES];
    
    id mainViewController = [self.view.superview nextResponder];
    
    if ([mainViewController class] == [Gameday class]) {
        Gameday *tmp = (Gameday *)mainViewController;
        [tmp.refreshActivity startAnimating];
        [tmp performSelectorInBackground:@selector(getGameInfo) withObject:nil];
        
    }
	
}

-(void)hideGameScoring{
	
	[self.labelUs setHidden:YES];
	[self.scoreUs setHidden:YES];
	[self.subThem setHidden:YES];
	[self.subUs setHidden:YES];
	
	[self.labelThem setHidden:YES];
	[self.scoreThem setHidden:YES];
	[self.addThem setHidden:YES];
	[self.addUs setHidden:YES];

	
	
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
	[self.addThem setHidden:NO];
	[self.addUs setHidden:NO];

	
	
	[self.labelQuart setHidden:NO];
	[self.quarter setHidden:NO];
	[self.addQuart setHidden:NO];
	[self.subQuart setHidden:NO];
	
	[self.topOrBottom setHidden:NO];
	[self.gameOverButton setHidden:NO];
	
}





-(void)cancel{
	
	self.view.hidden = YES;
	
	id mainViewController = [self.view.superview nextResponder];
	
	if ([mainViewController class] == [Gameday class]) {
		Gameday *tmp = (Gameday *)mainViewController;
		[tmp.refreshActivity startAnimating];
		[tmp performSelectorInBackground:@selector(getGameInfo) withObject:nil];
		/*
		 tmp.scoreUsLabel.text = self.scoreUs.text;
		 tmp.scoreThemLabel.text = self.scoreThem.text;
		 tmp.intervalLabel.text = [NSString stringWithFormat:@"Quarter: %@", self.quarter.text];
		 tmp.interval = self.quarter.text;
		 tmp.scoreUs = self.scoreUs.text;
		 tmp.scoreThem = self.scoreThem.text;
		 
		 */
	}
	
}


-(void)viewDidUnload{
	
	topOrBottom = nil;
	subUs = nil;
	subThem = nil;
	
	
	addThem = nil;
	
	addUs = nil;
	addQuart = nil;
	subQuart = nil;
	scoreUs = nil;
	labelUs = nil;
	scoreThem = nil;
	labelThem = nil;
	quarter = nil;
	labelQuart = nil;
	gameOverButton = nil;
	cancelScoringButton = nil;
	orHalfLabel = nil;
    activity = nil;
	[super viewDidUnload];
	
}
- (void)dealloc {
	[subThem release];
	[subUs release];
	[addThem release];
	[addUs release];

	
	
	[addQuart release];
	[subQuart release];
	[scoreUs release];
	[scoreThem release];
	[quarter release];
	[topOrBottom release];
	
	[labelUs release];
	[labelThem release];
	[labelQuart release];
	[gameOverButton release];
	[gameId release];
	[teamId release];
	[initScoreUs release];
	[initScoreThem release];
	[interval release];
	[cancelScoringButton release];
	[orHalfLabel release];
    [activity release];
    [super dealloc];
}


@end