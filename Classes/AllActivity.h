//
//  AllActivity.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface AllActivity : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, 
ADBannerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	NSString *userRole;
	bool useTwitter;
	bool haveTweets;
	bool tweetsSuccess;
	bool postSuccess;
	bool newTweetsSuccess;
	bool loadMore;
	int minCacheId;
	bool canLoadMore;
	UIActivityIndicatorView *loadMoreActivity;
	bool loadMoreSuccess;
	NSMutableArray *tweetsArray;
	NSMutableArray *tmpTweetsArray;
	
	IBOutlet UIView *switchTeamsView;
	IBOutlet UITableView *switchTeamsTable;
	NSMutableArray *teamIdsTwitterConnect;
	NSMutableArray *teamsCoord;

	NSString *currentPostTeamId;
	NSMutableArray *twitterTeams;
	
	NSString *twitterUrl;
	bool twitterUser;
	
	//Sub Views
	IBOutlet UIView *loading;
	IBOutlet UIView *noTwitterCoord;
	IBOutlet UIView *noTwitterNoCoord;
	IBOutlet UIView *twitter;
	
	//Loading View
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	//noTwitterCoord
	IBOutlet UITableView *connectTwitterTable;
	IBOutlet UIButton *signUpTwitterButton;
	IBOutlet UIActivityIndicatorView *connectTwitterActivity;
	
	//twitter
	IBOutlet UIButton *postTwitterButton;
	IBOutlet UITextField *tweet;
	IBOutlet UITableView *tweetsTable;
	IBOutlet UILabel *numCharsTweet;
	IBOutlet UIActivityIndicatorView *postActivity;
	IBOutlet UILabel *postError;
	IBOutlet UILabel *teamLabel;
	IBOutlet UIButton *changeTeamButton;
	
	ADBannerView *myAd;
	
	BOOL bannerIsVisible;
	
	NSString *errorString;
	IBOutlet UILabel *errorMessage;
	NSString *teamLabelString;
	
	BOOL currentVote;
	
	bool isUpdating;
	UIActivityIndicatorView *updatingActivity;
	
	IBOutlet UILabel *postTeamLabel;
	IBOutlet UIView *dividerView;
	
	bool isEditingTweet;
	
	IBOutlet UIButton *tweetCameraButton;
	IBOutlet UIImageView *tweetCameraImage;
	
	
	UIActionSheet *cameraAction;
	
	UIImage *activityImage;
	
	bool fromCamera;
	
	NSData *imageData;
	
	bool fromCameraSelect;
	
	NSData *selectedImageData;
	UIImage *selectedImage;
	
	IBOutlet UIButton *removePictureButton;
    IBOutlet UIView *switchTeamsBackground;
	
	NSData *movieData;
	
	bool hasNewTweets;
	bool newTweetsFailed;
    bool portrait;
    
    NSMutableArray *allTeams;
    
    IBOutlet UIImageView *twitterLabel;
    IBOutlet UIImageView *postImage;
    IBOutlet UIView *noTeamsView;
    
    bool isVisible;
}
@property bool isVisible;
@property (nonatomic, retain) UIView *noTeamsView;
@property (nonatomic, retain) UIImageView *twitterLabel;
@property (nonatomic, retain) UIImageView *postImage;
@property (nonatomic, retain) NSMutableArray *allTeams;
@property bool portrait;
@property (nonatomic, retain) UIView *switchTeamsBackground;

@property bool hasNewTweets;
@property bool newTweetsFailed;
@property (nonatomic, retain) NSData *movieData;
@property (nonatomic, retain) UIButton *removePictureButton;
@property (nonatomic, retain) NSData *selectedImageData;
@property (nonatomic, retain) UIImage *selectedImage;
@property bool fromCameraSelect;
@property (nonatomic, retain) NSData *imageData;
@property bool fromCamera;
@property (nonatomic, retain) UIImage *activityImage;
@property (nonatomic, retain) UIActionSheet *cameraAction;
@property (nonatomic, retain) UIButton *tweetCameraButton;
@property (nonatomic, retain) UIImageView *tweetCameraImage;
@property bool isEditingTweet;
@property (nonatomic, retain) UILabel *postTeamLabel;
@property (nonatomic, retain) UIView *dividerView;
@property (nonatomic, retain) UIActivityIndicatorView *updatingActivity;
@property bool isUpdating;
@property BOOL currentVote;
@property (nonatomic, retain) NSString *teamLabelString;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UILabel *errorMessage;
@property BOOL bannerIsVisible;
@property (nonatomic, retain) UITableView *switchTeamsTable;
@property (nonatomic, retain) UIView *switchTeamsView;
@property (nonatomic, retain) NSMutableArray *twitterTeams;
@property (nonatomic, retain) NSString *currentPostTeamId;
@property (nonatomic, retain) UILabel *teamLabel;
@property (nonatomic, retain) NSMutableArray *teamsCoord;
@property (nonatomic, retain) 	NSMutableArray *teamIdsTwitterConnect;

@property (nonatomic, retain) NSString *twitterUrl;
@property bool twitterUser;
@property (nonatomic, retain) UIActivityIndicatorView *loadMoreActivity;

@property bool loadMoreSuccess;

@property int minCacheId;
@property bool canLoadMore;
@property bool loadMore;
@property bool newTweetsSuccess;
@property bool postSuccess;
@property bool tweetsSuccess;

@property bool haveTweets;
@property (nonatomic, retain) NSMutableArray *tweetsArray;
@property (nonatomic, retain) NSMutableArray *tmpTweetsArray;

@property bool useTwitter;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) UIView *loading;
@property (nonatomic, retain) UIView *noTwitterCoord;
@property (nonatomic, retain) UIView *noTwitterNoCoord;
@property (nonatomic, retain) UIView *twitter;

//Loading View
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;

//noTwitterCoord
@property (nonatomic, retain) UITableView *connectTwitterTable;
@property (nonatomic, retain) UIButton *signUpTwitterButton;
@property (nonatomic, retain) UIActivityIndicatorView *connectTwitterActivity;

//twitter
@property (nonatomic, retain) UIButton *postTwitterButton;
@property (nonatomic, retain) UITextField *tweet;
@property (nonatomic, retain) UITableView *tweetsTable;
@property (nonatomic, retain) UILabel *numCharsTweet;
@property (nonatomic, retain) UIActivityIndicatorView *postActivity;
@property (nonatomic, retain) UILabel *postError;
@property (nonatomic, retain) UIButton *changeTeamButton;

-(IBAction)changeTeam;

-(void)connectTwitter:(id)sender;
-(IBAction)signUpTwitter;
-(IBAction)postTwitter;
-(IBAction)endText;
-(NSString *)formatDateString:(NSString *)dateSent;
-(IBAction)textChanging;
-(IBAction)cancelPostTeam;
-(float)getNumberOfStars:(int)likes :(int)dislikes;

-(IBAction)editingStarted;
-(IBAction)editingEnded;

-(IBAction)tweetCamera;

-(void)getImageCamera;
-(void)getImageVideo;

-(IBAction)removePicture;
-(void)getImageLibrary;
@end
