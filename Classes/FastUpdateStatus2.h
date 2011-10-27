//
//  FastUpdateStatus2.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentEvent.h"

@interface FastUpdateStatus2 : UIViewController {
    
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
    
	NSString *todayTomorrowString;
	NSString *eventTypeString;
	NSString *timeString;
	
}
@property (nonatomic, strong) NSString *todayTomorrowString;
@property (nonatomic, strong) NSString *eventTypeString;
@property (nonatomic, strong) NSString *timeString;

@property (nonatomic, strong) NSString *messageIntro;
@property bool sendSuccess;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *errorMessage;
@property int currentRecipIndex;
@property (nonatomic, strong) NSArray *recipArray;
@property (nonatomic, strong) CurrentEvent *selectedEvent;
@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *messageString;

@property (nonatomic, strong) UILabel *toLabel;

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;

-(IBAction)send;
-(IBAction)cancel;
-(IBAction)rightRecip;
-(IBAction)leftRecip;
@end
