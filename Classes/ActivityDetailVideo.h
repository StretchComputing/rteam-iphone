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
@property (nonatomic, retain) UIImageView *playButtonImage;
@property (nonatomic, retain) NSString *basePath;
@property (nonatomic, retain) NSData *movieData;
@property (nonatomic, retain) NSString *movieString;
@property (nonatomic, retain) UIButton *playMovieButton;
@property (nonatomic, retain) UIActionSheet *shareAction;
@property (nonatomic, retain) UILabel *displayLabel;
@property int likes;
@property int dislikes;
@property (nonatomic, retain) UILabel *likesLabel;
@property (nonatomic, retain) UILabel *dislikesLabel;

@property (nonatomic, retain) UIView *imageBackground;

@property bool voteSuccess;
@property BOOL currentVoteBool;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UILabel *errorLabel;

@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *encodedPhoto;
@property (nonatomic, retain) UILabel *voteLabel;
@property (nonatomic, retain) UIImageView *starOne;
@property (nonatomic, retain) UIImageView *starTwo;
@property (nonatomic, retain) UIImageView *starThree;

@property (nonatomic, retain) UIButton *thumbsUp;
@property (nonatomic, retain) UIButton *thumbsDown;

@property (nonatomic, retain) UILabel *loadingImageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingImageActivity;

@property (nonatomic, retain) NSString *stringText;
@property (nonatomic, retain) NSString *dateText;
@property (nonatomic, retain) NSString *teamText;

@property bool isImage;

@property (nonatomic, retain)  UILabel *dateLabel;
@property (nonatomic, retain)  UITextView *textLabel;
@property (nonatomic, retain)  UILabel *teamLabel;

@property (nonatomic, retain)  UIImageView *displayImage;

@property (nonatomic, retain) NSString *currentVote;  //"like", "dislike", "none"

@property float numStars;

-(float)getNumberOfStars:(int)likes :(int)dislikes;
-(IBAction)voteDown;
-(IBAction)voteUp;

-(void)savePhoto;
-(void)emailPhoto;
-(IBAction)playMovie;

@end

