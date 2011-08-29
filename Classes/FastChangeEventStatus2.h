//
//  FastChangeEventStatus2.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentEvent.h"
#import <CoreLocation/CoreLocation.h>


@interface FastChangeEventStatus2 : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate> {
	
	IBOutlet UILabel *eventLabel;
	IBOutlet UILabel *messageLabel;
	NSString *messageString;
	
	IBOutlet UILabel *toLabel;
	
	IBOutlet UIButton *sendButton;
	IBOutlet UIButton *cancelButton;
	
	CLLocationManager *locationManager;

	CurrentEvent *selectedEvent;
	
	NSArray *recipArray;
	int currentRecipIndex;
	
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *errorMessage;
	
	NSString *errorString;
	bool sendSuccess;
	NSString *messageIntro;
	
	int status;
	
	
	IBOutlet UILabel *finalScoreLabel;
	IBOutlet UITextField *finalUs;
	IBOutlet UITextField *finalThem;
	
	IBOutlet UIDatePicker *newDateTime;
	IBOutlet UILabel *newDateTimeLabel;
	
	IBOutlet UILabel *newLocationLabel;
	IBOutlet UITextField *newLocation;
	IBOutlet UISegmentedControl *setCurrentLocationButton;
	IBOutlet UILabel *newCurrentLocationLabel;
	
	NSString *todayTomorrowString;
	NSString *eventTypeString;
	NSString *timeString;
	
	int delay;
	
	bool doneMessage;
	bool doneSecondary;
	
	NSString *latitude;
	NSString *longitude;
}
@property (nonatomic, retain) 	CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) UILabel *newCurrentLocationLabel;
@property bool doneMessage;
@property bool doneSecondary;
@property int delay;
@property (nonatomic, retain) NSString *todayTomorrowString;
@property (nonatomic, retain) NSString *eventTypeString;
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, retain) UILabel *finalScoreLabel;
@property (nonatomic, retain) UITextField *finalUs;
@property (nonatomic, retain) UITextField *finalThem;

@property (nonatomic, retain) UIDatePicker *newDateTime;
@property (nonatomic, retain) UILabel *newDateTimeLabel;

@property (nonatomic, retain) UILabel *newLocationLabel;
@property (nonatomic, retain) UITextField *newLocation;
@property (nonatomic, retain) UISegmentedControl *setCurrentLocationButton;


@property int status;
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

-(IBAction)endText;
-(IBAction)send;
-(IBAction)cancel;
-(IBAction)rightRecip;
-(IBAction)leftRecip;
@end