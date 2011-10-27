//
//  EventNowButton.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventNowButton.h"


@implementation EventNowButton
@synthesize event, eventLabel, teamLabel, canceledLabel, scoreLabel, scoreUs, scoreThem, interval, teamName, eventType, eventDate;

+ (id)buttonWithFrame:(CGRect)frame {
	return [[self alloc] initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		
		//Dynamic label
		self.eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(-54, 52, 158, 12 )];
		self.eventLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
		self.eventLabel.backgroundColor = [UIColor clearColor];
		self.eventLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
		self.eventLabel.textAlignment = UITextAlignmentCenter;
		
		[self addSubview:self.eventLabel];
		[self bringSubviewToFront:self.eventLabel];
		
		self.teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, 65, 110, 9 )];
		self.teamLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
		self.teamLabel.backgroundColor = [UIColor clearColor];
		self.teamLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
		self.teamLabel.textAlignment = UITextAlignmentCenter;
		self.teamLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        
		
		[self addSubview:self.teamLabel];
		[self bringSubviewToFront:self.teamLabel];
		
		
		self.canceledLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, 20, 110, 20 )];
		self.canceledLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
		self.canceledLabel.backgroundColor = [UIColor clearColor];
		self.canceledLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18];
		self.canceledLabel.textAlignment = UITextAlignmentCenter;
		self.canceledLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
		
		
		[self addSubview:self.canceledLabel];
		[self bringSubviewToFront:self.canceledLabel];
        
        
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-54, -12, 158, 12 )];
		self.scoreLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
		self.scoreLabel.backgroundColor = [UIColor clearColor];
		self.scoreLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
		self.scoreLabel.textAlignment = UITextAlignmentCenter;
		//self.scoreLabel.text = @"W 45 - 24";
		[self addSubview:self.scoreLabel];
		[self bringSubviewToFront:self.scoreLabel];
		
		
        
	}
	
	
	return self;
}



@end

