//
//  EventNotes.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface EventNotes : UIViewController <CLLocationManagerDelegate> {
	
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UILabel *opponent;
	IBOutlet UILabel *day;
	IBOutlet UILabel *time;
	IBOutlet UITextView *description;
	
	IBOutlet UIButton *updateLocationButton;	
	IBOutlet UIButton *viewMapButton;
	
	NSString *teamId;
	NSString *eventId;
	NSString *latitude;
	NSString *longitude;
	
	CLLocationManager *locationManager;
	
	bool updateSuccess;
	bool fromNextUpdate;
	
	IBOutlet UILabel *eventNameLabel;
	
	NSString *userRole;
	
	
	UIBarButtonItem *editDone;
	NSString *opponentString;
	NSString *descriptionString;
	NSString *startDateString;
	

	IBOutlet UIActivityIndicatorView *loading;
	NSString *errorString;
	NSString *dayString;
	NSString *timeString;
	NSString *eventNameString;
	
}
@property (nonatomic, retain) NSString *eventNameString;
@property (nonatomic, retain) NSString *dayString;
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIActivityIndicatorView *loading;


@property (nonatomic, retain) NSString *startDateString;
@property (nonatomic, retain) NSString *opponentString;
@property (nonatomic, retain) NSString *descriptionString;
@property (nonatomic, retain) UIBarButtonItem *editDone;


@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) UILabel *eventNameLabel;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UILabel *opponent;
@property (nonatomic, retain) UILabel *day;
@property (nonatomic, retain) UILabel *time;
@property (nonatomic, retain) UITextView *description;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, retain) UIButton *updateLocationButton;
@property (nonatomic, retain) UIButton *viewMapButton;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property bool updateSuccess;

@property bool fromNextUpdate;

-(IBAction)updateLocationAction;
-(IBAction)viewMapAction;
-(void)getPracticeInfo;
@end
