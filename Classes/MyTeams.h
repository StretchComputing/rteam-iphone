//
//  MyTeams.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface MyTeams : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate,
MFMessageComposeViewControllerDelegate> {
	
	NSArray *teams;
	IBOutlet UIView *header;
	IBOutlet UIView *footer;
	NSString *error;
	NSString *didRegister;
	int deleteRow;
	int teamsStored;
	int numMemberTeams;
	
	UIAlertView *alertOne;
	UIAlertView *alertTwo;
	
	
	NSMutableArray *memberTeams;
	NSMutableArray *fanTeams;
	bool noMemberTeams;
	bool noFanTeams;
	
	bool deleteMember;
	bool deleteFan;
	bool quickCreate;
	bool haveTeamList;
	NSArray *homeTeamList;
	
	ADBannerView *myAd;
	BOOL bannerIsVisible;
	IBOutlet UIButton *createTeamButton;
	UIButton *joinTeamButton;
	
	IBOutlet UITableView *myTableView;
	IBOutlet UIView *viewLine;
	
	NSMutableArray *phoneOnlyArray;
	
	UIAlertView *myAlertView;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	bool gettingTeams;
	
	NSString *newlyCreatedTeam;
	
	NSMutableArray *allTeamsArray;
    
    bool displayNa;
    bool displayError;
    bool fromHome;
}
@property bool fromHome;
@property bool displayError;
@property bool displayNa;
@property (nonatomic, strong) NSMutableArray *allTeamsArray;
@property (nonatomic, strong) NSString *newlyCreatedTeam;
@property bool gettingTeams;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UIAlertView *myAlertView;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) UIView *viewLine;
@property (nonatomic, strong) UITableView *myTableView;
@property bool quickCreate;
@property (nonatomic, strong) UIButton *createTeamButton;
@property (nonatomic, strong) UIButton *joinTeamButton;
@property BOOL bannerIsVisible;
@property bool haveTeamList;
@property (nonatomic, strong) NSArray *homeTeamList;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSMutableArray *memberTeams;
@property (nonatomic, strong) NSMutableArray *fanTeams;
@property bool noFanTeams;
@property bool noMemberTeams;

@property bool deleteMember;
@property bool deleteFan;

@property (nonatomic, strong) NSArray *teams;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) NSString *didRegister;
@property int deleteRow;
@property int teamsStored;
@property int numMemberTeams;

-(IBAction)create;
-(IBAction)findTeam;
- (IBAction) EditTable:(id)sender;
-(void)getAllTeams;
-(void)deleteActionSheet;
@end
