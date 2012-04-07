//
//  MyClass.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreButton.h"


@implementation ScoreButton
@synthesize buttonView, tableDisplayView, pollButton, goToPageButton, attendingLabel, yesCount, yesLabel, noCount, noLabel, qCount, qLabel,
tableLineTop, tableLineLeft, tableLineRight, tableLineBottom, closeButton, isAttendance, activity;


+ (id)buttonWithFrame:(CGRect)frame {
	return [[self alloc] initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
	if (self) {
		
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 55)];
        
        self.buttonView.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
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
        
        line1.backgroundColor = [UIColor whiteColor];
        line2.backgroundColor = [UIColor whiteColor];
        line3.backgroundColor = [UIColor whiteColor];
        line4.backgroundColor = [UIColor whiteColor];
        
        
        
        //Table displaing the yes, no, and ? for Attending:
        
        self.tableDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 70)];
        self.tableDisplayView.backgroundColor = [UIColor clearColor];
        self.tableDisplayView.userInteractionEnabled = NO;
        [self addSubview:self.tableDisplayView];
        
        //Lines in tableView
        self.tableLineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 19, 92, 1)];
        self.tableLineTop.backgroundColor = [UIColor whiteColor];
        [self.tableDisplayView addSubview:self.tableLineTop];
        
        self.tableLineLeft = [[UIView alloc] initWithFrame:CGRectMake(31, 19, 1, 37)];
        self.tableLineLeft.backgroundColor = [UIColor blackColor];
        //[self.tableDisplayView addSubview:self.tableLineLeft];
        self.tableLineRight = [[UIView alloc] initWithFrame:CGRectMake(62, 19, 1, 37)];
        self.tableLineRight.backgroundColor = [UIColor blackColor];
        //[self.tableDisplayView addSubview:self.tableLineRight];
        
        
        // self.tableLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 55, 92, 1)];
        // self.tableLineBottom.backgroundColor = [UIColor blackColor];
        // [self.tableDisplayView addSubview:self.tableLineBottom];
        
        //Labels for tableView
        
        self.attendingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92, 19)];
        self.attendingLabel.textAlignment = UITextAlignmentCenter;
        self.attendingLabel.text = @"Score:";
        self.attendingLabel.textColor = [UIColor whiteColor];
        self.attendingLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.attendingLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.attendingLabel];
        
        
        self.yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 20, 30, 15)];
        self.yesLabel.textAlignment = UITextAlignmentCenter;
        self.yesLabel.text = @"Us";
        self.yesLabel.textColor = [UIColor whiteColor];
        
        self.yesLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
        self.yesLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.yesLabel];
        
        
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 20, 30, 15)];
        self.noLabel.textAlignment = UITextAlignmentCenter;
        self.noLabel.text = @"Them";
        self.noLabel.textColor = [UIColor whiteColor];
        
        self.noLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
        self.noLabel.backgroundColor = [UIColor clearColor];
        [self.tableDisplayView addSubview:self.noLabel];
        
        
        UIView *backTimeView = [[UIView alloc] initWithFrame:CGRectMake(35, 19, 22, 19)];
        backTimeView.backgroundColor = [UIColor whiteColor];
        [self.tableDisplayView addSubview:backTimeView];
        
        self.qLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 20, 20, 17)];
        self.qLabel.textAlignment = UITextAlignmentCenter;
        self.qLabel.text = @"2nd";
        self.qLabel.textColor = [UIColor yellowColor];
        self.qLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
        self.qLabel.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.qLabel];
        
        
        UIView *backUs = [[UIView alloc] initWithFrame:CGRectMake(2, 33, 30, 21)];
        backUs.backgroundColor = [UIColor whiteColor];
        //[self.tableDisplayView addSubview:backUs];
        
        self.yesCount = [[UILabel alloc] initWithFrame:CGRectMake(3, 34, 28, 19)];
        self.yesCount.textAlignment = UITextAlignmentCenter;
        self.yesCount.text = @"66";
        self.yesCount.textColor = [UIColor redColor];
        self.yesCount.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.yesCount.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.yesCount];
        
        UIView *backThem = [[UIView alloc] initWithFrame:CGRectMake(61, 33, 30, 21)];
        backThem.backgroundColor = [UIColor whiteColor];
        //[self.tableDisplayView addSubview:backThem];
        
        self.noCount = [[UILabel alloc] initWithFrame:CGRectMake(62, 34, 28, 19)];
        self.noCount.textAlignment = UITextAlignmentCenter;
        self.noCount.text = @"55";
        self.noCount.textColor = [UIColor redColor];
        self.noCount.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.noCount.backgroundColor = [UIColor blackColor];
        [self.tableDisplayView addSubview:self.noCount];
        
        UIImageView *tmpCircle = [[UIImageView alloc] initWithFrame:CGRectMake(33, 47, 9, 9)];
        tmpCircle.image = [UIImage imageNamed:@"smallCircle.png"];
        [self.tableDisplayView addSubview:tmpCircle];
        UIImageView *tmpCircle1 = [[UIImageView alloc] initWithFrame:CGRectMake(39, 47, 9, 9)];
        tmpCircle1.image = [UIImage imageNamed:@"smallCircle.png"];
        [self.tableDisplayView addSubview:tmpCircle1];
        UIImageView *tmpCircle2 = [[UIImageView alloc] initWithFrame:CGRectMake(45, 47, 9, 9)];
        tmpCircle2.image = [UIImage imageNamed:@"smallCircle.png"];
        [self.tableDisplayView addSubview:tmpCircle2];
        UIImageView *tmpCircle3 = [[UIImageView alloc] initWithFrame:CGRectMake(51, 47, 9, 9)];
        tmpCircle3.image = [UIImage imageNamed:@"smallCircle.png"];
        [self.tableDisplayView addSubview:tmpCircle3];
        
        
        
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



@end

