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

@implementation NewActivityDetail
@synthesize likeButton,likesMessage, locationText, locationTextLabel, profile, picImageData, profileImage, commentBackground, activity, isCurrent, displayName, displayTime, displayMessage, replies, messageId, myToolbar, myScrollView, postImageArray, postImageData, teamId, starOne, starTwo, starThree, numLikes, numDislikes, thumbsUp, thumbsDown, likesLabel, dislikesLabel, currentVoteBool, voteSuccess, currentVote, voteLabel;


- (void)viewDidLoad{
    
    self.locationText = @"";
    
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.numLikes];
    self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.numDislikes];

   // self.likeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsUp.png"] style:UIBarButtonItemStylePlain target:self action://@selector(like)];
    
    [self initializeView];
        
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
    
    [super viewDidLoad];
}

-(void)initializeView{
    
    self.likesMessage = false;
    //[self performSelectorInBackground:@selector(doesLike) withObject:nil];
    
    self.title = self.displayName;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply)];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    
    if (self.isCurrent) {
        self.myToolbar.items = [NSArray arrayWithObjects:replyButton, flexibleSpace, editButton, flexibleSpace, deleteButton, nil];
    }else{
        self.myToolbar.items = [NSArray arrayWithObjects:replyButton, nil];
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
        self.profileImage.image = [UIImage imageNamed:@"profile.png"];
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
    
    //Display Message   
    int height = [self findHeightForStringBigger:self.displayMessage withWidth:230];
    
    UITextView *displayText = [[UITextView alloc] initWithFrame:CGRectMake(65, timeY + 13, 245, height+20)];
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
        currentHeight = height + timeY + 33;
        
    }
    
    //Likes
    NSString *starImageOne = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
    NSString *starImageTwo = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
    NSString *starImageThree = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
    
    starOne.contentMode = UIViewContentModeScaleAspectFit;
    starThree.contentMode = UIViewContentModeScaleAspectFit;
    starTwo.contentMode = UIViewContentModeScaleAspectFit;
    
    starOne.image = [UIImage imageNamed:starImageOne];
    starTwo.image = [UIImage imageNamed:starImageTwo];
    starThree.image = [UIImage imageNamed:starImageThree];
    
      
    //Image
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
        
        [imageBack addSubview:myImage];
        
        imageBack.layer.masksToBounds = YES;
        imageBack.layer.cornerRadius = 4.0;
        myImage.layer.masksToBounds = YES;
        myImage.layer.cornerRadius = 4.0;
        
        
        insideImageView.frame = CGRectMake(52, currentHeight, 82, 82);
        insideImageView.backgroundColor = [UIColor clearColor];
        
        [insideImageView addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.myScrollView addSubview:imageBack];
        [self.myScrollView addSubview:insideImageView];
        /*
        UIButton *postImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        postImageView.frame = CGRectMake(1, 1, 80, 80);
        [postImageView setImage:[UIImage imageWithData:[self.postImageArray objectAtIndex:0]] forState:UIControlStateNormal];
        [postImageView addTarget:self action:@selector(imageSelected) forControlEvents:UIControlEventTouchUpInside];
        
        imageBack.layer.masksToBounds = YES;
        imageBack.layer.cornerRadius = 4.0;
        postImageView.layer.masksToBounds = YES;
        postImageView.layer.cornerRadius = 4.0;
        
        [imageBack addSubview:postImageView];
        [self.myScrollView addSubview:imageBack];
        */
     
        currentHeight += 90;
    }


    
    
    
    
    //Replies
    /*
    self.commentBackground = [[UIView alloc] initWithFrame:CGRectMake(10, currentHeight, 300, 23)];
    
    if ([self.replies count] > 0) {
        
        
        self.commentBackground.hidden = NO;
        int count = [self.replies count];
        
        
        UILabel *replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        replyLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        replyLabel.textColor = [UIColor blackColor];
        replyLabel.backgroundColor = [UIColor clearColor];
        replyLabel.textAlignment = UITextAlignmentCenter;
        replyLabel.autoresizingMask = UIViewAutoresizingNone;
        
        if (count == 1) {
            replyLabel.text = [NSString stringWithFormat:@"%d Reply:", count];
            
        }else{
            replyLabel.text = [NSString stringWithFormat:@"%d Replies:", count];
            
        }
        
        
        UIView *replyFrontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIView *replyTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.commentBackground.frame = CGRectMake(10, currentHeight, 300, 100);
        
        replyFrontView.frame = CGRectMake(1, 1, 298, 98);
        replyTextView.frame = CGRectMake(0, 17, 298, 100);
        
        NSString *totalReplyText = @"";
        int previousText = -13;
        int totalImgAdjust = 0;
        
        for (int i = 0; i < [self.replies count]; i++) {
            LiveMessage *theReply = [self.replies objectAtIndex:i];
            
            if (i == [self.replies count] - 1) {
                totalReplyText = [totalReplyText stringByAppendingFormat:@"%@ - %@", theReply.createdBy, theReply.message];
            }else{
                totalReplyText = [totalReplyText stringByAppendingFormat:@"%@ - %@ \n", theReply.createdBy, theReply.message];
            }
            
            NSString *currentReplyText = [NSString stringWithFormat:@"%@ - %@", theReply.createdBy, theReply.message];
            int subHeight = [self findHeightForString:currentReplyText withWidth:283];
            
            
            UITextView *subReplyView = [[UITextView alloc] initWithFrame:CGRectMake(replyTextView.frame.origin.x, replyTextView.frame.origin.y + previousText, replyTextView.frame.size.width, subHeight + 15)];
            subReplyView.text = currentReplyText;
            subReplyView.userInteractionEnabled = NO;
            
            int imgAdjust = 0;
            if ([mainDelegate.messageImageDictionary valueForKey:theReply.sysId] != nil) {
                imgAdjust = 100;
                totalImgAdjust += 100;
                
                NSMutableArray *arrayOfData = [mainDelegate.messageImageDictionary valueForKey:theReply.sysId];
                
                if ([arrayOfData count] > 0) {
                    
                    UIView *replyBackOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                    replyBackOne.backgroundColor = [UIColor blackColor];
                    
                    ImageButton *replyImageOne = [ImageButton buttonWithType:UIButtonTypeCustom];
                    replyImageOne.messageId = theReply.sysId;
                    replyImageOne.frame = CGRectMake(1, 1, 80, 80);
                    
                    [replyImageOne setImage:[UIImage imageWithData:[arrayOfData objectAtIndex:0]] forState:UIControlStateNormal];
                    [replyImageOne addTarget:self action:@selector(imageSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                    
                    replyBackOne.frame = CGRectMake(10, replyTextView.frame.origin.y + previousText + subHeight + 15, 82, 82);
                    
                    [replyBackOne addSubview:replyImageOne];
                    replyBackOne.autoresizingMask = UIViewAutoresizingNone;
                    [replyTextView addSubview:replyBackOne];
                    
                    replyBackOne.layer.masksToBounds = YES;
                    replyBackOne.layer.cornerRadius = 4.0;
                    replyImageOne.layer.masksToBounds = YES;
                    replyImageOne.layer.cornerRadius = 4.0;
                    
                    if ([arrayOfData count] > 1) {
                        
                        UIView *replyBackTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
                        replyBackTwo.backgroundColor = [UIColor blackColor];
                        ImageButton *replyImageTwo = [ImageButton buttonWithType:UIButtonTypeCustom];
                        replyImageTwo.messageId = theReply.sysId;
                        replyImageTwo.frame = CGRectMake(1, 1, 80, 80);
                        
                        [replyImageTwo setImage:[UIImage imageWithData:[arrayOfData objectAtIndex:1]] forState:UIControlStateNormal];
                        [replyImageTwo addTarget:self action:@selector(imageSelectedReply:) forControlEvents:UIControlEventTouchUpInside];
                        
                        replyBackTwo.frame = CGRectMake(110, replyTextView.frame.origin.y + previousText + subHeight + 15, 82, 82);
                        
                        [replyBackTwo addSubview:replyImageTwo];
                        replyBackTwo.autoresizingMask = UIViewAutoresizingNone;
                        
                        [replyTextView addSubview:replyBackTwo];
                        
                        replyBackTwo.layer.masksToBounds = YES;
                        replyBackTwo.layer.cornerRadius = 4.0;
                        replyImageTwo.layer.masksToBounds = YES;
                        replyImageTwo.layer.cornerRadius = 4.0;
                    }
                    
                }
            }
            
            previousText = previousText + subHeight + imgAdjust;
            
            subReplyView.backgroundColor = [UIColor clearColor];
            
            subReplyView.font = [UIFont fontWithName:@"Helvetica" size:13];
            subReplyView.textColor = [UIColor blackColor];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            nameLabel.text = [NSString stringWithFormat:@"%@ -", theReply.createdBy];
            nameLabel.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
            nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
            
            CGSize constraints = CGSizeMake(300, 100);
            CGSize sizeForWidth = [theReply.createdBy sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13] constrainedToSize:constraints];
            
            
            nameLabel.frame = CGRectMake(2, 8, sizeForWidth.width + 9, 18);
            
            [subReplyView addSubview:nameLabel];
            [replyTextView addSubview:subReplyView];
            
            
        }
        
        CGRect frame = replyTextView.frame;
        CGRect frame2 = replyFrontView.frame;
        CGRect frame3 = self.commentBackground.frame;
        
        int width = [self findHeightForString:totalReplyText withWidth:283];
        frame.size.height = width + 17 + totalImgAdjust;
        frame2.size.height = width + 15 + 17 + totalImgAdjust;
        frame3.size.height = width + 17 + 17 + totalImgAdjust;
        
        
        self.commentBackground.frame = frame3;
        replyFrontView.frame = frame2;
        replyTextView.frame = frame;
        
        UIView *replySeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 22, self.commentBackground.frame.size.width, 1)];
        replySeparator.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
        [replyFrontView addSubview:replySeparator];
        replySeparator.frame = CGRectMake(0, 24, 298, 1);
        
        replyFrontView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.commentBackground.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
        
        
        replyLabel.frame = CGRectMake(0, 0, replyFrontView.frame.size.width, 22);
        [replyFrontView addSubview:replyLabel];
        [replyFrontView addSubview:replyTextView];
        
        [self.commentBackground addSubview:replyFrontView];
        [self.myScrollView addSubview:self.commentBackground];
        
        self.commentBackground.layer.masksToBounds = YES;
        self.commentBackground.layer.cornerRadius = 4.0;
        replyFrontView.layer.masksToBounds = YES;
        replyFrontView.layer.cornerRadius = 4.0;
        replyTextView.layer.masksToBounds = YES;
        replyTextView.layer.cornerRadius = 4.0;
        replyLabel.layer.masksToBounds = YES;
        replyLabel.layer.cornerRadius = 4.0;
        
        currentHeight += self.commentBackground.frame.size.height + 5;
        
        
    }else{
        self.commentBackground.hidden = YES;
    }
    
    UITextView *likeText = [[UITextView alloc] initWithFrame:CGRectMake(10, self.commentBackground.frame.size.height + self.commentBackground.frame.origin.y, 300, 1)];
    
    likeText.textColor = [UIColor darkTextColor];
    likeText.editable = NO;
    likeText.scrollEnabled = NO;
    NSString *likeString = @"Liked By: ";
    
    for (int i = 0; i < [self.likes count]; i++) {
        LiveProfile *thisProfile = [self.likes objectAtIndex:i];
        
        if (i == [self.likes count] - 1) {
            likeString = [likeString stringByAppendingFormat:@" %@", thisProfile.name];
        }else{
            likeString = [likeString stringByAppendingFormat:@" %@,", thisProfile.name];
        }
    }
    likeText.text = likeString;
    
    if ([self.likes count] > 0) {
        currentHeight = currentHeight + likeText.frame.size.height + 5;
        [self.myScrollView addSubview:likeText];
        
    }
    CGRect frame1 = likeText.frame;
    frame1.size.height = likeText.contentSize.height;
    likeText.frame = frame1;
    */

 
    
    currentHeight = currentHeight + 20;
    [self.myScrollView setContentSize:CGSizeMake(320, currentHeight)];
    
}


-(void)imageSelected:(id)sender{
        
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = self.messageId;
    newDisplay.teamId = self.teamId;
    [self.navigationController pushViewController:newDisplay animated:YES];    
    
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

	self.currentVoteBool = YES;
    
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
    
}

-(void)voteDown{

	self.currentVoteBool = NO;
	
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
	
	
}


-(void)updateTweet{
	
	
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
		
		NSDictionary *response = [ServerAPI updateActivity:token :self.teamId :self.messageId :likeDislike];
		
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

-(void)doneUpdate{
	
	if (self.voteSuccess) {
		
        NSString *starImageOne = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
        NSString *starImageTwo = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
        NSString *starImageThree = [TableDisplayUtil getStarSize:1 :self.numLikes :self.numDislikes];
        
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


@end
