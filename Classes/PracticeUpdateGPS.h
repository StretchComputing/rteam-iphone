//
//  PracticeUpdateGPS.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PracticeUpdateGPS : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate> {
	
	IBOutlet UITextField *locationName;
	
	NSString *lat;
	NSString *longt;
	NSString *teamId;
	NSString *practiceId;
	
	IBOutlet UIActivityIndicatorView *action;
	CLLocationManager *locationManager;
	
	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *useCurrentButton;
	bool updateSuccess;
	
	IBOutlet UILabel *errorMessage;
	
	NSString *locationString;
	NSString *errorString;
    
	IBOutlet UISegmentedControl *updateAllGames;
	
	NSMutableArray *allPracticesArray;
	NSString *updateLat;
	NSString *updateLong;
	
	bool nameOnly;
	bool haveGames;
	bool practiceSuccess;
	
	bool updateAllSuccess;
}
@property bool updateAllSuccess;
@property bool haveGames;
@property bool practiceSuccess;
@property (nonatomic, strong) NSMutableArray *allPracticesArray;
@property bool nameOnly;
@property (nonatomic, strong) NSString *updateLat;
@property ( nonatomic, strong) NSString *updateLong;
@property (nonatomic, strong) UISegmentedControl *updateAllGames;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) UITextField *locationName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) UIActivityIndicatorView *action;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *longt;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *useCurrentButton;
@property bool updateSuccess;

@property (nonatomic, strong) UILabel *errorMessage;

-(IBAction)save;
-(IBAction)useCurrent;
-(IBAction)endText;
@end
