//
//  HomeAttendanceView.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeAttendanceView.h"


@implementation HomeAttendanceView
@synthesize fullScreenButton, isFullScreen, initY, teamName, teamLabel, yesCount, yesLabel, noCount, noLabel, noReplyCount, noReplyLabel, dateLabel, eventDate, eventType;

- (void)viewDidLoad
{

    self.isFullScreen = false;
    [super viewDidLoad];
}

-(void)setLabels{
    
    self.teamLabel.text = [NSString stringWithFormat:@"%@ Attendance", self.teamName];
    self.dateLabel.text = [NSString stringWithFormat:@"(for %@ on %@)", self.eventType, self.eventDate];
    
    self.yesLabel.text = self.yesCount;
    self.noLabel.text = self.noCount;
    self.noReplyLabel.text = noReplyCount;
    
}
-(void)fullScreen{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    
    UIView *tmpView = [self.view superview];
    
    if (self.isFullScreen) {
        self.isFullScreen = false;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"fullScreen.jpeg"] forState:UIControlStateNormal];
        
        tmpView.frame = CGRectMake(0, 115+initY, 320, 301-initY);
        self.view.frame = CGRectMake(0, 0, 320, 301-initY);
        
        
    }else{
        self.isFullScreen = true;
        [self.fullScreenButton setImage:[UIImage imageNamed:@"smallScreen.png"] forState:UIControlStateNormal];
        
        tmpView.frame = CGRectMake(0, initY, 320, 416-initY);
        self.view.frame = CGRectMake(0, 0, 320, 416-initY);
    }
    
    [UIView commitAnimations];
}


- (void)viewDidUnload
{
    teamLabel = nil;
    dateLabel = nil;
    yesLabel = nil;
    noLabel = nil;
    noReplyLabel = nil;
    [super viewDidUnload];
    
}

- (void)dealloc
{
    [teamLabel release];
    [dateLabel release];
    [yesLabel release];
    [noLabel release];
    [noReplyLabel release];
    [teamName release];
    [yesCount release];
    [noCount release];
    [noReplyCount release];
    [eventDate release];
    [eventType release];
    [super dealloc];
}
@end
