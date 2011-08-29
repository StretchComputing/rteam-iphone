//
//  TeamHome.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>



@interface TeamHome : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate> {

	NSMutableArray *nextGameArray;
	NSString *teamId;
	NSString *userRole;
	NSString *teamSport;
	NSString *teamName;
	
	NSString *teamUrl;
	bool gameSuccess;
	IBOutlet UILabel *errorLabel;
	
	NSMutableArray *gamesArray;
	NSMutableArray *pastGamesArray;
	
	IBOutlet UILabel *teamNameLabel;
	IBOutlet UILabel *nextGameInfoLabel;
	
	IBOutlet UIImageView *topRight;
	IBOutlet UIImageView *topLeft;
	
	IBOutlet UITableView *recentGamesTable;
	
	IBOutlet UIButton *scheduleButton;
	IBOutlet UIButton *allScoresButton;
	IBOutlet UIButton *webPageButton;
	IBOutlet UIView *scheduleButtonUnderline;
	IBOutlet UIView *allScoresButtonUnderline;
	IBOutlet UIView *webPageButtonUnderline;

	
	IBOutlet UIButton *nextGameButton;
	
	IBOutlet UILabel *nextEventInfoLabel;
	IBOutlet UIButton *nextEventButton;
	
	NSMutableArray *eventsArray;
	NSMutableArray *futureEventsArray;
	bool eventSuccess;
	NSMutableArray *nextEventArray;
	BOOL bannerIsVisible;
	ADBannerView *myAd;
	
	IBOutlet UIActivityIndicatorView *eventsActivity;
	
	CGPoint gestureStartPoint;
	CGPoint touchUpLocation;
	
	IBOutlet UILabel *nextGameLabel;
	IBOutlet UILabel *nextEventLabel;
	
	NSString *teamInfoThumbnail;
	
	bool noEvents;
	bool noGames;
	bool noMembers;
	bool displayedMemberAlert;
	bool displayedEventAlert;
	
	UIAlertView *eventsAlert;
	UIAlertView *membersAlert;
	
	NSMutableArray *pastGamesArrayTemp;
	NSMutableArray *gamesArrayTemp;
	bool displayPhoto;
    bool displayWarning;
}
@property bool displayWarning;
@property (nonatomic, retain) NSMutableArray *gamesArrayTemp;
@property (nonatomic, retain) NSMutableArray *pastGamesArrayTemp;
@property bool displayedMemberAlert;
@property bool displayedEventAlert;
@property (nonatomic, retain) UIAlertView *eventsAlert;
@property (nonatomic, retain) UIAlertView *membersAlert;

@property bool noMembers;
@property bool noEvents;
@property bool noGames;
@property (nonatomic, retain) NSString *teamInfoThumbnail;
@property (nonatomic, retain) UILabel *nextGameLabel;
@property (nonatomic, retain) UILabel *nextEventLabel;
@property (nonatomic) CGPoint touchUpLocation;
@property (nonatomic) CGPoint gestureStartPoint;
@property (nonatomic, retain) UIActivityIndicatorView *eventsActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) NSMutableArray *nextEventArray;
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSMutableArray *futureEventsArray;
@property bool eventSuccess;
@property (nonatomic, retain) UILabel *nextEventInfoLabel;
@property (nonatomic, retain) UIButton *nextEventButton;
@property (nonatomic, retain) UIView *scheduleButtonUnderline;
@property (nonatomic, retain) UIView *allScoresButtonUnderline;
@property (nonatomic, retain) UIView *webPageButtonUnderline;

@property (nonatomic, retain) NSString *teamUrl;
@property (nonatomic, retain) NSMutableArray *nextGameArray;
@property bool gameSuccess;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSMutableArray *pastGamesArray;

@property (nonatomic, retain) NSMutableArray *gamesArray;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *teamSport;

@property (nonatomic, retain)  UILabel *teamNameLabel;
@property (nonatomic, retain)  UILabel *nextGameInfoLabel;

@property (nonatomic, retain)  UIImageView *topRight;
@property (nonatomic, retain)  UIImageView *topLeft;

@property (nonatomic, retain)  UITableView *recentGamesTable;

@property (nonatomic, retain)  UIButton *scheduleButton;
@property (nonatomic, retain)  UIButton *allScoresButton;
@property (nonatomic, retain)  UIButton *webPageButton;
@property (nonatomic, retain)  UIButton *nextGameButton;

-(IBAction)schedule;
-(IBAction)allScores;
-(IBAction)webPage;
-(IBAction)nextGame;
-(IBAction)nextEvent;
-(NSString *)getMvp:(NSArray *)memberTallies;
@end
