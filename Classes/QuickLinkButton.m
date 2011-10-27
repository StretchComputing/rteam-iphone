//
//  QuickLinkButton.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickLinkButton.h"


@implementation QuickLinkButton
@synthesize teamId, teamName;

+ (id)buttonWithFrame:(CGRect)frame {
	return [[self alloc] initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		// do my additional initialization here
		//Wont be needed once we have the real image (real image must have a space on the bottom for the dynamic label)
		//UIImage *image = [UIImage imageNamed:@"teamLinkTest.png"];
		//UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 64)];
		//tmp.image = image;
		//[self addSubview:tmp];
		
		
	}
	
	
	return self;
}

-(void)addLabel{
    //Dynamic label
    [self.teamName removeFromSuperview];
    self.teamName = [[UILabel alloc] initWithFrame:CGRectMake(-10, 48, 100, 20)];
    self.teamName.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
    self.teamName.backgroundColor = [UIColor clearColor];
    self.teamName.font = [UIFont fontWithName:@"Verdana-Bold" size:13];
    self.teamName.textAlignment = UITextAlignmentCenter;
    self.teamName.lineBreakMode = UILineBreakModeMiddleTruncation;
    
    [self addSubview:self.teamName];
    [self bringSubviewToFront:self.teamName];
    
}


@end
