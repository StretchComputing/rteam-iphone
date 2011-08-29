//
//  TeamActivity.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface TeamActivity : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ADBannerViewDelegate,
UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

	NSString *teamId;
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
	
	NSMutableArray *teamIdsTwitterConnect;
	
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
	IBOutlet UIButton *connectTwitterButton;
	IBOutlet UIButton *signUpTwitterButton;
	IBOutlet UIActivityIndicatorView *connectTwitterActivity;
	IBOutlet UILabel *errorMessage;
	
	//twitter
	IBOutlet UIButton *postTwitterButton;
	IBOutlet UITextField *tweet;
	IBOutlet UITableView *tweetsTable;
	IBOutlet UILabel *numCharsTweet;
	IBOutlet UIActivityIndicatorView *postActivity;
	IBOutlet UILabel *postError;
	
	
	ADBannerView *myAd;
	
	BOOL bannerIsVisible;

	NSString *errorString;

	bool isUpdating;
	UIActivityIndicatorView *updatingActivity;
	
	BOOL currentVote;
	
	IBOutlet UIView *dividerView;
	
	bool isEditingTweet;
	
	IBOutlet UIButton *tweetCameraButton;
	IBOutlet UIImageView *tweetCameraImage;
	
	
	UIActionSheet *cameraAction;
	
	UIImage *activityImage;
	
	bool fromCamera;
	
	NSData *imageData;
	
	bool justFinishedImage;
	
	
	bool fromCameraSelect;
	
	NSData *selectedImageData;
	UIImage *selectedImage;
	
	IBOutlet UIButton *removePictureButton;
	
	NSData *movieData;
    
    bool portrait;
    
    IBOutlet UIImageView *twitterLabel;
    
    bool showNaAlert;
}
@property bool showNaAlert;
@property (nonatomic, retain) UIImageView *twitterLabel;
@property bool portrait;
@property (nonatomic, retain) NSData *movieData;
@property (nonatomic, retain) UIButton *removePictureButton;
@property (nonatomic, retain) NSData *selectedImageData;
@property (nonatomic, retain) UIImage *selectedImage;
@property bool fromCameraSelect;


@property bool justFinishedImage;
@property (nonatomic, retain) UIView *dividerView;

@property bool isEditingTweet;

@property (nonatomic, retain) UIButton *tweetCameraButton;
@property (nonatomic, retain) UIImageView *tweetCameraImage;


@property (nonatomic, retain) UIActionSheet *cameraAction;

@property (nonatomic, retain) UIImage *activityImage;

@property bool fromCamera;

@property (nonatomic, retain) NSData *imageData;

@property BOOL currentVote;
@property (nonatomic, retain) UIActivityIndicatorView *updatingActivity;
@property bool isUpdating;


@property (nonatomic, retain) UILabel *errorMessage;
@property (nonatomic, retain) NSString *errorString;
@property BOOL bannerIsVisible;
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
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) UIView *loading;
@property (nonatomic, retain) UIView *noTwitterCoord;
@property (nonatomic, retain) UIView *noTwitterNoCoord;
@property (nonatomic, retain) UIView *twitter;

//Loading View
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;

//noTwitterCoord
@property (nonatomic, retain) UIButton *connectTwitterButton;
@property (nonatomic, retain) UIButton *signUpTwitterButton;
@property (nonatomic, retain) UIActivityIndicatorView *connectTwitterActivity;

//twitter
@property (nonatomic, retain) UIButton *postTwitterButton;
@property (nonatomic, retain) UITextField *tweet;
@property (nonatomic, retain) UITableView *tweetsTable;
@property (nonatomic, retain) UILabel *numCharsTweet;
@property (nonatomic, retain) UIActivityIndicatorView *postActivity;
@property (nonatomic, retain) UILabel *postError;

-(IBAction)tweetChanged;
-(IBAction)connectTwitter;
-(IBAction)signUpTwitter;
-(IBAction)postTwitter;
-(IBAction)endText;
-(NSString *)formatDateString:(NSString *)dateSent;
-(float)getNumberOfStars:(int)likes :(int)dislikes;

-(IBAction)editingStarted;
-(IBAction)editingEnded;

-(IBAction)tweetCamera;

-(void)getImageCamera;
-(void)getImageVideo;

-(IBAction)removePicture;
-(void)getImageLibrary;

@end
