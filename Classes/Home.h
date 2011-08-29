//
//  Home.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickLinkButton.h"
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "HomeScoreView.h"
#import "HomeAttendanceView.h"

@interface Home : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, ADBannerViewDelegate,
UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>{
	
    HomeScoreView *homeScoreView;
    HomeAttendanceView *homeAttendanceView;
    
	NSString *name;
	NSString *teamId;
	NSString *userRole;  //The role of the current user for this team;
	NSString *oneTeamFlag;
	
	NSString *didRegister;
	int numMemberTeams;
	
	NSArray *games;
	NSArray *practices;
	
	int eventTodayIndex;
	NSString *eventToday;
	
	IBOutlet UIToolbar *bottomBar;
		
	int nextGameIndex;
	int nextPracticeIndex;
	int badgeNumber;
	
	UIBarButtonItem *inviteFan;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *viewControllers;
	
	BOOL pageControlUsed;
	
	IBOutlet UILabel *serverError;
	bool alreadyCalled1;
	bool alreadyCalled2;
	bool alreadyCalledCreate;
	
	bool foundQuick1;
	bool foundQuick2;
	//Quick Link Buttons
	UIButton *quickCreateTeam;
	QuickLinkButton *quickTeamOne;
	QuickLinkButton *quickTeamTwo;
	
	//Quick Link Edit View
	IBOutlet UIScrollView *changeQuickLink;
	IBOutlet UITableView *newQuickLinkTable;
	IBOutlet UITextField *newQuickLinkAlias;
	int rowNewQuickTeam;
	IBOutlet UIActivityIndicatorView *activityGettingTeams;
	IBOutlet UILabel *selectRowLabel;
	
	//Background thread "Get Teams" 
	bool haveTeamList;
	bool teamListFailed;
	NSArray *teamList;
	
	//New Messages badge
	IBOutlet UIImageView *messageBadge;
	int newMessagesCount;
	bool newMessagesSuccess;
	
	//Bottom Half quick links
	NSMutableArray *eventsToday;
	NSMutableArray *eventsTomorrow;
	int numberOfPages;
	IBOutlet UIActivityIndicatorView *eventsNowActivity;
	bool eventsNowSuccess;
	bool eventsNowTryAgain;
	IBOutlet UITextView *eventsNowError;
	NSMutableArray *allBottomButtons;
	
	IBOutlet UIButton *eventsButton;
	
	
	//iAd
	BOOL bannerIsVisible;
	ADBannerView *myAd;
	
	IBOutlet UIButton *myTeamsButton;
	IBOutlet UIButton *activityButton;
	IBOutlet UIButton *messagesButton;
	
	IBOutlet UIButton *fastButton;
	
	IBOutlet UILabel *messageCountLabel;
	
	IBOutlet UIScrollView *displayIconsScroll;
	
	bool isEditingQuickLinkOne;
	
	bool newActivity;
	IBOutlet UIImageView *newActivityBadge;
	IBOutlet UIButton *changeIconButton;
	
	UIActionSheet *undoCancel;
	NSString *undoTeamId;
	NSString *undoEventId;
	NSString *undoEventType;
	
	bool spotOpen;
	bool oneTeam;
	
	UIButton *addMembersButton;
	
	NSString *membersUserRole;
	NSString *membersTeamId;

	NSMutableArray *phoneOnlyArray;
	
	NSString *justAddName;
	
	IBOutlet UIView *displayIconsScrollBack;
	IBOutlet UIView *changeQuickLinkBack;
    
    bool changingLink;
    
    IBOutlet UIBarButtonItem *refreshButton;
    IBOutlet UIBarButtonItem *questionButton;
    
    IBOutlet UIView *backHelpView;
    
    UIView *backViewTop;
    UIView *backViewBottom;

    UIView *transViewTop;
    UIView *transViewBottom;
    
    UIButton *settingQbutton;
    UIButton *searchQbutton;
    UIButton *myTeamsQbutton;

    UIButton *activityQbutton;
    UIButton *messagesQbutton;
    UIButton *eventsQbutton;
    UIButton *quickLinksQbutton;
    UIButton *happeningNowQbutton;
    UIButton *helpQbutton;
    UIButton *inviteFanQbutton;
    UIButton *refreshQbutton;
    
    UIButton *closeQuestionButton;
    
    UITextView *helpExplanation;
    
    IBOutlet UIImageView *homeDivider;
    IBOutlet UIButton *moveDividerButton;
    IBOutlet UILabel *homeDividerLabel;
    
    IBOutlet UIView *moveDividerBackground;
    
    IBOutlet UIView *moveableView;
    BOOL isMoreShowing;
    
    IBOutlet UIImageView *scrollViewBack;
    
    
    //Registration Message stuff
    IBOutlet UIView *registrationBackView;
    IBOutlet UIView *textBackView;
    IBOutlet UIView *textFrontView;
    IBOutlet UITextView *regTextView;
    IBOutlet UIButton *regTextButton;
    int currentDisplay;
    
    UIButton *aboutButton;
    
    double numObjects;
    
    IBOutlet QuickLinkButton *shortcutButton;
    
    IBOutlet UIButton *quickLinkChangeButton;
    IBOutlet UIButton *quickLinkCancelButton;
    IBOutlet UIButton *quickLinkOkButton;
    IBOutlet UIButton *quickLinkCancelTwoButton;
    
    IBOutlet UIImageView *blueArrow;

}
@property (nonatomic, retain) UIImageView *blueArrow;
@property (nonatomic, retain) UIButton *quickLinkCancelTwoButton;

@property (nonatomic, retain) UIButton *quickLinkChangeButton;
@property (nonatomic, retain) UIButton *quickLinkCancelButton;
@property (nonatomic, retain) UIButton *quickLinkOkButton;
@property (nonatomic, retain) QuickLinkButton *shortcutButton;
@property double numObjects;
@property (nonatomic, retain) UIButton *aboutButton;
@property int currentDisplay;
@property (nonatomic, retain) UIView *registrationBackView;
@property (nonatomic, retain) UIView *textBackView;
@property (nonatomic, retain) UIView *textFrontView;
@property (nonatomic, retain) UITextView *regTextView;
@property (nonatomic, retain) UIButton *regTextButton;

@property (nonatomic, retain) UIImageView *scrollViewBack;
@property (nonatomic, retain) UIView *moveableView;
@property BOOL isMoreShowing; 
@property (nonatomic, retain) UIView *moveDividerBackground;
@property (nonatomic, retain) UILabel *homeDividerLabel;
@property (nonatomic, retain) UIButton *moveDividerButton;
@property (nonatomic, retain) UIImageView *homeDivider;
@property (nonatomic, retain) UITextView *helpExplanation;
@property (nonatomic, retain) UIButton *closeQuestionButton;

@property (nonatomic, retain) UIView *backViewTop;
@property (nonatomic, retain) UIView *backViewBottom;

@property (nonatomic, retain) UIView *transViewTop;
@property (nonatomic, retain) UIView *transViewBottom;

@property (nonatomic, retain) UIButton *settingQbutton;
@property (nonatomic, retain) UIButton *searchQbutton;
@property (nonatomic, retain) UIButton *myTeamsQbutton;

@property (nonatomic, retain) UIButton *activityQbutton;
@property (nonatomic, retain) UIButton *messagesQbutton;
@property (nonatomic, retain) UIButton *eventsQbutton;
@property (nonatomic, retain) UIButton *quickLinksQbutton;
@property (nonatomic, retain) UIButton *happeningNowQbutton;
@property (nonatomic, retain) UIButton *helpQbutton;
@property (nonatomic, retain) UIButton *inviteFanQbutton;
@property (nonatomic, retain) UIButton *refreshQbutton;

@property (nonatomic, retain) UIView *backHelpView;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) UIBarButtonItem *questionButton;
@property bool changingLink;
@property (nonatomic, retain) UIView *displayIconsScrollBack;
@property (nonatomic, retain) UIView *changeQuickLinkBack;
@property (nonatomic, retain) NSString *justAddName;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;

@property (nonatomic, retain) NSString *membersUserRole;
@property (nonatomic, retain) NSString *membersTeamId;
@property (nonatomic, retain) UIButton *addMembersButton;
@property bool spotOpen;
@property bool oneTeam;
@property (nonatomic, retain) UIActionSheet *undoCancel;
@property (nonatomic, retain) NSString *undoTeamId;
@property (nonatomic, retain) NSString *undoEventId;
@property (nonatomic, retain) NSString *undoEventType;

@property bool foundQuick1;
@property bool foundQuick2;
@property (nonatomic, retain) UIButton *changeIconButton;
@property bool newActivity;
@property (nonatomic, retain) UIImageView *newActivityBadge;
@property bool isEditingQuickLinkOne;
@property (nonatomic, retain) UIScrollView *displayIconsScroll;
@property (nonatomic, retain) UILabel *messageCountLabel;
@property (nonatomic, retain) UIButton *fastButton;
@property (nonatomic, retain) UIButton *myTeamsButton;
@property (nonatomic, retain) UIButton *activityButton;
@property (nonatomic, retain) UIButton *messagesButton;

@property BOOL bannerIsVisible;
@property (nonatomic, retain) UIButton *eventsButton;
//Bottom Half quick links
@property bool eventsNowTryAgain;
@property (nonatomic, retain) UITextView *eventsNowError;
@property bool eventsNowSuccess;
@property (nonatomic, retain) NSMutableArray *eventsToday;
@property (nonatomic, retain) NSMutableArray *eventsTomorrow;
@property int numberOfPages;
@property (nonatomic, retain) UIActivityIndicatorView *eventsNowActivity;
@property (nonatomic, retain) NSMutableArray *allBottomButtons;

//New Messages badge
@property (nonatomic, retain) UIImageView *messageBadge;
@property int newMessagesCount;
@property bool newMessagesSuccess;
//Quick Link Edit View
@property (nonatomic, retain) UIScrollView *changeQuickLink;
@property (nonatomic, retain) UITableView *newQuickLinkTable;
@property (nonatomic, retain) UITextField *newQuickLinkAlias;
@property int rowNewQuickTeam;
@property (nonatomic, retain) UIActivityIndicatorView *activityGettingTeams;
@property (nonatomic, retain) UILabel *selectRowLabel;
//Background thread "Get Teams"
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, retain) NSArray *teamList;

//Quick Link Buttons
@property (nonatomic, retain) UIButton *quickCreateTeam;
@property (nonatomic, retain) QuickLinkButton *quickTeamOne;
@property (nonatomic, retain) QuickLinkButton *quickTeamTwo;

@property bool alreadyCalled1;
@property bool alreadyCalled2;
@property bool alreadyCalledCreate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (nonatomic, retain) UIBarButtonItem *inviteFan;


@property (nonatomic, retain) NSString *didRegister;
@property int numMemberTeams;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *oneTeamFlag;


@property (nonatomic, retain) NSArray *games;
@property (nonatomic, retain) NSArray *practices;



@property (nonatomic, retain) NSString *eventToday;
@property int eventTodayIndex;
@property int nextGameIndex;
@property int nextPracticeIndex;

@property (nonatomic, retain) UIToolbar *bottomBar;

@property int badgeNumber;
@property (nonatomic, retain) UILabel *serverError;


-(IBAction) allEvents;
-(IBAction) myTeams;
-(IBAction) messages;
-(IBAction) newsFeed;
-(IBAction) fast;

- (void)loadScrollViewWithPage:(int)page;
- (IBAction)changePage:(id)sender;

-(IBAction)okNewQuickLink;
-(IBAction)cancelNewQuickLink;

-(IBAction)endText;

-(void)addQuickLinks;

-(void)setUpScrollView;

-(void)setBottomArray;

-(void)closeQuestion;

-(NSString *)getQuickLinkImageOne;

-(IBAction)newIconSelected:(id)sender;
-(IBAction)cancelNewIcons;
-(IBAction)changeQuickLinkIcon;

-(int)getIconHeight:(NSString *)sport;

-(IBAction)moveDivider;

-(IBAction)regText;

@end
