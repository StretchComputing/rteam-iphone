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
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) NSString *errorString;
@property bool scoringAdded;
@property (nonatomic, strong) UILabel *orOtherInterval;
@property (nonatomic, strong) NSString *opponentString;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) UIBarButtonItem *editDone;
@property (nonatomic, strong) UIActivityIndicatorView *mainActivity;
@property (nonatomic, strong) UIButton *editFinalButton;
@property bool isGameOver;
@property (nonatomic, strong) UIActivityIndicatorView *refreshActivity;
@property bool setInfoGame;
@property bool setInfoScore;
@property (nonatomic, strong) UILabel *intervalLabel;
@property (nonatomic, strong)  UILabel *usLabel;
@property (nonatomic, strong)  UILabel *scoreUsLabel;
@property (nonatomic, strong)  UILabel *themLabel;
@property (nonatomic, strong)  UILabel *scoreThemLabel;
@property (nonatomic, strong)  UILabel *scoreDividerLabel;
@property (nonatomic, strong)  UIButton *keepScoreButton;

@property BOOL bannerIsVisible;
@property bool getInfo;
@property (nonatomic, strong) UIButton *defaultScoringButton;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) UIButton *updateLocationButton;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) UIButton *moreDetail;
@property (nonatomic, strong) UITextView *scoringNotEnabled;
@property (nonatomic, strong) UIButton *enableScoring;

@property bool isScoringEnabled;

@property (nonatomic, strong) UIAlertView *nameGameLocation;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) UILabel *opponent;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;


@property (nonatomic, strong) CLLocationManager *locationManager;
@property bool updateSuccess;

@property (nonatomic, strong) UILabel *successMessage;
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
