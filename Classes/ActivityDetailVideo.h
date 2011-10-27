//
//  ActivityDetailVideo.h
//  rTeam
//
//  Created by Nick Wroblewski on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ActivityDetailVideo : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	
	NSString *stringText;
	NSString *dateText;
	NSString *teamText;
	NSString *basePath;
	
	IBOutlet UILabel *dateLabel;
	IBOutlet UITextView *textLabel;
	IBOutlet UILabel *teamLabel;
	
	IBOutlet UIImageView *displayImage;
	
	NSString *currentVote;  //"like", "dislike", "none"
	
	float numStars;
	bool isImage;
	
	IBOutlet UILabel *loadingImageLabel;
	IBOutlet UIActivityIndicatorView *loadingImageActivity;
	
	IBOutlet UIImageView *starOne;
	IBOutlet UIImageView *starTwo;
	IBOutlet UIImageView *starThree;
	
	IBOutlet UIButton *thumbsUp;
	IBOutlet UIButton *thumbsDown;
	
	IBOutlet UILabel *voteLabel;
	
	NSString *activityId;
	NSString *teamId;
	NSString *encodedPhoto;
	NSString *errorString;
	IBOutlet UILabel *errorLabel;
	
	BOOL currentVoteBool;
	
	bool voteSuccess;
	
	IBOutlet UIView *imageBackground;
	
	int likes;
	int dislikes;
	IBOutlet UILabel *likesLabel;
	IBOutlet UILabel *dislikesLabel;
	
	
	IBOutlet UILabel *displayLabel;
	
	UIActionSheet *shareAction;
	
	IBOutlet UIButton *playMovieButton;
	
	NSString *movieString;
	NSData *movieData;
	
	IBOutlet UIImageView *playButtonImage;
}
@property (nonatomic, strong) UIImageView *playButtonImage;
@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSData *movieData;
@property (nonatomic, strong) NSString *movieString;
@property (nonatomic, strong) UIButton *playMovieButton;
@property (nonatomic, strong) UIActionSheet *shareAction;
@property (nonatomic, strong) UILabel *displayLabel;
@property int likes;
@property int dislikes;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) UILabel *dislikesLabel;

@property (nonatomic, strong) UIView *imageBackground;

@property bool voteSuccess;
@property BOOL currentVoteBool;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *encodedPhoto;
@property (nonatomic, strong) UILabel *voteLabel;
@property (nonatomic, strong) UIImageView *starOne;
@property (nonatomic, strong) UIImageView *starTwo;
@property (nonatomic, strong) UIImageView *starThree;

@property (nonatomic, strong) UIButton *thumbsUp;
@property (nonatomic, strong) UIButton *thumbsDown;

@property (nonatomic, strong) UILabel *loadingImageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingImageActivity;

@property (nonatomic, strong) NSString *stringText;
@property (nonatomic, strong) NSString *dateText;
@property (nonatomic, strong) NSString *teamText;

@property bool isImage;

@property (nonatomic, strong)  UILabel *dateLabel;
@property (nonatomic, strong)  UITextView *textLabel;
@property (nonatomic, strong)  UILabel *teamLabel;

@property (nonatomic, strong)  UIImageView *displayImage;

@property (nonatomic, strong) NSString *currentVote;  //"like", "dislike", "none"

@property float numStars;

-(float)getNumberOfStars:(int)likes :(int)dislikes;
-(IBAction)voteDown;
-(IBAction)voteUp;

-(void)savePhoto;
-(void)emailPhoto;
-(IBAction)playMovie;

@end

