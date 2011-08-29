//
//  HomeScoreView.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeScoreView.h"


@implementation HomeScoreView
@synthesize fullScreenButton, isFullScreen, initY, teamName, scoreUs, scoreThem, interval, scoreUsLabel, scoreThemLabel, topLabel, usLabel, themLabel, intervalLabel;

- (void)viewDidLoad
{
    //To make this view go full screen:         homeScoreView.view.frame = CGRectMake(0, -165, 320, 464);
    self.isFullScreen = false;
    self.view.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
    [super viewDidLoad];
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
    
    UIView *tmpView = [self.view superview];
    
    if (self.isFullScreen) {
        self.isFullScreen = false;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"fullScreen.jpeg"] forState:UIControlStateNormal];

        tmpView.frame = CGRectMake(0, 115, 320, 301-initY);
        self.view.frame = CGRectMake(0, 0, 320, 301-initY);


    }else{
        self.isFullScreen = true;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"smallScreen.png"] forState:UIControlStateNormal];

        tmpView.frame = CGRectMake(0, 0, 320, 416-initY);
        self.view.frame = CGRectMake(0, 0, 320, 416-initY);
    }
    
    [UIView commitAnimations];
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
    [super viewDidUnload];

}

- (void)dealloc
{
    [teamName release];
    [scoreUs release];
    [scoreThem release];
    [interval release];
    [fullScreenButton release];
    [scoreUsLabel release];
    [scoreThemLabel release];
    [topLabel release];
    [usLabel release];
    [themLabel release];
    [intervalLabel release];
    [super dealloc];
}

@end
