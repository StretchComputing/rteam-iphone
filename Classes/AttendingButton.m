//
//  AttendingButton.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttendingButton.h"


@implementation AttendingButton
@synthesize buttonView, tableDisplayView, pollButton, goToPageButton, attendingLabel, yesCount, yesLabel, noCount, noLabel, qCount, qLabel,
tableLineTop, tableLineLeft, tableLineRight, tableLineBottom, closeButton, isAttendance;

+ (id)buttonWithFrame:(CGRect)frame {
	return [[[self alloc] initWithFrame:frame] autorelease];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
	if (self) {
		
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 55)];
        //self.buttonView.backgroundColor = [UIColor colorWithRed:210/255.0 green:105/255.0 blue:30/255.0 alpha:1.0];
        UIImageView *tmpImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 55)];
        tmpImage.image = [UIImage imageNamed:@"attBack.png"];
        [self.buttonView addSubview:tmpImage];
        self.buttonView.userInteractionEnabled = NO;
        [self addSubview:self.buttonView];
        [self bringSubviewToFront:self.buttonView];
        
        //Lines to surround the button
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 1)];
        line1.backgroundColor = [UIColor blackColor];
        line1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self.buttonView addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 55)];
        line2.backgroundColor = [UIColor blackColor];
        line2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self.buttonView addSubview:line2];
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 1, 55)];
        line3.backgroundColor = [UIColor blackColor];
        line3.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self.buttonView addSubview:line3];
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 92, 1)];
        line4.backgroundColor = [UIColor blackColor];
        line4.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.buttonView addSubview:line4];
        
        
        //Table displaing the yes, no, and ? for Attending:
        
        self.tableDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 70)];
        self.tableDisplayView.backgroundColor = [UIColor clearColor];
        self.tableDisplayView.userInteractionEnabled = NO;
        [self addSubview:self.tableDisplayView];
        
        //Lines in tableView
        self.tableLineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 19, 92, 1)];
        self.tableLineTop.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.tableLineTop];
        self.tableLineLeft = [[UIView alloc] initWithFrame:CGRectMake(31, 19, 1, 37)];
        self.tableLineLeft.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.tableLineLeft];
        self.tableLineRight = [[UIView alloc] initWithFrame:CGRectMake(62, 19, 1, 37)];
        self.tableLineRight.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.tableLineRight];
        self.tableLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 92, 1)];
        self.tableLineBottom.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.tableLineBottom];
        
        //Labels for tableView
        
        self.attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 19)];
        self.attendingLabel.textAlignment = UITextAlignmentCenter;
        self.attendingLabel.text = @"Attending:";
        self.attendingLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.attendingLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.attendingLabel];
        
        self.yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 30, 15)];
        self.yesLabel.textAlignment = UITextAlignmentCenter;
        self.yesLabel.text = @"Yes";
        self.yesLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.yesLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.yesLabel];
        
        
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 22, 30, 15)];
        self.noLabel.textAlignment = UITextAlignmentCenter;
        self.noLabel.text = @"No";
        self.noLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.noLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.noLabel];
        
        
        self.qLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 22, 30, 15)];
        self.qLabel.textAlignment = UITextAlignmentCenter;
        self.qLabel.text = @"?";
        self.qLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.qLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.qLabel];
        
        
        self.yesCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 30, 15)];
        self.yesCount.textAlignment = UITextAlignmentCenter;
        self.yesCount.text = @"66";
        self.yesCount.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.yesCount.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.yesCount];
        
        
        self.noCount = [[UILabel alloc] initWithFrame:CGRectMake(31, 38, 30, 15)];
        self.noCount.textAlignment = UITextAlignmentCenter;
        self.noCount.text = @"55";
        self.noCount.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.noCount.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.noCount];
        
        
        self.qCount = [[UILabel alloc] initWithFrame:CGRectMake(62, 38, 30, 15)];
        self.qCount.textAlignment = UITextAlignmentCenter;
        self.qCount.text = @"22";
        self.qCount.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.qCount.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.qCount];
        

        
		//Stuff From EventNowButton
        //Dynamic label
		self.eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(-34, 57, 158, 12 )];
		self.eventLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
		self.eventLabel.backgroundColor = [UIColor clearColor];
		self.eventLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
		self.eventLabel.textAlignment = UITextAlignmentCenter;
		
		[self addSubview:self.eventLabel];
		[self bringSubviewToFront:self.eventLabel];
		
		self.teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 70, 110, 9 )];
		self.teamLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.3 alpha:1.0];
		self.teamLabel.backgroundColor = [UIColor clearColor];
		self.teamLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
		self.teamLabel.textAlignment = UITextAlignmentCenter;
		self.teamLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        
		
		[self addSubview:self.teamLabel];
		[self bringSubviewToFront:self.teamLabel];
		
		
		self.canceledLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 25, 110, 20 )];
		self.canceledLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
		self.canceledLabel.backgroundColor = [UIColor clearColor];
		self.canceledLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18];
		self.canceledLabel.textAlignment = UITextAlignmentCenter;
		self.canceledLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
		
		
		[self addSubview:self.canceledLabel];
		[self bringSubviewToFront:self.canceledLabel];
        
        
	}
	
	
	return self;
}



-(void)dealloc{
    
    [buttonView release];
    [tableDisplayView release];
    [pollButton release];
    [goToPageButton release];
    [attendingLabel release];
    [yesCount release];
    [yesLabel release];
    [noCount release];
    [noLabel release];
    [qCount release];
    [qLabel release];
    
    [tableLineLeft release];
    [tableLineRight release];
    [tableLineTop release];
    [tableLineBottom release];
    [closeButton release];
    [super dealloc];
}

@end
