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
#import "NewFootballScoring.h"
#import "NewBasketballScoring.h"
#import "NewSoccerScoring.h"
#import "NewBaseballScoring.h"
#import "BoxScoreViewViewController.h"

@interface Gameday : UIViewController <CLLocationManagerDelegate, ADBannerViewDelegate> {
    

}
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) BoxScoreViewViewController *scoreView;
@property (nonatomic, strong) NewBaseballScoring *myBaseballScoring;
@property (nonatomic, strong) NewBasketballScoring *myBasketballScoring;
@property (nonatomic, strong) NewFootballScoring *myFootballScoring;

@property (nonatomic, strong) NewSoccerScoring *mySoccerScoring;


@property (nonatomic, strong) ADBannerView *myAd;
@property bool showCamera;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) NSString *errorString;
@property bool scoringAdded;
@property (nonatomic, strong) IBOutlet UILabel *orOtherInterval;
@property (nonatomic, strong) NSString *opponentString;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) UIBarButtonItem *editDone;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mainActivity;
@property (nonatomic, strong) IBOutlet UIButton *editFinalButton;
@property bool isGameOver;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *refreshActivity;
@property bool setInfoGame;
@property bool setInfoScore;
@property (nonatomic, strong) IBOutlet UILabel *intervalLabel;
@property (nonatomic, strong)  IBOutlet UILabel *usLabel;
@property (nonatomic, strong)  IBOutlet UILabel *scoreUsLabel;
@property (nonatomic, strong) IBOutlet  UILabel *themLabel;
@property (nonatomic, strong)  IBOutlet UILabel *scoreThemLabel;
@property (nonatomic, strong)  IBOutlet UILabel *scoreDividerLabel;
@property (nonatomic, strong)  IBOutlet UIButton *keepScoreButton;

@property BOOL bannerIsVisible;
@property bool getInfo;
@property (nonatomic, strong) IBOutlet UIButton *defaultScoringButton;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) IBOutlet UIButton *updateLocationButton;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *scoreUs;
@property (nonatomic, strong) NSString *scoreThem;
@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UIButton *mapButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) IBOutlet UIButton *moreDetail;
@property (nonatomic, strong) IBOutlet UITextView *scoringNotEnabled;
@property (nonatomic, strong) IBOutlet UIButton *enableScoring;

@property bool isScoringEnabled;

@property (nonatomic, strong) UIAlertView *nameGameLocation;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) IBOutlet UILabel *opponent;
@property (nonatomic, strong) IBOutlet UILabel *day;
@property (nonatomic, strong) IBOutlet UILabel *time;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;


@property (nonatomic, strong) CLLocationManager *locationManager;
@property bool updateSuccess;

@property (nonatomic, strong) IBOutlet UILabel *successMessage;
@property bool fromNextUpdate;
@property (nonatomic, strong) IBOutlet UIView *greenBackView;

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
-(NSString *)getIntervalLabelFromInterval:(NSString *)interval1;
@end
