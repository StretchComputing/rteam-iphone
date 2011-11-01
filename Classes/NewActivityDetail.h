//
//  NewActivityDetail.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewActivityDetail : UIViewController


@property (nonatomic, strong) IBOutlet UILabel *voteLabel;
@property (nonatomic, strong) NSString *currentVote;
@property bool voteSuccess;
@property BOOL currentVoteBool;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;
@property (nonatomic, strong) IBOutlet UILabel *dislikesLabel;
@property (nonatomic, strong) IBOutlet UIButton *thumbsUp;
@property (nonatomic, strong) IBOutlet UIButton *thumbsDown;

@property int numLikes;
@property int numDislikes;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UILabel *locationTextLabel;
@property (nonatomic, strong) NSString *locationText;

@property (nonatomic, strong) UIImageView *profileImage;

@property (nonatomic, strong) NSString *profile;
@property (nonatomic, strong) NSData *postImageData;
@property (nonatomic, strong) NSData *picImageData; //data of image of poster (if exists)

@property (nonatomic, strong) NSMutableArray *postImageArray;

@property (nonatomic, strong) UIView *commentBackground;
@property bool likesMessage;
@property (nonatomic, strong) UIBarButtonItem *likeButton;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *displayTime;
@property bool isCurrent;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, strong) NSArray *replies; //array of LiveMessage objects
@property (nonatomic, strong) NSString *displayMessage;  

@property (nonatomic, strong) IBOutlet UIImageView *starOne;
@property (nonatomic, strong) IBOutlet UIImageView *starTwo;
@property (nonatomic, strong) IBOutlet UIImageView *starThree;


-(void)loadScrollView;
-(void)initializeView;
-(int)findHeightForString:(NSString *)message withWidth:(int)width;
-(int)findHeightForStringBigger:(NSString *)message withWidth:(int)width;

-(IBAction)voteUp;
-(IBAction)voteDown;

@end
