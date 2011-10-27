//
//  PracticeNotes.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PracticeNotes : UIViewController <CLLocationManagerDelegate> {
    
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UILabel *opponent;
	IBOutlet UILabel *day;
	IBOutlet UILabel *time;
	IBOutlet UITextView *description;
	
	IBOutlet UIButton *updateLocationButton;	
	IBOutlet UIButton *viewMapButton;
	
	NSString *teamId;
	NSString *practiceId;
	NSString *latitude;
	NSString *longitude;
	
	CLLocationManager *locationManager;
	
	bool updateSuccess;
	bool fromNextUpdate;
	
	NSString *userRole;
	
	UIBarButtonItem *editDone;
	NSString *opponentString;
	NSString *descriptionString;
	NSString *startDateString;
	
	IBOutlet UIActivityIndicatorView *loading;
	NSString *errorString;
	NSString *dayString;
	NSString *timeString;
	
}
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@property (nonatomic, strong) NSString *startDateString;
@property (nonatomic, strong) NSString *opponentString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) UIBarButtonItem *editDone;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *opponent;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UITextView *description;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *practiceId;
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
