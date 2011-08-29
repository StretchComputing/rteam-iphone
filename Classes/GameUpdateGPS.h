//
//  GameUpdateGPS.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GameUpdateGPS : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate> {

	IBOutlet UITextField *locationName;
	
	NSString *lat;
	NSString *longt;
	NSString *teamId;
	NSString *gameId;
	
	NSMutableArray *allGamesArray;
	
	IBOutlet UIActivityIndicatorView *action;
	CLLocationManager *locationManager;
	NSString *updateLat;
	NSString *updateLong;
	
	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *useCurrentButton;
	bool updateSuccess;
	
	IBOutlet UILabel *errorMessage;
	
	NSString *locationString;
	NSString *errorString;
	
	IBOutlet UISegmentedControl *updateAllGames;
	
	
	
	bool nameOnly;
	bool haveGames;
	bool gameSuccess;
	
	bool updateAllSuccess;
}
@property bool updateAllSuccess;
@property bool haveGames;
@property bool gameSuccess;
@property (nonatomic, retain) NSMutableArray *allGamesArray;
@property bool nameOnly;
@property (nonatomic, retain) NSString *updateLat;
@property ( nonatomic, retain) NSString *updateLong;
@property (nonatomic, retain) UISegmentedControl *updateAllGames;

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *locationString;
@property (nonatomic, retain) UITextField *locationName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) UIActivityIndicatorView *action;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *longt;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *useCurrentButton;
@property bool updateSuccess;

@property (nonatomic, retain) UILabel *errorMessage;

-(IBAction)save;
-(IBAction)useCurrent;
-(IBAction)endText;
@end
