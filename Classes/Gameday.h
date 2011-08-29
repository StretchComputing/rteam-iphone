//
//  GameNotes.h
//  iCoach
//
//  Created by Nick Wroblewski on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>

@interface Gameday : UIViewController <CLLocationManagerDelegate, ADBannerViewDelegate> {

	IBOutlet UILabel *opponent;
	IBOutlet UILabel *day;
	IBOutlet UILabel *time;
	IBOutlet UILabel *error;

	IBOutlet UIActivityIndicatorView *refreshActivity;
	
	NSString *teamId;
	NSString *errorString;
	NSString *gameId;
	NSString *latitude;
	NSString *longitude;
	
	UIAlertView *nameGameLocation;
	NSString *locationName;
	
	CLLocationManager *locationManager;
	
	bool updateSuccess;
	bool fromNextUpdate;
	bool getInfo;
	
	IBOutlet UILabel *successMessage;
	
	IBOutlet UIButton *moreDetail;
	IBOutlet UITextView *scoringNotEnabled;
	IBOutlet UIButton *enableScoring;
	IBOutlet UIButton *updateLocationButton;
	
	bool isScoringEnabled;
	
	IBOutlet UILabel *locationLabel;
	IBOutlet UIButton *mapButton;
	
	NSString *scoreUs;
	NSString *scoreThem;
	NSString *interval;
	NSString *userRole;
	
	NSString *sport;
	
	IBOutlet UIButton *defaultScoringButton;
	
	ADBannerView *myAd;
	
	BOOL bannerIsVisible;
	
	IBOutlet UILabel *usLabel;
	IBOutlet UILabel *scoreUsLabel;
	IBOutlet UILabel *themLabel;
	IBOutlet UILabel *scoreThemLabel;
	IBOutlet UILabel *scoreDividerLabel;
	IBOutlet UIButton *keepScoreButton;
	IBOutlet UILabel *intervalLabel;
	
	bool setInfoGame;
	bool setInfoScore;
	bool isGameOver;
	IBOutlet UIButton *editFinalButton;
	
	IBOutlet UIActivityIndicatorView *mainActivity;
	
	UIBarButtonItem *editDone;
	NSString *startDate;
	
	NSString *description;
	NSString *opponentString;
	IBOutlet UILabel *orOtherInterval;
	bool scoringAdded;
	
	IBOutlet UIButton *photoButton;
	bool showCamera;
}
@property bool showCamera;
@property (nonatomic, retain) UIButton *photoButton;
@property (nonatomic, retain) NSString *errorString;
@property bool scoringAdded;
@property (nonatomic, retain) UILabel *orOtherInterval;
@property (nonatomic, retain) NSString *opponentString;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) UIActivityIndicatorView *mainActivity;
@property (nonatomic, retain) UIButton *editFinalButton;
@property bool isGameOver;
@property (nonatomic, retain) UIActivityIndicatorView *refreshActivity;
@property bool setInfoGame;
@property bool setInfoScore;
@property (nonatomic, retain) UILabel *intervalLabel;
@property (nonatomic, retain)  UILabel *usLabel;
@property (nonatomic, retain)  UILabel *scoreUsLabel;
@property (nonatomic, retain)  UILabel *themLabel;
@property (nonatomic, retain)  UILabel *scoreThemLabel;
@property (nonatomic, retain)  UILabel *scoreDividerLabel;
@property (nonatomic, retain)  UIButton *keepScoreButton;

@property BOOL bannerIsVisible;
@property bool getInfo;
@property (nonatomic, retain) UIButton *defaultScoringButton;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) UIButton *updateLocationButton;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *scoreUs;
@property (nonatomic, retain) NSString *scoreThem;
@property (nonatomic, retain) NSString *interval;

@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIButton *mapButton;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIButton *moreDetail;
@property (nonatomic, retain) UITextView *scoringNotEnabled;
@property (nonatomic, retain) UIButton *enableScoring;

@property bool isScoringEnabled;

@property (nonatomic, retain) UIAlertView *nameGameLocation;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) UILabel *opponent;
@property (nonatomic, retain) UILabel *day;
@property (nonatomic, retain) UILabel *time;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;


@property (nonatomic, retain) CLLocationManager *locationManager;
@property bool updateSuccess;

@property (nonatomic, retain) UILabel *successMessage;
@property bool fromNextUpdate;

-(NSString *)getIntervalString;

-(IBAction)editFinal;
-(IBAction)refreshScore;
-(void)setInfoGameStarted;
-(void)setInfoScoringStarted;
-(void)getGameInfo;
-(IBAction)updateGpsAction;
-(IBAction)enableScoringAction;
-(IBAction)moreDetailAction;
-(IBAction)map;
-(IBAction)defaultScoring;
-(IBAction)keepScore;
-(IBAction)photo;
@end
