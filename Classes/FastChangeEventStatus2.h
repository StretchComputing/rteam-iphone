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
@property (nonatomic, strong) 	CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong, getter = theNewCurrentLocationLabel) UILabel *newCurrentLocationLabel;
@property bool doneMessage;
@property bool doneSecondary;
@property int delay;
@property (nonatomic, strong) NSString *todayTomorrowString;
@property (nonatomic, strong) NSString *eventTypeString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) UILabel *finalScoreLabel;
@property (nonatomic, strong) UITextField *finalUs;
@property (nonatomic, strong) UITextField *finalThem;

@property (nonatomic, strong, getter = theNewDateTime) UIDatePicker *newDateTime;
@property (nonatomic, strong, getter = theNewDateTimeLabel) UILabel *newDateTimeLabel;

@property (nonatomic, strong, getter = theNewLocationLabel) UILabel *newLocationLabel;
@property (nonatomic, strong, getter = theNewLocation) UITextField *newLocation;
@property (nonatomic, strong) UISegmentedControl *setCurrentLocationButton;


@property int status;
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

-(IBAction)endText;
-(IBAction)send;
-(IBAction)cancel;
-(IBAction)rightRecip;
-(IBAction)leftRecip;
@end