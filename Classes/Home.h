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
	    
	int nextGameIndex;
	int nextPracticeIndex;
	int badgeNumber;
	
	UIBarButtonItem *inviteFan;

    
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
@property (nonatomic, strong) UIImageView *blueArrow;
@property (nonatomic, strong) UIButton *quickLinkCancelTwoButton;

@property (nonatomic, strong) UIButton *quickLinkChangeButton;
@property (nonatomic, strong) UIButton *quickLinkCancelButton;
@property (nonatomic, strong) UIButton *quickLinkOkButton;
@property (nonatomic, strong) QuickLinkButton *shortcutButton;
@property double numObjects;
@property (nonatomic, strong) UIButton *aboutButton;
@property int currentDisplay;
@property (nonatomic, strong) UIView *registrationBackView;
@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UIView *textFrontView;
@property (nonatomic, strong) UITextView *regTextView;
@property (nonatomic, strong) UIButton *regTextButton;

@property (nonatomic, strong) IBOutlet UIImageView *scrollViewBack;
@property (nonatomic, strong) UIView *moveableView;
@property BOOL isMoreShowing; 
@property (nonatomic, strong) UIView *moveDividerBackground;
@property (nonatomic, strong) UILabel *homeDividerLabel;
@property (nonatomic, strong) UIButton *moveDividerButton;
@property (nonatomic, strong) UIImageView *homeDivider;
@property (nonatomic, strong) UITextView *helpExplanation;
@property (nonatomic, strong) UIButton *closeQuestionButton;

@property (nonatomic, strong) UIView *backViewTop;
@property (nonatomic, strong) UIView *backViewBottom;

@property (nonatomic, strong) UIView *transViewTop;
@property (nonatomic, strong) UIView *transViewBottom;

@property (nonatomic, strong) UIButton *settingQbutton;
@property (nonatomic, strong) UIButton *searchQbutton;
@property (nonatomic, strong) UIButton *myTeamsQbutton;

@property (nonatomic, strong) UIButton *activityQbutton;
@property (nonatomic, strong) UIButton *messagesQbutton;
@property (nonatomic, strong) UIButton *eventsQbutton;
@property (nonatomic, strong) UIButton *quickLinksQbutton;
@property (nonatomic, strong) UIButton *happeningNowQbutton;
@property (nonatomic, strong) UIButton *helpQbutton;
@property (nonatomic, strong) UIButton *inviteFanQbutton;
@property (nonatomic, strong) UIButton *refreshQbutton;

@property (nonatomic, strong) UIView *backHelpView;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *questionButton;
@property bool changingLink;
@property (nonatomic, strong) UIView *displayIconsScrollBack;
@property (nonatomic, strong) UIView *changeQuickLinkBack;
@property (nonatomic, strong) NSString *justAddName;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;

@property (nonatomic, strong) NSString *membersUserRole;
@property (nonatomic, strong) NSString *membersTeamId;
@property (nonatomic, strong) UIButton *addMembersButton;
@property bool spotOpen;
@property bool oneTeam;
@property (nonatomic, strong) UIActionSheet *undoCancel;
@property (nonatomic, strong) NSString *undoTeamId;
@property (nonatomic, strong) NSString *undoEventId;
@property (nonatomic, strong) NSString *undoEventType;

@property bool foundQuick1;
@property bool foundQuick2;
@property (nonatomic, strong) UIButton *changeIconButton;
@property bool newActivity;
@property (nonatomic, strong, getter = theNewActivityBadge) UIImageView *newActivityBadge;
@property bool isEditingQuickLinkOne;
@property (nonatomic, strong) UIScrollView *displayIconsScroll;
@property (nonatomic, strong) UILabel *messageCountLabel;
@property (nonatomic, strong) UIButton *fastButton;
@property (nonatomic, strong) UIButton *myTeamsButton;
@property (nonatomic, strong) UIButton *activityButton;
@property (nonatomic, strong) UIButton *messagesButton;

@property BOOL bannerIsVisible;
@property (nonatomic, strong) UIButton *eventsButton;
//Bottom Half quick links
@property bool eventsNowTryAgain;
@property (nonatomic, strong) UITextView *eventsNowError;
@property bool eventsNowSuccess;
@property (nonatomic, strong) NSMutableArray *eventsToday;
@property (nonatomic, strong) NSMutableArray *eventsTomorrow;
@property int numberOfPages;
@property (nonatomic, strong) UIActivityIndicatorView *eventsNowActivity;
@property (nonatomic, strong) NSMutableArray *allBottomButtons;

//New Messages badge
@property (nonatomic, strong) UIImageView *messageBadge;
@property int newMessagesCount;
@property bool newMessagesSuccess;
//Quick Link Edit View
@property (nonatomic, strong) UIScrollView *changeQuickLink;
@property (nonatomic, strong, getter = theNewQuickLinkTable) UITableView *newQuickLinkTable;
@property (nonatomic, strong, getter = theNewQuickLinkAlias) UITextField *newQuickLinkAlias;
@property int rowNewQuickTeam;
@property (nonatomic, strong) UIActivityIndicatorView *activityGettingTeams;
@property (nonatomic, strong) UILabel *selectRowLabel;
//Background thread "Get Teams"
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, strong) NSArray *teamList;

//Quick Link Buttons
@property (nonatomic, strong) UIButton *quickCreateTeam;
@property (nonatomic, strong) QuickLinkButton *quickTeamOne;
@property (nonatomic, strong) QuickLinkButton *quickTeamTwo;

@property bool alreadyCalled1;
@property bool alreadyCalled2;
@property bool alreadyCalledCreate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, strong) UIBarButtonItem *inviteFan;


@property (nonatomic, strong) NSString *didRegister;
@property int numMemberTeams;
@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *oneTeamFlag;


@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSArray *practices;



@property (nonatomic, strong) NSString *eventToday;
@property int eventTodayIndex;
@property int nextGameIndex;
@property int nextPracticeIndex;

@property (nonatomic, strong) IBOutlet UIToolbar *bottomBar;

@property int badgeNumber;
@property (nonatomic, strong) UILabel *serverError;


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
