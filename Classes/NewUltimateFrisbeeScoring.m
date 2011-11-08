//
//  NewUltimateFrisbeeScoring.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewUltimateFrisbeeScoring.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "Gameday.h"

@implementation NewUltimateFrisbeeScoring
@synthesize topOrBottom, subUs, subThem, scoreUs, scoreThem, isGameOver,
labelUs, labelThem, gameOverButton, gameId, teamId, createSuccess, initScoreUs, initScoreThem, interval,
isCoord, addThem, addUs, cancelScoringButton, activity, theScoreUs, theScoreThem;

-(void)viewDidLoad{
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.view.bounds;
	UIColor *color1 =  [UIColor colorWithRed:109/255.0 green:132/255.0 blue:162/255.0 alpha:1];
	UIColor *color2 = [UIColor colorWithRed:0.69 green:0.769 blue:0.871 alpha:1.0];
	gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor], (id)[color2 CGColor], nil];
	[self.view.layer insertSublayer:gradient atIndex:0];
	
	
	
	
	self.scoreUs.text = self.initScoreUs;
	self.scoreThem.text = self.initScoreThem;
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.gameOverButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addUs setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.subUs setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.addThem setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.subThem setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.cancelScoringButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
	
	if ([self.interval isEqualToString:@"-1"]) {
		//Game is over
	}
	
	if (!self.isCoord) {
		[self.subThem setHidden:YES];
		[self.subUs setHidden:YES];
		[self.gameOverButton setHidden:YES];
		[self.addThem setHidden:YES];
		
		[self.addUs setHidden:YES];
		
	}
	
}

-(void)addU{
	
	
	int us = [self.scoreUs.text intValue];
	us++;
	self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
    self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
    self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
}

-(void)subU{
	
	int us = [self.scoreUs.text intValue];
	if (us != 0) {
		us--;
		self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}
	
}


-(void)addT{
	
	int them = [self.scoreThem.text intValue];
	them++;
	self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
    self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
    self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
}

-(void)subT{
	
	int them = [self.scoreThem.text intValue];
	if (them != 0) {
		them--;
		self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}
	
	
}

-(void)gameOver{
	
	NSString *message = [NSString stringWithFormat:@"Was the final score %d-%d?", [self.scoreUs.text intValue], [self.scoreThem.text intValue]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];
    //[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		self.interval = @"-1";
    
        self.addUs.enabled = NO;
        self.subUs.enabled = NO;
        self.addThem.enabled = NO;
        self.subThem.enabled = NO;
        self.gameOverButton.enabled = NO;
        self.cancelScoringButton.enabled =NO;
        
        [self.activity startAnimating];
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
        
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
	
	//NSAutoreleasePool * pool;
	
    //pool = [[NSAutoreleasePool alloc] init];
    //assert(pool != nil);
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
	
	NSString *sendInterval = @"";
	if ([self.interval isEqualToString:@"0"]) {
		sendInterval = @"-3";
	}else {
		sendInterval = self.interval;
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
	

	
    //[pool drain];
}

- (void)runRequestOver {
	
	//NSAutoreleasePool * pool;
	
   /// pool = [[NSAutoreleasePool alloc] init];
    //assert(pool != nil);
	
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
	
    //[pool drain];
}


- (void)didFinish{
	
    [self.activity stopAnimating];

    self.addUs.enabled = YES;
    self.subUs.enabled = YES;
    self.addThem.enabled = YES;
    self.subThem.enabled = YES;
    self.gameOverButton.enabled = YES;
    self.cancelScoringButton.enabled =YES;
    
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

	scoreUs = nil;
	labelUs = nil;
	scoreThem = nil;
	labelThem = nil;

	gameOverButton = nil;
	cancelScoringButton = nil;
	[super viewDidUnload];
	
}
/*
- (void)dealloc {
	[subThem release];
	[subUs release];
	[addThem release];
	[addUs release];
	
	[scoreUs release];
	[scoreThem release];
	[topOrBottom release];
	
	[labelUs release];
	[labelThem release];
	[gameOverButton release];
	[gameId release];
	[teamId release];
	[initScoreUs release];
	[initScoreThem release];
	[interval release];
	[cancelScoringButton release];
    [super dealloc];
}
*/

@end

