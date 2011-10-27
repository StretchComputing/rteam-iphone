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
@property (nonatomic, strong) NSMutableArray *allGamesArray;
@property bool nameOnly;
@property (nonatomic, strong) NSString *updateLat;
@property ( nonatomic, strong) NSString *updateLong;
@property (nonatomic, strong) UISegmentedControl *updateAllGames;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) UITextField *locationName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *gameId;
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
