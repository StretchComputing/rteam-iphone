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
@property (nonatomic, strong) NSMutableArray *gamesArrayTemp;
@property (nonatomic, strong) NSMutableArray *pastGamesArrayTemp;
@property bool displayedMemberAlert;
@property bool displayedEventAlert;
@property (nonatomic, strong) UIAlertView *eventsAlert;
@property (nonatomic, strong) UIAlertView *membersAlert;

@property bool noMembers;
@property bool noEvents;
@property bool noGames;
@property (nonatomic, strong) NSString *teamInfoThumbnail;
@property (nonatomic, strong) UILabel *nextGameLabel;
@property (nonatomic, strong) UILabel *nextEventLabel;
@property (nonatomic) CGPoint touchUpLocation;
@property (nonatomic) CGPoint gestureStartPoint;
@property (nonatomic, strong) UIActivityIndicatorView *eventsActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSMutableArray *nextEventArray;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSMutableArray *futureEventsArray;
@property bool eventSuccess;
@property (nonatomic, strong) UILabel *nextEventInfoLabel;
@property (nonatomic, strong) UIButton *nextEventButton;
@property (nonatomic, strong) UIView *scheduleButtonUnderline;
@property (nonatomic, strong) UIView *allScoresButtonUnderline;
@property (nonatomic, strong) UIView *webPageButtonUnderline;

@property (nonatomic, strong) NSString *teamUrl;
@property (nonatomic, strong) NSMutableArray *nextGameArray;
@property bool gameSuccess;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSMutableArray *pastGamesArray;

@property (nonatomic, strong) NSMutableArray *gamesArray;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *teamSport;

@property (nonatomic, strong)  UILabel *teamNameLabel;
@property (nonatomic, strong)  UILabel *nextGameInfoLabel;

@property (nonatomic, strong)  UIImageView *topRight;
@property (nonatomic, strong)  UIImageView *topLeft;

@property (nonatomic, strong)  UITableView *recentGamesTable;

@property (nonatomic, strong)  UIButton *scheduleButton;
@property (nonatomic, strong)  UIButton *allScoresButton;
@property (nonatomic, strong)  UIButton *webPageButton;
@property (nonatomic, strong)  UIButton *nextGameButton;

-(IBAction)schedule;
-(IBAction)allScores;
-(IBAction)webPage;
-(IBAction)nextGame;
-(IBAction)nextEvent;
-(NSString *)getMvp:(NSArray *)memberTallies;
@end
