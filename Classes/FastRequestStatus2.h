//
//  FastRequestStatus2.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentEvent.h"

@interface FastRequestStatus2 : UIViewController {
	
	IBOutlet UILabel *eventLabel;
	IBOutlet UILabel *messageLabel;
	NSString *messageString;
	
	IBOutlet UILabel *toLabel;
	
	IBOutlet UIButton *sendButton;
	IBOutlet UIButton *cancelButton;
	
	CurrentEvent *selectedEvent;
	
	NSArray *recipArray;
	int currentRecipIndex;
	
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *errorMessage;
	
	NSString *errorString;
	bool sendSuccess;
	NSString *messageIntro;

	NSString *includeFans;
	bool fansOnly;
	bool toTeam;
	
	IBOutlet UIButton *editRecipButton;
	NSArray *recipients;
	NSString *reminder;
	
	NSString *todayTomorrowString;
	NSString *eventTypeString;
	NSString *timeString;
	
}
@property (nonatomic, retain) NSString *todayTomorrowString;
@property (nonatomic, retain) NSString *eventTypeString;
@property (nonatomic, retain) NSString *timeString;

@property (nonatomic, retain) NSString *reminder;
@property (nonatomic, retain) NSArray *recipients;
@property (nonatomic, retain) UIButton *editRecipButton;
@property (nonatomic, retain) NSString *includeFans;
@property bool fansOnly;
@property bool toTeam;

@property (nonatomic, retain) NSString *messageIntro;
@property bool sendSuccess;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *errorMessage;
@property int currentRecipIndex;
@property (nonatomic, retain) NSArray *recipArray;
@property (nonatomic, retain) CurrentEvent *selectedEvent;
@property (nonatomic, retain) UILabel *eventLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) NSString *messageString;

@property (nonatomic, retain) UILabel *toLabel;

@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;

-(IBAction)send;
-(IBAction)cancel;
-(IBAction)editRecip;
@end

