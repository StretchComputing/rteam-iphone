//
//  NewActivityDetail.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewActivityDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageButton.h"
#import "ImageDisplayMultiple.h"
#import "TableDisplayUtil.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "VideoDisplay.h"
#import "GANTracker.h"
#import "ReplyEditActivity.h"
#import "Activity.h"
#import "Base64.h"
#import "ReplyButtonBackView.h"
#import "ScoreButton.h"

@implementation NewActivityDetail
@synthesize likeButton,likesMessage, locationText, locationTextLabel, profile, picImageData, profileImage, commentBackground, activity, displayName, displayTime, displayMessage, replies, messageId, myToolbar, myScrollView, postImageArray, postImageData, teamId, starOne, starTwo, starThree, numLikes, numDislikes, thumbsUp, thumbsDown, likesLabel, dislikesLabel, currentVoteBool, voteSuccess, currentVote, voteLabel, isVideo, replyButton, editButton, deleteButton, errorLabel, isCurrentUser, fromReplyEdit, teamName;


-(void)viewWillAppear:(BOOL)animated{
        
    if ([self.fromReplyEdit isEqualToString:@"true"]) {
        self.fromReplyEdit = @"false";
        [self performSelectorInBackground:@selector(getActivityDetails) withObject:nil];
    }
    
    if ([self.currentVote isEqualToString:@"like"]) {
		
		[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUpGreen.png"] forState:UIControlStateNormal];
		[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
		self.voteLabel.text = @"You voted 'Like'!";
		
	}else if ([self.currentVote isEqualToString:@"dislike"]) {
		
		[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
		[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDownGreen.png"] forState:UIControlStateNormal];
		self.voteLabel.text = @"You voted 'Dislike'!";
        
	}else {
		
		[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
		[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
		self.voteLabel.text = @"You have not voted on this post.";
        
		
	}
    
    [self initializeView];
    
  


}
- (void)viewDidLoad{
    
    self.fromReplyEdit = @"false";
    
    self.locationText = @"";
    
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.numLikes];
    self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.numDislikes];

   // self.likeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsUp.png"] style:UIBarButtonItemStylePlain target:self action://@selector(like)];
    
        
       
    [super viewDidLoad];
}

-(void)initializeView{
    
    self.likesMessage = false;
    //[self performSelectorInBackground:@selector(doesLike) withObject:nil];
    
    self.title = self.displayName;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    if (self.isCurrentUser) {
        self.myToolbar.items = [NSArray arrayWithObjects:self.replyButton, flexibleSpace, self.editButton, flexibleSpace, self.deleteButton, nil];

    }else{
        self.myToolbar.items = [NSArray arrayWithObjects:self.replyButton, flexibleSpace, nil];
    }
    
    [self loadScrollView];

}
-(void)loadScrollView{
    
    
    for (UIView *view in [self.myScrollView subviews]) {
        [view removeFromSuperview];
    } 
    
    int timeY = 8;
    if (![self.locationText isEqualToString:@""]) {
        
        //Display Location
        self.locationTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 17)];
        self.locationTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.locationTextLabel.text = [NSString stringWithFormat:@"Last Login: %@", self.locationText];
        self.locationTextLabel.textColor = [UIColor blueColor];
        self.locationTextLabel.backgroundColor = [UIColor clearColor];
        self.locationTextLabel.textAlignment = UITextAlignmentCenter;
        timeY = 28;
        [self.myScrollView addSubview:self.locationTextLabel];
        
    }
    
    //Profile pic
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, timeY - 3, 60, 60)];
    if ([self.picImageData length] > 0) {
        self.profileImage.image = [UIImage imageWithData:self.picImageData];
    }else{
        self.profileImage.image = [UIImage imageNamed:@"profileNew.png"];
    }
    [self.myScrollView addSubview:self.profileImage];
    
    //ProfileButton
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame = profileImage.frame;
    //[profileButton addTarget:self action:@selector(goUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:profileButton];
    
    //Display Time
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, timeY, 255, 17)];
    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    timeLabel.text = self.displayTime;
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = UITextAlignmentCenter;
    [self.myScrollView addSubview:timeLabel];
    
    //TeamNae
    UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, timeY + 20, 255, 17)];
    teamLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    teamLabel.text = self.teamName;
    teamLabel.textColor = [UIColor blueColor];
    teamLabel.textAlignment = UITextAlignmentCenter;
    [self.myScrollView addSubview:teamLabel];
    
    //Display Message   
    int height = [self findHeightForStringBigger:self.displayMessage withWidth:225];
    
    UITextView *displayText = [[UITextView alloc] initWithFrame:CGRectMake(65, timeY + 33, 245, height+20)];
    displayText.editable = NO;
    displayText.scrollEnabled = NO;
    displayText.textColor = [UIColor blackColor];
    displayText.backgroundColor = [UIColor clearColor];
    displayText.font = [UIFont fontWithName:@"Helvetica" size:16];
    displayText.text = self.displayMessage;
    [self.myScrollView addSubview:displayText];
    
    
    //Server Activity
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(25, 75, 20, 20);
    self.activity.hidesWhenStopped = YES;
    [self.myScrollView addSubview:self.activity];
    
    int currentHeight = 0;
    
    if (height + timeY + 33 < 90) {
        currentHeight = 90;
    }else{
        //currentHeight = height + 51;
        currentHeight = height + timeY + 33 + 20;
        
    }
    
    NSString *starImageOne = @"";
    NSString *starImageTwo = @"";
    NSString *starImageThree = @"";
    
    
    //Likes
    @try {
        starImageOne = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
        starImageTwo = [TableDisplayUtil getStarSize:2 :self.numLikes :self.numDislikes];
        starImageThree = [TableDisplayUtil getStarSize:3 :self.numLikes :self.numDislikes];
    }
    @catch (NSException *exception) {
       starImageOne = @"emptyStar.png";
       starImageTwo = @"emptyStar.png";
       starImageThree = @"emptyStar.png";

    }
   
   
    
    starOne.contentMode = UIViewContentModeScaleAspectFit;
    starThree.contentMode = UIViewContentModeScaleAspectFit;
    starTwo.contentMode = UIViewContentModeScaleAspectFit;
    
    starOne.image = [UIImage imageNamed:starImageOne];
    starTwo.image = [UIImage imageNamed:starImageTwo];
    starThree.image = [UIImage imageNamed:starImageThree];
    
      
    //Image
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:self.messageId];
    
    if ((tmpThumbnail != nil) && ![tmpThumbnail isEqualToString:@""]) {
        self.postImageArray = [NSMutableArray arrayWithObject:[Base64 decode:tmpThumbnail]];
    }else{
        self.postImageArray = [NSMutableArray array];
    }
    
    if ([self.postImageArray count] > 0) {
        
        int imageX = 64;
      
        UIView *imageBack = [[UIView alloc] initWithFrame:CGRectMake(imageX, currentHeight-1, 82, 82)];
        imageBack.backgroundColor = [UIColor blackColor];
        
        ImageButton *insideImageView = [ImageButton buttonWithType:UIButtonTypeCustom];
        
        
        NSData *profileData = [postImageArray objectAtIndex:0];
        insideImageView.hidden = NO;
        insideImageView.messageId = self.messageId;
        
        imageBack.hidden = NO;
        imageBack.backgroundColor = [UIColor blackColor];
        
        
        UIImage *tmpImage = [UIImage imageWithData:profileData];
        imageBack.frame = CGRectMake(52, currentHeight, 82, 82);
        
        UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:profileData]];
        
        if (tmpImage.size.height > tmpImage.size.width) {
            
            imageBack.frame = CGRectMake(66, currentHeight, 60, 82);
        }else{
            imageBack.frame = CGRectMake(60, currentHeight + 14, 82, 60);
        }
        
        myImage.frame = CGRectMake(1, 1, imageBack.frame.size.width -2, imageBack.frame.size.height - 2);
        
        if (!self.isVideo) {

            [insideImageView addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];

        }else{
            UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(myImage.frame.size.width/2 - 15, myImage.frame.size.height/2 -15, 30, 30)];
            playButton.image = [UIImage imageNamed:@"playButtonSmall.png"];
            [myImage addSubview:playButton];
            
            [insideImageView addTarget:self action:@selector(videoSelected:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        [imageBack addSubview:myImage];
        
        imageBack.layer.masksToBounds = YES;
        imageBack.layer.cornerRadius = 4.0;
        myImage.layer.masksToBounds = YES;
        myImage.layer.cornerRadius = 4.0;
        
        insideImageView.frame = CGRectMake(52, currentHeight, 82, 82);
        insideImageView.backgroundColor = [UIColor clearColor];
        
        
        [self.myScrollView addSubview:imageBack];
        [self.myScrollView addSubview:insideImageView];
  
        currentHeight += 90;
    }

    if ([self.displayMessage length] > 12) {
        if ([[self.displayMessage substringToIndex:11] isEqualToString:@"Final score"]) {
            
            currentHeight+=50;
        }
    }
    
    //Replies
    self.commentBackground = [[UIView alloc] initWithFrame:CGRectMake(10, currentHeight, 300, 23)];
    
    
    for (UIView *view in self.commentBackground.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *replyArray = [mainDelegate.replyDictionary valueForKey:self.messageId];
    
    int totalImgAdjust = 0;

    
    if ([replyArray count] > 0) {
        
        self.commentBackground.hidden = NO;
                
        for (int i = 0; i < [replyArray count]; i++) {
            
            Activity *theReply = [replyArray objectAtIndex:i];
            
            
            NSString *currentReplyText = [NSString stringWithFormat:@"%@", theReply.activityText];
            int subHeight = [TableDisplayUtil findHeightForString13:currentReplyText withWidth:264];
            subHeight += 16;
            
            if (subHeight < 25) {
                subHeight = 25;
            }
            
            int addImageHeight = 0;
            
            if ([mainDelegate.messageImageDictionary valueForKey:theReply.activityId] != nil) {
                
                NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:theReply.activityId];
                
                if ([tmpThumbnail length] > 0) {
                    
                    addImageHeight = 50;
                }
                                    
            }
            
            UIView *replyBack = [[UIView alloc] initWithFrame:CGRectMake(0, totalImgAdjust, 300, 15 + subHeight + addImageHeight)];
            self.commentBackground.contentMode = UIViewContentModeScaleToFill;
            //replyBack.image = [UIImage imageNamed:@"middleRow.png"];
            totalImgAdjust += subHeight + 15 + addImageHeight;
            replyBack.backgroundColor= [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
            
            
            UIView *replyFront = [[UIView alloc] initWithFrame:CGRectMake(1, 1, replyBack.frame.size.width -2 , replyBack.frame.size.height - 2)];
            replyFront.backgroundColor= [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
            
            [replyBack addSubview:replyFront];
            
            
            UIImageView *replyProfile = [[UIImageView alloc] initWithFrame:CGRectMake(3, 5, 30, 30)];
            
            //if ([mainDelegate.imageDictionary valueForKey:theReply.profile] != nil) {
                
              //  NSData *tmpData = [mainDelegate.imageDictionary valueForKey:theReply.profile];
              //  UIImage *myImage = [UIImage imageWithData:tmpData];
              //  replyProfile.image = myImage;
            //}else{
                replyProfile.image = [UIImage imageNamed:@"profileNew.png"];
                
            //}
            
            UITextView *newReplyTextView = [[UITextView alloc] initWithFrame:CGRectMake(32, 12, 280, subHeight)];
            newReplyTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
            newReplyTextView.textColor = [UIColor blackColor];
            newReplyTextView.backgroundColor = [UIColor clearColor];
            newReplyTextView.text = currentReplyText;
            newReplyTextView.userInteractionEnabled = NO;
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, 195, 18)];
            nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = theReply.senderName;
            nameLabel.backgroundColor = [UIColor clearColor];
            
            CGSize constr = CGSizeMake(195, 100);
            CGSize sizeForWidth = [nameLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:constr];
            UILabel *botDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + sizeForWidth.width + 5, 2, 29, 18)];
            botDateLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
            botDateLabel.text = [NSString stringWithFormat:@"• %@", [TableDisplayUtil getDateLabelReply:theReply.createdDate]];
            botDateLabel.backgroundColor = [UIColor clearColor];
            botDateLabel.textColor = [UIColor grayColor];
            
            
            if ([mainDelegate.messageImageDictionary valueForKey:theReply.activityId] != nil) {
                
                NSString *tmpThumbnail = [mainDelegate.messageImageDictionary valueForKey:theReply.activityId];
                
                    
                    if ([tmpThumbnail length] > 0) {
                        
                        ReplyButtonBackView *replyBackOne = [[ReplyButtonBackView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                        replyBackOne.backgroundColor = [UIColor blackColor];
                        
                        ImageButton *replyImageOne = [ImageButton buttonWithType:UIButtonTypeCustom];
                        replyImageOne.messageId = theReply.activityId;
                        replyImageOne.frame = CGRectMake(1, 1, 48, 48);
                        
                        
                        
                        
                        [replyImageOne setImage:[UIImage imageWithData:[Base64 decode:tmpThumbnail]] forState:UIControlStateNormal];
                        //[replyImageOne addTarget:self action:@selector(imageSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                        
                        replyBackOne.frame = CGRectMake(38,10 + subHeight, 50, 50);
                        
                        [replyBackOne addSubview:replyImageOne];
                        replyBackOne.autoresizingMask = UIViewAutoresizingNone;
                        
                        
                        replyBackOne.layer.masksToBounds = YES;
                        replyBackOne.layer.cornerRadius = 4.0;
                        replyImageOne.layer.masksToBounds = YES;
                        replyImageOne.layer.cornerRadius = 4.0; 
                        
                        [replyBack addSubview:replyBackOne];
                        
                        replyImageOne.userInteractionEnabled = YES;
                        replyBackOne.userInteractionEnabled = YES;
                        
                        if (theReply.isVideo) {
                            UIImageView *playButton = [[UIImageView alloc] initWithFrame:CGRectMake(replyBackOne.frame.size.width/2 - 9, replyBackOne.frame.size.height/2 - 9, 18, 18)];
                            playButton.image = [UIImage imageNamed:@"playButtonSmall.png"];
                            [replyBackOne addSubview:playButton];
                            [replyImageOne addTarget:self action:@selector(videoSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                            
                        }else{
                            [replyImageOne addTarget:self action:@selector(imageSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        /*
                        if ([arrayOfData count] > 1) {
                            
                            if ([[arrayOfData objectAtIndex:0] length] > 0) {
                                
                                ReplyButtonBackView *replyBackTwo = [[ReplyButtonBackView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                                replyBackTwo.backgroundColor = [UIColor blackColor];
                                
                                ImageButton *replyImageTwo = [ImageButton buttonWithType:UIButtonTypeCustom];
                                replyImageTwo.messageId = theReply.sysId;
                                replyImageTwo.frame = CGRectMake(1, 1, 48, 48);
                                
                                
                                
                                
                                [replyImageTwo setImage:[UIImage imageWithData:[arrayOfData objectAtIndex:1]] forState:UIControlStateNormal];
                                [replyImageTwo addTarget:self action:@selector(imageSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                                
                                replyBackTwo.frame = CGRectMake(98,10 + subHeight, 50, 50);
                                
                                [replyBackTwo addSubview:replyImageTwo];
                                replyBackTwo.autoresizingMask = UIViewAutoresizingNone;
                                
                                
                                replyBackTwo.layer.masksToBounds = YES;
                                replyBackTwo.layer.cornerRadius = 4.0;
                                replyImageTwo.layer.masksToBounds = YES;
                                replyImageTwo.layer.cornerRadius = 4.0; 
                                
                                [replyBack addSubview:replyBackTwo];
                                
                                replyImageTwo.userInteractionEnabled = YES;
                                replyBackTwo.userInteractionEnabled = YES;
                                
                                
                            }
                            
                        }
                         */
                    
                    
                }
                
            }
            
            
            [replyBack addSubview:botDateLabel];
            [replyBack addSubview:nameLabel];
            [replyBack addSubview:newReplyTextView];
            [replyBack addSubview:replyProfile];
            
            [self.commentBackground addSubview:replyBack];
            
            replyBack.userInteractionEnabled = YES;
            
        }
        
        CGRect frame3 = self.commentBackground.frame;
        
        
        frame3.size.height = totalImgAdjust;
        
        
        self.commentBackground.frame = frame3;
        
        self.commentBackground.userInteractionEnabled = NO;
        
        
        self.commentBackground.userInteractionEnabled = YES;
        self.commentBackground.clipsToBounds = YES;
        self.commentBackground.backgroundColor = [UIColor redColor];
        [self.myScrollView addSubview:self.commentBackground];
        
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(35, currentHeight - 13, 20, 20)];
        
        arrowView.image = [UIImage imageNamed:@"replyArrow.png"];
        arrowView.hidden = NO;
        
        
        [self.myScrollView addSubview:arrowView];
        [self.myScrollView sendSubviewToBack:arrowView];
        
        
        currentHeight += self.commentBackground.frame.size.height + 5;
        
  

        
        
        
    }else{
        self.commentBackground.hidden = YES;
        
    }

    if ([self.displayMessage length] > 12) {
        if ([[self.displayMessage substringToIndex:11] isEqualToString:@"Final score"]) {
            
            displayText.text = @"Game Over!  Final Score:";
            
            NSRange first = [self.displayMessage rangeOfString:@"="];
            first.location++;
            first.length++;
            
            NSRange second = [self.displayMessage rangeOfString:@"=" options:NSBackwardsSearch];
            second.location++;
            second.length++;
            
            if ((second.location + second.length) > [self.displayMessage length]) {
                second.length = [self.displayMessage length] - second.location;
            }
            
            NSString *scoreUs = [self.displayMessage substringWithRange:first];
            NSString *scoreThem = [self.displayMessage substringWithRange:second];
            
            
            UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(110, 75, 92, 55)];
            
            scoreUs =  [scoreUs stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            scoreThem = [scoreThem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        
            ScoreButton *tmp1Button = [[ScoreButton alloc] initWithFrame:CGRectMake(0, 0, 92, 55)];
            
            //[tmp1Button addTarget:sentClass action:@selector(viewScore) forControlEvents:UIControlEventTouchUpInside];
            
            tmp1Button.yesCount.text = scoreUs;
            tmp1Button.noCount.text = scoreThem;
            
            tmp1Button.qLabel.text = @"F";
            
            [scoreView addSubview:tmp1Button];
            
            [self.myScrollView addSubview:scoreView];
            
        }
    }
    
    
    currentHeight = currentHeight + 20;
    [self.myScrollView setContentSize:CGSizeMake(320, currentHeight)];
    
}


-(void)imageSelected:(id)sender{
        
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Image Selected - Activity Detail"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = self.messageId;
    newDisplay.teamId = self.teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}

-(void)imageSelectedReply:(id)sender{
    
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    NSString *msgId = [NSString stringWithString:tmpButton.messageId];
    
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Go to a multi image display page
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = msgId;
    NSArray *replyArray = [mainDelegate.replyDictionary valueForKey:self.messageId];
    
    for (int i = 0; i < [replyArray count]; i++) {
        Activity *tmp = [replyArray objectAtIndex:i];
        
        if ([tmp.activityId isEqualToString:msgId]) {
            newDisplay.teamId = tmp.teamId;
            break;
        }
    }
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}

-(void)videoSelectedReply:(id)sender{
    
    
    ImageButton *tmpButton = (ImageButton *)sender;
    
    NSString *msgId = [NSString stringWithString:tmpButton.messageId];
    
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Go to a multi image display page
    VideoDisplay *newDisplay = [[VideoDisplay alloc] init];
    newDisplay.activityId = msgId;
    NSArray *replyArray = [mainDelegate.replyDictionary valueForKey:self.messageId];
    
    for (int i = 0; i < [replyArray count]; i++) {
        Activity *tmp = [replyArray objectAtIndex:i];
        
        if ([tmp.activityId isEqualToString:msgId]) {
            newDisplay.teamId = tmp.teamId;
            break;
        }
    }
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
}

-(void)videoSelected:(id)sender{
    
    VideoDisplay *newDisplay = [[VideoDisplay alloc] init];
    newDisplay.activityId = messageId;
    newDisplay.teamId = teamId;
    
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = temp;
    
    
    [self.navigationController pushViewController:newDisplay animated:NO];    
    
}



-(int)findHeightForString:(NSString *)message withWidth:(int)width{
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:constraints];
    
    return totalSize.height;
    
}

-(int)findHeightForStringBigger:(NSString *)message withWidth:(int)width{
    
    CGSize constraints = CGSizeMake(width, 900);
    CGSize totalSize = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16] constrainedToSize:constraints];
    
    return totalSize.height;
    
}


-(void)voteUp{

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Vote Like - Activity Detail"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	self.currentVoteBool = YES;
    
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
    
}

-(void)voteDown{

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Vote Dislike - Activity Detail"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
          
	self.currentVoteBool = NO;
	
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
	
	
}


-(void)updateTweet{
	
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            NSString *likeDislike = @"";
            
            if (self.currentVoteBool == YES) {
                likeDislike = @"like";
            }else {
                likeDislike = @"dislike";
                
            }
                        
            NSDictionary *response = [ServerAPI updateActivity:token teamId:self.teamId activityId:self.messageId likeDislike:likeDislike statusUpdate:@"" photo:[NSData data] video:[NSData data] orientation:@"" cancelAttachment:@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.voteSuccess = true;
                self.numLikes = [[response valueForKey:@"likes"] intValue];
                self.numDislikes = [[response valueForKey:@"dislikes"] intValue];
                
                
                
            }else{
                
                self.voteSuccess = false;
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneUpdate) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneUpdate{
	
	if (self.voteSuccess) {
		
        NSString *starImageOne = @"";
        NSString *starImageTwo = @"";
        NSString *starImageThree = @"";
        
        
        //Likes
        @try {
            starImageOne = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
            starImageTwo = [TableDisplayUtil getStarSize:2 :self.numLikes :self.numDislikes];
            starImageThree = [TableDisplayUtil getStarSize:3 :self.numLikes :self.numDislikes];
        }
        @catch (NSException *exception) {
            starImageOne = @"emptyStar.png";
            starImageTwo = @"emptyStar.png";
            starImageThree = @"emptyStar.png";
            
        }
        
        starOne.contentMode = UIViewContentModeScaleAspectFit;
        starThree.contentMode = UIViewContentModeScaleAspectFit;
        starTwo.contentMode = UIViewContentModeScaleAspectFit;
        
        starOne.image = [UIImage imageNamed:starImageOne];
        starTwo.image = [UIImage imageNamed:starImageTwo];
        starThree.image = [UIImage imageNamed:starImageThree];
        
        self.likesLabel.text = [NSString stringWithFormat:@"%d", self.numLikes];
        self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.numDislikes];
		
		
		if (self.currentVoteBool == YES) {
			[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUpGreen.png"] forState:UIControlStateNormal];
			[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
            
            self.voteLabel.text = @"You voted 'Like'!";

		}else {
			[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDownGreen.png"] forState:UIControlStateNormal];
			[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
          
            self.voteLabel.text = @"You voted 'Dislike'!";

			
		}
        
    }
   
	
}


-(void)edit{
    
    self.errorLabel.text = @"";
    
    ReplyEditActivity *tmp = [[ReplyEditActivity alloc] init];
    tmp.isReply = false;    
    tmp.originalMessage = self.displayMessage;
    tmp.activityId = self.messageId;
    tmp.teamId = self.teamId;
    tmp.previewImageData = [NSData data];
    tmp.imageDataToSend = [NSData data];
    tmp.videoDataToSend = [NSData data];
    tmp.isSendVideo = false;
    tmp.cancelImageVideo = false;
    tmp.displayClass = self;
    
    if ([self.postImageArray count] > 0) {        
        tmp.previewImageData = [NSData dataWithData:[self.postImageArray objectAtIndex:0]];
        
        if (self.isVideo) {
            tmp.isSendVideo = true;
        }

    }
    UINavigationController *navController = [[UINavigationController alloc] init];
	[navController pushViewController:tmp animated:NO];
	[self.navigationController presentModalViewController:navController animated:YES];	
}

-(void)reply{
    
    self.errorLabel.text = @"";

    ReplyEditActivity *tmp = [[ReplyEditActivity alloc] init];
    tmp.isReply = true;
    tmp.activityId = self.messageId;
    tmp.teamId = self.teamId;
    tmp.displayClass = self;
    UINavigationController *navController = [[UINavigationController alloc] init];
	[navController pushViewController:tmp animated:NO];
	[self.navigationController presentModalViewController:navController animated:YES];}

-(void)deleteAction{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Delete Activity Post"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    self.errorLabel.text = @"";
    [self.activity startAnimating];
    [self performSelectorInBackground:@selector(deleteActivity) withObject:nil];
}

-(void)deleteActivity{
	
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        NSString *responseString = @"Error Connecting To Server";
        
        if (![token isEqualToString:@""]){	
            
          
            
            NSDictionary *response = [ServerAPI deleteActivity:token activityId:self.messageId teamId:self.teamId];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                responseString = @"";

            }else{
                
                responseString = @"*Error Connecting To Server";
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneDelete:) withObject:responseString waitUntilDone:NO];
        
    }
	
}

-(void)doneDelete:(NSString *)responseString{
    
    [self.activity stopAnimating];
    if ([responseString isEqualToString:@""]) {
        
        rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
        
        if ([mainDelegate.replyDictionary valueForKey:self.messageId] != nil) {
            
            NSArray *theReplies = [mainDelegate.replyDictionary valueForKey:self.messageId];
            
            if ([theReplies count] > 0) {
                for (int i = 0; i < [theReplies count]; i++) {
                    Activity *tmp = [theReplies objectAtIndex:i];
                    
                    [mainDelegate.replyDictionary setValue:nil forKey:tmp.activityId];
                    [mainDelegate.messageImageDictionary setValue:nil forKey:tmp.activityId];

                }
            }
        }
        [mainDelegate.replyDictionary setValue:nil forKey:self.messageId];
        [mainDelegate.messageImageDictionary setValue:nil forKey:self.messageId];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.errorLabel.text = @"*Error connecting to server.";
    }
    
}

+(NSString *)getDateLabelReply:(NSString *)dateCreated{
    //date created format: YYYY-MM-dd HH:mm:ss  
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *createdDateOrig = [dateFormatter dateFromString:dateCreated];
    
    NSTimeInterval interval = [todaysDate timeIntervalSinceDate:createdDateOrig];
    
    if (interval <  3600) {
        //Less than an hour, do minutes
        
        int minutes = floor(interval/60.0);
        
        if (minutes == 0) {
            return @"1m";
        }
        return [NSString stringWithFormat:@"%dm", minutes];
        
    }else if (interval < 86400){
        //less than a day, do hours
        
        int hours = floor(interval/3600.0);
        
        if (hours == 1) {
            return @"1h";
        }
        return [NSString stringWithFormat:@"%dh", hours];
        
    }else{
        //do days
        
        int days = floor(interval/86400.0);
        
        if (days == 1) {
            return @"1d";
        }
        return [NSString stringWithFormat:@"%dd", days];
    }
    
}


-(void)getActivityDetails{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [ServerAPI getActivityDetails:mainDelegate.token activityIds:[NSArray arrayWithObject:self.messageId]];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSArray *details = [NSArray array];
        if ([status isEqualToString:@"100"]){
            
            details = [response valueForKey:@"activities"];
            
        }else{
            
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.error = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.error = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    //self.error = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneActivityDetails:) withObject:details waitUntilDone:NO];
        
    }
    
}

-(void)doneActivityDetails:(NSArray *)details{
    
    NSMutableArray *totalReplies = [NSMutableArray array];
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([details count] > 0) {
        
        NSDictionary *tmpDictionary = [details objectAtIndex:0];
        
        NSString *activityId = [tmpDictionary valueForKey:@"activityId"];
        NSString *thumbnail = [tmpDictionary valueForKey:@"thumbNail"];
        NSArray *newReplies = [tmpDictionary valueForKey:@"replies"];
        
        if ([thumbnail length] > 0) {
            
          [mainDelegate.messageImageDictionary setValue:thumbnail forKey:activityId];
           
        }
        
        NSMutableArray *mutableReplyArray = [NSMutableArray array];
        if ([newReplies count] > 0) {
                        
            for (int k = 0; k < [newReplies count]; k++) {
                
                NSDictionary *tmpDict = [newReplies objectAtIndex:k];
                
                Activity *tmpReply = [[Activity alloc] init];
                
                tmpReply.activityText = [tmpDict valueForKey:@"text"];
                tmpReply.createdDate = [tmpDict valueForKey:@"createdDate"];
                tmpReply.cacheId = [tmpDict valueForKey:@"cacheId"];
                
                
                tmpReply.teamId = [tmpDict valueForKey:@"teamId"];
                tmpReply.teamName = [tmpDict valueForKey:@"teamName"];
                tmpReply.senderName = [tmpDict valueForKey:@"poster"];
                
                tmpReply.activityId = [tmpDict valueForKey:@"activityId"];
                
                tmpReply.numLikes = [[tmpDict valueForKey:@"numberOfLikeVotes"] intValue];
                tmpReply.numDislikes = [[tmpDict valueForKey:@"numberOfDislikeVotes"] intValue];
                
                tmpReply.isVideo = [[tmpDict valueForKey:@"isVideo"] boolValue];
                tmpReply.isCurrentUser = [[tmpDict valueForKey:@"isCurrentUser"] boolValue];
                
                tmpReply.vote = [tmpDict valueForKey:@"vote"];
                tmpReply.replies = [NSArray array];
                
                if ([tmpDict valueForKey:@"thumbNail"] != nil) {
                    tmpReply.thumbnail = [tmpDict valueForKey:@"thumbNail"];
                }else {
                    tmpReply.thumbnail = @"";
                }
                
                [mutableReplyArray addObject:tmpReply];
                [totalReplies addObject:tmpReply];
            }
            
            NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
            [mutableReplyArray sortUsingDescriptors:[NSArray arrayWithObject:dateSort]];
            
            [mainDelegate.replyDictionary setValue:mutableReplyArray forKey:activityId];
            
        }

        
    }
    
    [self performSelectorInBackground:@selector(getReplyImages:) withObject:totalReplies];
  
    [self loadScrollView];
}


-(void)getReplyImages:(NSArray *)repliesArray{
    
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *idArray = [NSMutableArray array];
                
        for (int i = 0; i < [repliesArray count]; i++) {
            
            NSDictionary *tmpDict = [repliesArray objectAtIndex:i];            
            NSString *activityId = [tmpDict valueForKey:@"activityId"];
            
            if ((activityId != nil) && ![activityId isEqualToString:@""]) {
                [idArray addObject:activityId];
            }
        }
        
        NSDictionary *response = [ServerAPI getActivityDetails:mainDelegate.token activityIds:idArray];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSArray *details = [NSArray array];
        if ([status isEqualToString:@"100"]){
            
            details = [response valueForKey:@"activities"];
            
        }else{
            
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.error = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.error = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    //self.error = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneReplyImages:) withObject:details waitUntilDone:NO];
        
    }
    
}

-(void)doneReplyImages:(NSArray *)details{
    
    rTeamAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    if ([details count] > 0) {
        
        for (int i = 0; i < [details count]; i++) {
            
            NSDictionary *tmpDictionary = [details objectAtIndex:i];
            
            NSString *activityId = [tmpDictionary valueForKey:@"activityId"];
            NSString *thumbnail = [tmpDictionary valueForKey:@"thumbNail"];
            
            if ([thumbnail length] > 0) {
                
                [mainDelegate.messageImageDictionary setValue:thumbnail forKey:activityId];
                
            }
            
        }
        
    }
    
    
    [self loadScrollView];
    
    
}


-(void)viewDidUnload{
    
    errorLabel = nil;
    replyButton = nil;
    editButton = nil;
    voteLabel = nil;
    likesLabel = nil;
    dislikesLabel = nil;
    thumbsUp = nil;
    thumbsDown = nil;
    myScrollView = nil;
    myToolbar = nil;
    starOne = nil;
    starTwo = nil;
    starThree = nil;
    deleteButton = nil;
    [super viewDidUnload];
}


@end
