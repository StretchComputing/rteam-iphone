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

@class HomeScoreView;
@class HomeAttendanceView;

@interface Home : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, ADBannerViewDelegate,
UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>{



    
}
//Post Image
@property (nonatomic, strong) IBOutlet UIView *postImageBackView;
@property (nonatomic, strong) IBOutlet UIView *postImageFrontView;
@property (nonatomic, strong) IBOutlet UIImageView *postImagePreview;
@property (nonatomic, strong) IBOutlet UITextField *postImageTextView;
@property (nonatomic, strong) IBOutlet UITableView *postImageTableView;
@property (nonatomic, strong) IBOutlet UIButton *postImageSubmitButton;
@property (nonatomic, strong) IBOutlet UIButton *postImageCancelButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *postImageActivity;
@property (nonatomic, strong) IBOutlet UILabel *postImageErrorLabel;
@property (nonatomic, strong) IBOutlet UILabel *postImageLabel;
@property (nonatomic, strong) NSString *activityPhotoTeamId;
@property (nonatomic, strong) NSString *postImageTeamId;
@property (nonatomic, strong) NSString *postImageText;
@property (nonatomic, strong) IBOutlet UISegmentedControl *postImageCreateGameSegment;
@property (nonatomic, strong) UIAlertView *postImageAlert;
@property bool postImageIsCoord;
@property (nonatomic, strong) NSMutableArray *postImageEvents;

@property bool isGameVisible;

@property (nonatomic, strong) NSData *imageDataToSend;
@property (nonatomic, strong) NSString *sendOrientation;
@property (nonatomic, strong) IBOutlet UIButton *showLessButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) HomeScoreView *homeScoreView;
@property (nonatomic, strong) HomeAttendanceView *homeAttendanceView;
@property (nonatomic, strong) IBOutlet UIView *happeningNowView;
@property (nonatomic, strong) IBOutlet UIToolbar *bottomBar;


@property (nonatomic, strong) NSString *errorString;
@property bool createdTeam;
@property (nonatomic, strong) ADBannerView *myAd;
@property (nonatomic, strong) IBOutlet UIImageView *blueArrow;
@property (nonatomic, strong) IBOutlet UIButton *quickLinkCancelTwoButton;
@property BOOL pageControlUsed;
@property (nonatomic, strong) IBOutlet UIButton *quickLinkChangeButton;
@property (nonatomic, strong) IBOutlet UIButton *quickLinkCancelButton;
@property (nonatomic, strong) IBOutlet UIButton *quickLinkOkButton;
@property (nonatomic, strong) IBOutlet QuickLinkButton *shortcutButton;
@property double numObjects;
@property (nonatomic, strong) UIButton *aboutButton;
@property int currentDisplay;
@property (nonatomic, strong) IBOutlet UIView *registrationBackView;
@property (nonatomic, strong) IBOutlet UIView *textBackView;
@property (nonatomic, strong) IBOutlet UIView *textFrontView;
@property (nonatomic, strong) IBOutlet UITextView *regTextView;
@property (nonatomic, strong) IBOutlet UIButton *regTextButton;

@property BOOL isMoreShowing; 

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

@property (nonatomic, strong) IBOutlet UIView *backHelpView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *questionButton;
@property bool changingLink;
@property (nonatomic, strong) IBOutlet UIView *displayIconsScrollBack;
@property (nonatomic, strong) IBOutlet UIView *changeQuickLinkBack;
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
@property (nonatomic, strong) IBOutlet UIButton *changeIconButton;
@property bool newActivity;
@property bool isEditingQuickLinkOne;
@property (nonatomic, strong) IBOutlet UIScrollView *displayIconsScroll;
@property (nonatomic, strong) IBOutlet UIButton *myTeamsButton;
@property (nonatomic, strong) IBOutlet UIButton *messagesButton;

@property BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet UIButton *eventsButton;
//Bottom Half quick links
@property bool eventsNowTryAgain;
@property bool eventsNowSuccess;
@property (nonatomic, strong) NSMutableArray *eventsToday;
@property (nonatomic, strong) NSMutableArray *eventsTomorrow;
@property int numberOfPages;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *eventsNowActivity;
@property (nonatomic, strong) NSMutableArray *allBottomButtons;

//New Messages badge
@property (nonatomic, strong) IBOutlet UIImageView *messageBadge;
@property int newMessagesCount;
@property bool newMessagesSuccess;
//Quick Link Edit View
@property (nonatomic, strong) IBOutlet UIScrollView *changeQuickLink;
@property (nonatomic, strong, getter = theNewQuickLinkTable) IBOutlet UITableView *newQuickLinkTable;
@property (nonatomic, strong, getter = theNewQuickLinkAlias) IBOutlet UITextField *newQuickLinkAlias;
@property int rowNewQuickTeam;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityGettingTeams;
@property (nonatomic, strong) IBOutlet UILabel *selectRowLabel;
//Background thread "Get Teams"
@property bool teamListFailed;
@property bool haveTeamList;
@property (nonatomic, strong) NSArray *teamList;
@property (nonatomic, strong) NSString *activityPhotoEventId;




@property bool alreadyCalled1;
@property bool alreadyCalled2;
@property bool alreadyCalledCreate;

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


@property int badgeNumber;
@property (nonatomic, strong) IBOutlet UILabel *serverError;
@property (nonatomic, strong) UIBarButtonItem *gamedayButton;
@property (nonatomic, strong) UIActionSheet *gamedayAction;

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

-(void)displayCamera;
-(NSString *)getQuickLinkImageOne;

-(IBAction)newIconSelected:(id)sender;
-(IBAction)cancelNewIcons;
-(IBAction)changeQuickLinkIcon;

-(int)getIconHeight:(NSString *)sport;

-(IBAction)moveDivider;

-(IBAction)regText;

-(IBAction)showLessAction;

-(IBAction)postImageSubmit;
-(IBAction)postImageCancel;

-(IBAction)questionsComments;


@end
