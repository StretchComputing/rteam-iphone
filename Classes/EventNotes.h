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

	
}
@property (nonatomic, strong) NSString *eventNameString;
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loading;


@property (nonatomic, strong) NSString *startDateString;
@property (nonatomic, strong) NSString *opponentString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) UIBarButtonItem *editDone;


@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UILabel *opponent;
@property (nonatomic, strong) IBOutlet UILabel *day;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UITextView *description;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) IBOutlet UIButton *updateLocationButton;
@property (nonatomic, strong) IBOutlet UIButton *viewMapButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property bool updateSuccess;

@property bool fromNextUpdate;

-(IBAction)updateLocationAction;
-(IBAction)viewMapAction;
-(void)getPracticeInfo;
@end
