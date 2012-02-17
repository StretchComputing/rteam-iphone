//
//  ScoreNowScorePage.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreNowScoring.h"

@class ScoreNowScoring;

@interface ScoreNowScorePage : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSArray *emailArray;
@property bool isNewTeam;
@property (nonatomic, strong) ScoreNowScoring *theScoreView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *gameTableActivity;
@property (nonatomic, strong) NSString *selectedTeamId;
@property (nonatomic, strong) NSString *selectedGameId;
@property bool hasTeams;
@property (nonatomic, strong) NSArray *teamList;

@property (nonatomic, strong) IBOutlet UIView *noTeamsView;
@property (nonatomic, strong) IBOutlet UIView *currentTeamsView;

@property (nonatomic, strong) IBOutlet UITextField *teamNameField;
@property (nonatomic, strong) IBOutlet UITextField *sportField;

@property (nonatomic, strong) IBOutlet UIButton *teamSelectButton;
@property (nonatomic, strong) IBOutlet UIButton *gameSelectButton;
@property (nonatomic, strong) NSArray *gameList;


@property (nonatomic, strong) IBOutlet UILabel *selectLabel;
@property (nonatomic, strong) IBOutlet UITableView *selectTable;
@property (nonatomic, strong) IBOutlet UIView *selectView;
@property bool isTeamTable;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *gameActivity;
@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;

@property (nonatomic, strong) UIAlertView *addMembersAlert;
@property (nonatomic, strong) NSString *sendScoreUs;
@property (nonatomic, strong) NSString *sendScoreThem;
@property (nonatomic, strong) NSString *sendInterval;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mainActivity;
@property (nonatomic, strong) NSString *sendTeamName;
@property (nonatomic, strong) NSString *sendSport;
@property bool gameIsOver;

@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;


-(IBAction)endText;
-(IBAction)teamSelect;
-(IBAction)gameSelect;
@end
