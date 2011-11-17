//
//  GameNotes.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Gameday.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "JSON/JSON.h"
#import "GameUpdateGPS.h"
#import "MapLocation.h"
#import <iAd/iAd.h>

#import "AddGamePhoto.h"
#import "GameEdit.h"
#import "GANTracker.h"



@implementation Gameday
@synthesize gameId, teamId, opponent, day, time, locationManager, updateSuccess, mapButton, locationLabel,
successMessage, latitude, longitude, fromNextUpdate, nameGameLocation, locationName, moreDetail, scoringNotEnabled, 
enableScoring, isScoringEnabled, error, scoreUs, scoreThem, interval, userRole, updateLocationButton, sport, defaultScoringButton, getInfo,
bannerIsVisible, usLabel, scoreUsLabel, themLabel, scoreThemLabel, scoreDividerLabel, keepScoreButton, intervalLabel, setInfoGame, setInfoScore,
refreshActivity, isGameOver, editFinalButton, mainActivity, editDone, startDate, description, opponentString, orOtherInterval, scoringAdded,
errorString, photoButton, showCamera, myAd, myDefaultScoring, myHockeyScoring, mySoccerScoring, myBaseballScoring, myFootballScoring, myLacrosseScoring, myWaterPoloScoring, myBasketballScoring, myUltimateFrisbeeScoring;


-(void)editGame{
	
	GameEdit *editGame = [[GameEdit alloc] init];
	
	editGame.stringDate = self.startDate;
	editGame.opponent = self.opponentString;
	editGame.description = self.description;
	editGame.teamId = self.teamId;
	editGame.gameId = self.gameId;

	
	[self.navigationController pushViewController:editGame animated:YES];
	
}
-(void)viewWillAppear:(BOOL)animated{

    if (myAd.bannerLoaded) {
        myAd.hidden = NO;
        bannerIsVisible = YES;
    }else{
        bannerIsVisible = NO;
        myAd.hidden = YES;
    }
    
	self.isGameOver = false;
	
	self.photoButton.hidden = YES;
	self.showCamera = false;
	[self performSelectorInBackground:@selector(findTwitter) withObject:nil];


	self.keepScoreButton.hidden = YES;
	self.usLabel.hidden = YES;
	self.scoreUsLabel.hidden = YES;
	self.themLabel.hidden = YES;
	self.scoreThemLabel.hidden = YES;
	self.scoreDividerLabel.hidden = YES;
	self.intervalLabel.hidden = YES;
	
	if (self.getInfo) {
		[self.mainActivity startAnimating];
		[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
	}else {
        self.getInfo = true;
	}
	
    
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		[self.tabBarController.navigationItem setRightBarButtonItem:self.editDone];
	}

	
}
-(void)viewDidLoad{
		
    self.editDone = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editGame)];

	self.scoringAdded = false;
	self.getInfo = false;
	self.orOtherInterval.hidden = YES;
	[self viewWillAppear:NO];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.defaultScoringButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.enableScoring setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.mapButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.updateLocationButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.keepScoreButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.editFinalButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];


	self.mapButton.hidden = YES;
	self.enableScoring.hidden = YES;
	self.keepScoreButton.hidden = YES;
	self.editFinalButton.hidden = YES;
	self.defaultScoringButton.hidden = YES;
	self.scoringNotEnabled.hidden = YES;
	
	

    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];

}


-(void)getGameInfo{
	
	@autoreleasepool {
        self.errorString = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *gameInfo = [NSDictionary dictionary];
        //If there is a token, do a DB lookup to find the game info 
        if (![token isEqualToString:@""]){

            
            NSDictionary *response = [ServerAPI getGameInfo:self.gameId :self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
                        
            if ([status isEqualToString:@"100"]){
                
                gameInfo = [response valueForKey:@"gameInfo"];
                self.errorString = @"";
                                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.errorString = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.errorString = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        [self performSelectorOnMainThread:@selector(didFinish:) withObject:gameInfo waitUntilDone:NO];

    }
    
}

-(void)didFinish:(NSDictionary *)gameInfo{
    
	self.error.text = self.errorString;
	[self.mainActivity stopAnimating];
	[self.refreshActivity stopAnimating];
    
    if ([self.errorString isEqualToString:@""] ) {
        
        NSString *starDate = [gameInfo valueForKey:@"startDate"];
                
        self.startDate = startDate;
        
        if ([gameInfo valueForKey:@"location"] != nil) {
            NSString *locationString = [gameInfo valueForKey:@"location"];
            self.locationName = locationString;
            self.locationLabel.text = [NSString stringWithFormat:@"- %@", locationString];
            self.locationLabel.textColor = [UIColor blackColor];
        }else {
            self.locationLabel.text = @"- *No location entered*";
            self.locationLabel.textColor = [UIColor grayColor];
        }
        
        
        NSString *opp = [gameInfo valueForKey:@"opponent"];
                
        self.description = [gameInfo valueForKey:@"description"];
        self.opponentString = opp;
        if ([gameInfo valueForKey:@"latitude"] != nil) {
            
            self.latitude = [[gameInfo valueForKey:@"latitude"] stringValue];
            self.longitude = [[gameInfo valueForKey:@"longitude"] stringValue];
            
            [self.mapButton setHidden:NO];
        }else{
            [self.mapButton setHidden:YES];
        }
        
        self.opponent.text = [@"- " stringByAppendingString:[@"Game vs. " stringByAppendingString:opp]];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
        NSDate *formatStartDate = [dateFormat dateFromString:starDate];
        
        NSDate *todaysDate = [NSDate date];
        
        if ([gameInfo valueForKey:@"interval"] != nil) {
            
            self.interval = [[gameInfo valueForKey:@"interval"] stringValue];
            self.scoreUs = [[gameInfo valueForKey:@"scoreUs"] stringValue];
            self.scoreThem = [[gameInfo valueForKey:@"scoreThem"] stringValue];
            
            if ([self.interval isEqualToString:@"-1"]) {
                //Game is over
                self.isGameOver = true;
                
            }else if (![self.interval isEqualToString:@"0"]) {
                //If the game has already started, or is over, display the scoring view
                self.setInfoScore = true;
                self.setInfoGame = false;
                
            }else if ([formatStartDate isEqualToDate:[todaysDate earlierDate:formatStartDate]]) {
                //By date, game is already in progress
                self.setInfoGame = true; 
                self.setInfoScore = false;
                
                
            }
            
        }
        
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"EEE, MMM dd"];
        [timeFormat setDateFormat:@"h:mm aa"];
        
        self.day.text = [@"- " stringByAppendingString:[format stringFromDate:formatStartDate]];
        self.time.text = [timeFormat stringFromDate:formatStartDate];
        

    }
    
	if (self.setInfoGame) {
		self.setInfoGame = false;
		[self setInfoGameStarted];
	}
	
	if (self.setInfoScore) {
		self.setInfoScore = false;
		[self setInfoScoringStarted];
	}
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
	}else {
		self.updateLocationButton.hidden = YES;
	}
	
	
	if (self.isGameOver) {
		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			self.editFinalButton.hidden = NO;
		}else {
			self.editFinalButton.hidden = YES;
		}
		[self setInfoScoringStarted]; 
		self.intervalLabel.text = @"Final";
		self.intervalLabel.hidden = NO;
		self.keepScoreButton.hidden = YES;
		self.orOtherInterval.hidden = YES;

	}else {
		self.editFinalButton.hidden = YES;
		
		[self.defaultScoringButton setHidden:YES];
		if (self.isScoringEnabled) {
			
			if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
				self.keepScoreButton.hidden = NO;
			}else {
				self.keepScoreButton.hidden = YES;
			}
			
			
		}else {
			
			if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
				
				
				[self.enableScoring setHidden:NO];
				
			}else {
				self.scoringNotEnabled.text = @"Scoring is not enabled yet.  It will enable when a team coordinator starts keeping score.";
				[self.enableScoring setHidden:YES];
			}
			
			[self.scoringNotEnabled setHidden:NO];
			
		}

		
	}

		
	
	
}
-(void)map{
	
	MapLocation *tmp = [[MapLocation alloc] init];
	tmp.eventLatCoord = [self.latitude doubleValue];
	tmp.eventLongCoord = [self.longitude doubleValue];
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)updateGpsAction{
	
	GameUpdateGPS *tmp = [[GameUpdateGPS alloc] init];
	tmp.teamId = self.teamId;
	tmp.gameId = self.gameId;
	tmp.locationString = self.locationName;

	[self.navigationController pushViewController:tmp animated:YES];
	
}


-(void)enableScoringAction{
	
	self.scoringNotEnabled.hidden = YES;
	self.defaultScoringButton.hidden = YES;
	self.enableScoring.hidden = YES;
	self.usLabel.hidden = NO;
	self.scoreUsLabel.hidden = NO;
	self.themLabel.hidden = NO;
	self.scoreThemLabel.hidden = NO;
	self.scoreDividerLabel.hidden = NO;
	self.intervalLabel.hidden = NO;
	
	self.scoreUsLabel.text = @"0";
	self.scoreThemLabel.text = @"0";
	self.intervalLabel.text = @"0";
	
	self.isScoringEnabled = true;
	self.keepScoreButton.hidden = NO;

	
	[self keepScore];
	/*
	self.isScoringEnabled = true;
		
	if ([self.sport isEqualToString:@"Baseball"] || [self.sport isEqualToString:@"Softball"]) {
		
		BaseballScoring *tmp = [[BaseballScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Basketball"]) {
		
		BasketballScoring *tmp = [[BasketballScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	} else if ([self.sport isEqualToString:@"Football"] || [self.sport isEqualToString:@"Flag Football"]) {
		
		FootballScoring *tmp = [[FootballScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Hockey"]) {
		
		HockeyScoring *tmp = [[HockeyScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Water Polo"]) {
		
		WaterPoloScoring *tmp = [[WaterPoloScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Lacrosse"] || [self.sport isEqualToString:@"LaCrosse"]) {
		
		LacrosseScoring *tmp = [[LacrosseScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Soccer"]) {
		
		SoccerScoring *tmp = [[SoccerScoring alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([self.sport isEqualToString:@"Ultimate Frisbee"]) {
		
		UltimateFrisbee *tmp = [[UltimateFrisbee alloc] init];
		tmp.teamId = self.teamId;
		tmp.gameId = self.gameId;
		tmp.initScoreUs = self.scoreUs;
		tmp.initScoreThem = self.scoreThem;
		tmp.interval = self.interval;
		
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			tmp.isCoord = true;
		}else {
			tmp.isCoord = false;
		}
		
		tmp.view.frame = CGRectMake(18, 200, 284, 185);
		[self.view addSubview:tmp.view];
		[self.view bringSubviewToFront:tmp.view];
		
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];

		[self.view setNeedsDisplay];
		
	}else {
		self.isScoringEnabled = false;
		[self.enableScoring setHidden:YES];
		NSString *message = [NSString stringWithFormat:@"Sorry, but scoring is not currently supported for your sport.  Your current sport is: %@.  To use default scoring, click the button below.", self.sport];
		self.scoringNotEnabled.text =message;
		[self.defaultScoringButton setHidden:NO];

		[self.view setNeedsDisplay];
		
		if (![self.interval isEqualToString:@"0"]) {
			[self defaultScoring];
		}
	}
*/
		
	
}

-(void)defaultScoring{
	
	/*
	self.isScoringEnabled = true;
	
	DefaultScoring *tmp = [[DefaultScoring alloc] init];
	tmp.teamId = self.teamId;
	tmp.gameId = self.gameId;
	tmp.initScoreUs = self.scoreUs;
	tmp.initScoreThem = self.scoreThem;
	tmp.interval = self.interval;
	
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		tmp.isCoord = true;
	}else {
		tmp.isCoord = false;
	}
	
	tmp.view.frame = CGRectMake(18, 181, 284, 185);
	[self.view addSubview:tmp.view];
	[self.view bringSubviewToFront:tmp.view];
	
	[self.enableScoring setHidden:YES];
	[self.scoringNotEnabled setHidden:YES];
	[self.defaultScoringButton setHidden:YES];
	[self.view setNeedsDisplay];

	*/
}

-(void)moreDetailAction{
	
}

//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	
	if (!self.bannerIsVisible) {
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		
        [self.view bringSubviewToFront:myAd];
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
	
	
}

-(void)keepScore{
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Keep Score"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	NSString *lowerSport = [self.sport lowercaseString];
	self.scoringAdded = true;
	if ([lowerSport isEqualToString:@"football"] || [lowerSport isEqualToString:@"flag football"]) {
		
		self.myFootballScoring = [[NewFootballScoring alloc] init];
		
		self.myFootballScoring.teamId = self.teamId;
		self.myFootballScoring.gameId = self.gameId;
		self.myFootballScoring.initScoreUs = self.scoreUs;
		self.myFootballScoring.initScoreThem = self.scoreThem;
		self.myFootballScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myFootballScoring.isCoord = true;
		}else {
			self.myFootballScoring.isCoord = false;
		}
		
		self.myFootballScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myFootballScoring.view];
		[self.view bringSubviewToFront:self.myFootballScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"basketball"]) {
		
		self.myBasketballScoring = [[NewBasketballScoring alloc] init];
		
		self.myBasketballScoring.teamId = self.teamId;
		self.myBasketballScoring.gameId = self.gameId;
		self.myBasketballScoring.initScoreUs = self.scoreUs;
		self.myBasketballScoring.initScoreThem = self.scoreThem;
		self.myBasketballScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myBasketballScoring.isCoord = true;
		}else {
			self.myBasketballScoring.isCoord = false;
		}
		
		self.myBasketballScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myBasketballScoring.view];
		[self.view bringSubviewToFront:self.myBasketballScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"soccer"]) {
		
		self.mySoccerScoring = [[NewSoccerScoring alloc] init];
		
		self.mySoccerScoring.teamId = self.teamId;
		self.mySoccerScoring.gameId = self.gameId;
		self.mySoccerScoring.initScoreUs = self.scoreUs;
		self.mySoccerScoring.initScoreThem = self.scoreThem;
		self.mySoccerScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.mySoccerScoring.isCoord = true;
		}else {
			self.mySoccerScoring.isCoord = false;
		}
		
		self.mySoccerScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.mySoccerScoring.view];
		[self.view bringSubviewToFront:self.mySoccerScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"lacrosse"]) {
		
		self.myLacrosseScoring = [[NewLacrosseScoring alloc] init];
		
		self.myLacrosseScoring.teamId = self.teamId;
		self.myLacrosseScoring.gameId = self.gameId;
		self.myLacrosseScoring.initScoreUs = self.scoreUs;
		self.myLacrosseScoring.initScoreThem = self.scoreThem;
		self.myLacrosseScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myLacrosseScoring.isCoord = true;
		}else {
			self.myLacrosseScoring.isCoord = false;
		}
		
		self.myLacrosseScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myLacrosseScoring.view];
		[self.view bringSubviewToFront:self.myLacrosseScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"water polo"]) {
		
		self.myWaterPoloScoring = [[NewWaterPoloScoring alloc] init];
		
		self.myWaterPoloScoring.teamId = self.teamId;
		self.myWaterPoloScoring.gameId = self.gameId;
		self.myWaterPoloScoring.initScoreUs = self.scoreUs;
		self.myWaterPoloScoring.initScoreThem = self.scoreThem;
		self.myWaterPoloScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myWaterPoloScoring.isCoord = true;
		}else {
			self.myWaterPoloScoring.isCoord = false;
		}
		
		self.myWaterPoloScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myWaterPoloScoring.view];
		[self.view bringSubviewToFront:self.myWaterPoloScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"hockey"]) {
		
		self.myHockeyScoring = [[NewHockeyScoring alloc] init];
		
		self.myHockeyScoring.teamId = self.teamId;
		self.myHockeyScoring.gameId = self.gameId;
		self.myHockeyScoring.initScoreUs = self.scoreUs;
		self.myHockeyScoring.initScoreThem = self.scoreThem;
		self.myHockeyScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myHockeyScoring.isCoord = true;
		}else {
			self.myHockeyScoring.isCoord = false;
		}
		
		self.myHockeyScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myHockeyScoring.view];
		[self.view bringSubviewToFront:self.myHockeyScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if ([lowerSport isEqualToString:@"ultimate frisbee"]) {
		
		self.myUltimateFrisbeeScoring = [[NewUltimateFrisbeeScoring alloc] init];
		
		self.myUltimateFrisbeeScoring.teamId = self.teamId;
		self.myUltimateFrisbeeScoring.gameId = self.gameId;
		self.myUltimateFrisbeeScoring.initScoreUs = self.scoreUs;
		self.myUltimateFrisbeeScoring.initScoreThem = self.scoreThem;
		self.myUltimateFrisbeeScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myUltimateFrisbeeScoring.isCoord = true;
		}else {
			self.myUltimateFrisbeeScoring.isCoord = false;
		}
		
		self.myUltimateFrisbeeScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myUltimateFrisbeeScoring.view];
		[self.view bringSubviewToFront:self.myUltimateFrisbeeScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}else if (([lowerSport isEqualToString:@"baseball"]) || ([lowerSport isEqualToString:@"softball"])) {
		
		self.myBaseballScoring = [[NewBaseballScoring alloc] init];
		
		self.myBaseballScoring.teamId = self.teamId;
		self.myBaseballScoring.gameId = self.gameId;
		self.myBaseballScoring.initScoreUs = self.scoreUs;
		self.myBaseballScoring.initScoreThem = self.scoreThem;
		self.myBaseballScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myBaseballScoring.isCoord = true;
		}else {
			self.myBaseballScoring.isCoord = false;
		}
		
		self.myBaseballScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myBaseballScoring.view];
		[self.view bringSubviewToFront:self.myBaseballScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
		
		
	}else{
		
		self.myDefaultScoring = [[NewDefaultScoring alloc] init];
		
		self.myDefaultScoring.teamId = self.teamId;
		self.myDefaultScoring.gameId = self.gameId;
		self.myDefaultScoring.initScoreUs = self.scoreUs;
		self.myDefaultScoring.initScoreThem = self.scoreThem;
		self.myDefaultScoring.interval = self.interval;
		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
			self.myDefaultScoring.isCoord = true;
		}else {
			self.myDefaultScoring.isCoord = false;
		}
		
		self.myDefaultScoring.view.frame = CGRectMake(0, 142, 320, 225);
		[self.view addSubview:self.myDefaultScoring.view];
		[self.view bringSubviewToFront:self.myDefaultScoring.view];
		
		[self.enableScoring setHidden:YES];
		[self.scoringNotEnabled setHidden:YES];
		[self.defaultScoringButton setHidden:YES];
		[self.view setNeedsDisplay];
		
	}
	
	
	
}


-(void)setInfoScoringStarted{
	
	self.scoringNotEnabled.hidden = YES;
	self.defaultScoringButton.hidden = YES;
	self.enableScoring.hidden = YES;
	
	
	self.usLabel.hidden = NO;
	self.scoreUsLabel.hidden = NO;
	self.themLabel.hidden = NO;
	self.scoreThemLabel.hidden = NO;
	self.scoreDividerLabel.hidden = NO;
	self.intervalLabel.hidden = NO;
	
	self.scoreUsLabel.text = self.scoreUs;
	self.scoreThemLabel.text = self.scoreThem;
	
	NSString *intervalString = [self getIntervalString];
	
	if ([intervalString isEqualToString:@""]) {
		self.intervalLabel.hidden = YES;
	}else {
		
		if ([self.interval isEqualToString:@"-2"]) {
			self.interval = @"OT";
		}
		self.intervalLabel.text = [NSString stringWithFormat:@"%@: %@", intervalString, self.interval];
		self.intervalLabel.hidden = NO;

	}

	
	if ([[self.sport lowercaseString] isEqualToString:@"lacrosse"]) {
		self.orOtherInterval.hidden = NO;
		self.orOtherInterval.text = @"(or Period)";
	}else if ([[self.sport lowercaseString] isEqualToString:@"soccer"]) {
		self.orOtherInterval.hidden = NO;
		self.orOtherInterval.text = @"(or Half)";
	}else {
		self.orOtherInterval.hidden = YES;
	}

	self.isScoringEnabled = true;
}

-(void)setInfoGameStarted{
	
	self.scoringNotEnabled.hidden = YES;
	self.defaultScoringButton.hidden = YES;
	self.enableScoring.hidden = YES;
	self.usLabel.hidden = NO;
	self.scoreUsLabel.hidden = NO;
	self.themLabel.hidden = NO;
	self.scoreThemLabel.hidden = NO;
	self.scoreDividerLabel.hidden = NO;
	self.intervalLabel.hidden = NO;
	
	self.scoreUsLabel.text = @"0";
	self.scoreThemLabel.text = @"0";
	self.interval = @"1";
	
	
	NSString *intervalString = [self getIntervalString];
	
	if ([intervalString isEqualToString:@""]) {
		self.intervalLabel.hidden = YES;
	}else {
		self.intervalLabel.text = [NSString stringWithFormat:@"%@: %@", intervalString, self.interval];
		self.intervalLabel.hidden = NO;
		
	}
	
	if ([[self.sport lowercaseString] isEqualToString:@"lacrosse"]) {
		self.orOtherInterval.hidden = NO;
		self.orOtherInterval.text = @"(or Period)";
	}else if ([[self.sport lowercaseString] isEqualToString:@"soccer"]) {
		self.orOtherInterval.hidden = NO;
		self.orOtherInterval.text = @"(or Half)";
	}else {
		self.orOtherInterval.hidden = YES;
	}
	
	self.isScoringEnabled = true;
	
	
}
-(void)refreshScore{
	
	[self.refreshActivity startAnimating];
	[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
}

-(void)editFinal{
	
	self.interval = @"1";
	self.isGameOver = false;
	[self keepScore];
	[self.editFinalButton setHidden:YES];
	
}

-(NSString *)getIntervalString{

	NSString *lowerSport = [self.sport lowercaseString];
		
	if ([lowerSport isEqualToString:@"baseball"] || [lowerSport isEqualToString:@"softball"]) {
		return @"Inning";
	}else if ([lowerSport isEqualToString:@"hockey"] || [lowerSport isEqualToString:@"water polo"]) {
		return @"Period";
	}else if ([lowerSport isEqualToString:@"basketball"] || [lowerSport isEqualToString:@"football"] || [lowerSport isEqualToString:@"soccer"] || [lowerSport isEqualToString:@"lacrosse"]
			  || [lowerSport isEqualToString:@"flag football"]) {
		return @"Quarter";
	}else {
		return @"";
	}

	
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.scoringAdded) {
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint location = [touch locationInView:touch.view];
	
		
		if ((location.y < 142) && (location.y > 50)) {
			NSArray *subs = [self.view subviews];
			
			UIView *tmp = [subs objectAtIndex:[subs count] - 1];
			tmp.hidden = YES;
			[self.refreshActivity startAnimating];
			[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
		}
		
	}
	
}



-(void)photo{
	
	AddGamePhoto *tmp = [[AddGamePhoto alloc] init];
	tmp.teamId = self.teamId;
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Gameday" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.tabBarController.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:NO];
	
}


-(void)findTwitter{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            NSDictionary *response = [ServerAPI getTeamInfo:self.teamId :token :@"false"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *teamInfo = [response valueForKey:@"teamInfo"];
                
                self.showCamera = [[teamInfo valueForKey:@"useTwitter"] boolValue];
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(doneTwitter) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneTwitter{

	if (self.showCamera) {
		self.photoButton.hidden = NO;
	}else {
		self.photoButton.hidden = YES;
	}

	
}
-(void)viewDidUnload{
	

	opponent = nil;
	day = nil;
	time = nil;
    error = nil;
	successMessage = nil;
    refreshActivity = nil;
    usLabel = nil;
	scoreUsLabel = nil;
	themLabel = nil;
	scoreThemLabel = nil;
    defaultScoringButton = nil;
	photoButton = nil;
    orOtherInterval = nil;
	mainActivity = nil;
	keepScoreButton = nil;
	intervalLabel = nil;
	editFinalButton = nil;
    scoreDividerLabel = nil;
    myAd.delegate = nil;
	myAd = nil;
	mapButton = nil;
	locationLabel = nil;
    enableScoring = nil;
    updateLocationButton = nil;
    moreDetail = nil;
	scoringNotEnabled = nil;
	editDone = nil;

	[super viewDidUnload];


}


@end
