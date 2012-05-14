//
//  TeamHome.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "BoxScoreViewViewController.h"



@interface TeamHome : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate> {

}
@property (nonatomic, strong) BoxScoreViewViewController *pastGame;
@property (nonatomic, strong) BoxScoreViewViewController *futureGame;

@property (nonatomic, strong) IBOutlet UILabel *recordLabel;
@property (nonatomic, strong) NSString *recordString;
@property bool doneEvents;
@property bool doneGames;
@property bool doneMembers;
@property (nonatomic, strong) IBOutlet UILabel *noEventsLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *largeActivity;
@property (nonatomic, strong) IBOutlet UIButton *addEventsButton;
@property (nonatomic, strong) IBOutlet UIButton *addMembersButton;
@property (nonatomic, strong) IBOutlet UILabel *recentGamesLabel;

@property bool fromHome;
@property (nonatomic, strong) IBOutlet UIButton *editButton;

@property bool displayPhoto;
@property (nonatomic, strong) ADBannerView *myAd;
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
@property (nonatomic, strong) IBOutlet UILabel *nextGameLabel;
@property (nonatomic, strong) IBOutlet UILabel *nextEventLabel;
@property (nonatomic) CGPoint touchUpLocation;
@property (nonatomic) CGPoint gestureStartPoint;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *eventsActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, strong) NSMutableArray *nextEventArray;
@property (nonatomic, strong) NSMutableArray *eventsArray;
@property (nonatomic, strong) NSMutableArray *futureEventsArray;
@property bool eventSuccess;
@property (nonatomic, strong) IBOutlet UILabel *nextEventInfoLabel;
@property (nonatomic, strong) IBOutlet UIButton *nextEventButton;
@property (nonatomic, strong) IBOutlet UIView *allScoresButtonUnderline;

@property (nonatomic, strong) NSString *teamUrl;
@property (nonatomic, strong) NSMutableArray *nextGameArray;
@property bool gameSuccess;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSMutableArray *pastGamesArray;

@property (nonatomic, strong) NSMutableArray *gamesArray;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *teamSport;

@property (nonatomic, strong)  IBOutlet UILabel *teamNameLabel;
@property (nonatomic, strong)  IBOutlet UILabel *nextGameInfoLabel;

@property (nonatomic, strong)  IBOutlet UIImageView *topRight;
@property (nonatomic, strong)  IBOutlet UIImageView *topLeft;

@property (nonatomic, strong)  IBOutlet UITableView *recentGamesTable;

@property (nonatomic, strong)  IBOutlet UIButton *allScoresButton;
@property (nonatomic, strong)  IBOutlet UIButton *nextGameButton;


@property (nonatomic, strong)  UILabel *pastGameLabel;
@property (nonatomic, strong)  UILabel *futureGameLabel;

-(IBAction)schedule;
-(IBAction)allScores;
//-(IBAction)webPage;
-(IBAction)nextGame;
-(IBAction)nextEvent;
-(NSString *)getMvp:(NSArray *)memberTallies;
-(IBAction)editTeam;

-(IBAction)addMembers;
//-(IBAction)addEvents;

-(NSString *)getIntervalLabelFromInterval:(NSString *)interval1;

@end
