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
@property (nonatomic, retain) NSMutableArray *allTeamsArray;
@property (nonatomic, retain) NSString *newlyCreatedTeam;
@property bool gettingTeams;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) UIAlertView *myAlertView;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property (nonatomic, retain) UIView *viewLine;
@property (nonatomic, retain) UITableView *myTableView;
@property bool quickCreate;
@property (nonatomic, retain) UIButton *createTeamButton;
@property (nonatomic, retain) UIButton *joinTeamButton;
@property BOOL bannerIsVisible;
@property bool haveTeamList;
@property (nonatomic, retain) NSArray *homeTeamList;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSMutableArray *memberTeams;
@property (nonatomic, retain) NSMutableArray *fanTeams;
@property bool noFanTeams;
@property bool noMemberTeams;

@property bool deleteMember;
@property bool deleteFan;

@property (nonatomic, retain) NSArray *teams;
@property (nonatomic, retain) UIView *header;
@property (nonatomic, retain) UIView *footer;
@property (nonatomic, retain) NSString *didRegister;
@property int deleteRow;
@property int teamsStored;
@property int numMemberTeams;

-(IBAction)create;
-(IBAction)findTeam;
- (IBAction) EditTable:(id)sender;
-(void)getAllTeams;
-(void)deleteActionSheet;
@end
