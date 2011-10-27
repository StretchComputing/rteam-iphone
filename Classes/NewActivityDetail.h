//
//  NewActivityDetail.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewActivityDetail : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *voteLabel;
@property (nonatomic, retain) NSString *currentVote;
@property bool voteSuccess;
@property BOOL currentVoteBool;
@property (nonatomic, retain) IBOutlet UILabel *likesLabel;
@property (nonatomic, retain) IBOutlet UILabel *dislikesLabel;
@property (nonatomic, retain) IBOutlet UIButton *thumbsUp;
@property (nonatomic, retain) IBOutlet UIButton *thumbsDown;

@property int numLikes;
@property int numDislikes;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UILabel *locationTextLabel;
@property (nonatomic, retain) NSString *locationText;

@property (nonatomic, retain) UIImageView *profileImage;

@property (nonatomic, retain) NSString *profile;
@property (nonatomic, retain) NSData *postImageData;
@property (nonatomic, retain) NSData *picImageData; //data of image of poster (if exists)

@property (nonatomic, retain) NSMutableArray *postImageArray;

@property (nonatomic, retain) UIView *commentBackground;
@property bool likesMessage;
@property (nonatomic, retain) UIBarButtonItem *likeButton;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, retain) NSString *displayTime;
@property bool isCurrent;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, retain) NSArray *replies; //array of LiveMessage objects
@property (nonatomic, retain) NSString *displayMessage;  

@property (nonatomic, retain) IBOutlet UIImageView *starOne;
@property (nonatomic, retain) IBOutlet UIImageView *starTwo;
@property (nonatomic, retain) IBOutlet UIImageView *starThree;


-(void)loadScrollView;
-(void)initializeView;
-(int)findHeightForString:(NSString *)message withWidth:(int)width;
-(int)findHeightForStringBigger:(NSString *)message withWidth:(int)width;

-(IBAction)voteUp;
-(IBAction)voteDown;

@end
