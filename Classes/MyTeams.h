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
	

}
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *deleteActivity;
@property bool isDelete;
@property (nonatomic, retain) UIAlertView *alertOne;
@property (nonatomic, retain) UIAlertView *alertTwo;

@property (nonatomic, strong) ADBannerView *myAd;
@property bool fromHome;
@property bool displayError;
@property bool displayNa;
@property (nonatomic, strong) NSMutableArray *allTeamsArray;
@property (nonatomic, strong) NSString *newlyCreatedTeam;
@property bool gettingTeams;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UIAlertView *myAlertView;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) IBOutlet UIView *viewLine;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property bool quickCreate;
@property (nonatomic, strong) IBOutlet UIButton *createTeamButton;
@property (nonatomic, strong) IBOutlet UIButton *joinTeamButton;
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
@property (nonatomic, strong) IBOutlet UIView *header;
@property (nonatomic, strong) IBOutlet UIView *footer;
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
