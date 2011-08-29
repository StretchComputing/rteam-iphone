//
//  SettingsTabs.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface SettingsTabs : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {

	NSString *fromRegisterFlow;
	NSString *didRegister;
	int numMemberTeams;

	bool displaySuccess;
    
    bool passwordReset;
	NSString *passwordResetQuestion;
	bool haveUserInfo;
	IBOutlet UITableView *myTableView;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	ADBannerView *myAd;
	
	BOOL bannerIsVisible;
    
    IBOutlet UIActivityIndicatorView *largeActivity;
    
    bool doneGames;
    bool doneEvents;
    NSArray *allGames;
    NSArray *allEvents;
    NSMutableArray *gamesAndEvents;
    
    bool didSynch;
    bool synchSuccess;
}
@property bool displaySuccess;

@property (nonatomic, retain) NSString *fromRegisterFlow;
@property (nonatomic, retain) NSString *didRegister;
@property int numMemberTeams;

@property bool didSynch;
@property bool synchSuccess;
@property bool doneGames;
@property bool doneEvents;
@property (nonatomic, retain) NSArray *allGames;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSMutableArray *gamesAndEvents;

@property (nonatomic, retain) UIActivityIndicatorView *largeActivity;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property bool haveUserInfo;
@property bool passwordReset;
@property (nonatomic, retain) NSString *passwordResetQuestion;

-(void)getUserInfo;

@end
