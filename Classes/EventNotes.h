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
@property (nonatomic, strong) NSString *eventNameString;
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *loading;


@property (nonatomic, strong) NSString *startDateString;
@property (nonatomic, strong) NSString *opponentString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) UIBarButtonItem *editDone;


@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *opponent;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UITextView *description;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) UIButton *updateLocationButton;
@property (nonatomic, strong) UIButton *viewMapButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property bool updateSuccess;

@property bool fromNextUpdate;

-(IBAction)updateLocationAction;
-(IBAction)viewMapAction;
-(void)getPracticeInfo;
@end
