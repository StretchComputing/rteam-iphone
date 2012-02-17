//
//  ScoreNowScoring.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreNowScoring.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "Gameday.h"
#import "ScoreNowScorePage.h"

@implementation ScoreNowScoring
@synthesize topOrBottom, subUs, subThem, addQuart, subQuart, scoreUs, scoreThem, quarter, isGameOver,
labelUs, labelThem, labelQuart, gameOverButton, createSuccess, initScoreUs, initScoreThem, interval,
isCoord, addThem1, addThem2, addThem3, addUs1, addUs2, addUs3, theScoreUs, theScoreThem, myParent;

-(void)viewDidLoad{
	
    self.view.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];

	
	self.scoreUs.text = self.initScoreUs;
	self.scoreThem.text = self.initScoreThem;
	self.quarter.text = self.interval;
    
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.gameOverButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addUs1 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addUs2 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addUs3 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.subUs setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.addThem1 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addThem2 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.addThem3 setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.subThem setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	[self.addQuart setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.subQuart setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	
	
	if ([self.interval isEqualToString:@"-1"]) {
		//Game is over
		//[self gameOverView];
	}

	
}

-(void)addU:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	int increase = tmp.tag;
	
	int us = [self.scoreUs.text intValue];
	us = us + increase;
	self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
    self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
    self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
	
}

-(void)subU{
	
	int us = [self.scoreUs.text intValue];
	if (us != 0) {
		us--;
		self.scoreUs.text = [NSString stringWithFormat:@"%d", us];
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
	}
	
}


-(void)addT:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	int increase = tmp.tag;
	
	int them = [self.scoreThem.text intValue];
	them = them + increase;
	self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
    self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
    self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
}

-(void)subT{
	
	int them = [self.scoreThem.text intValue];
	if (them != 0) {
		them--;
		self.scoreThem.text = [NSString stringWithFormat:@"%d", them];
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
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
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
		
		
	}
}

-(void)subQ{
	
	if ([self.quarter.text isEqualToString:@"OT"]) {
		self.quarter.text = @"4";
        self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
        self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
	}else {
		int quart = [self.quarter.text intValue];
		
		if ((quart != 0) && (quart != 1)) {
			quart--;
			self.quarter.text = [NSString stringWithFormat:@"%d", quart];
            self.theScoreUs = [NSString stringWithString:self.scoreUs.text];
            self.theScoreThem = [NSString stringWithString:self.scoreThem.text];
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
		
       
        [self.myParent performSelector:@selector(gameOver)];
		
     
	}
	
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
	
	
	[self.labelQuart setHidden:NO];
	[self.quarter setHidden:NO];
	[self.addQuart setHidden:NO];
	[self.subQuart setHidden:NO];
	
	[self.topOrBottom setHidden:NO];
	[self.gameOverButton setHidden:NO];
	
}





-(void)viewDidUnload{
	
	topOrBottom = nil;
	subUs = nil;
	subThem = nil;
	addThem1 = nil;
	addThem2 = nil;
	addThem3 = nil;
	addUs1 = nil;
	addUs2 = nil;
	addUs3 = nil;
	addQuart = nil;
	subQuart = nil;
	
	scoreUs = nil;
	labelUs = nil;
	scoreThem = nil;
	labelThem = nil;
	quarter = nil;
	labelQuart = nil;
	gameOverButton = nil;

	[super viewDidUnload];
	
}



@end
