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

@implementation NewActivityDetail
@synthesize likeButton,likesMessage, locationText, locationTextLabel, profile, picImageData, profileImage, commentBackground, activity, isCurrent, displayName, displayTime, displayMessage, replies, messageId, myToolbar, myScrollView, postImageArray, postImageData, teamId, starOne, starTwo, starThree, numLikes, numDislikes, thumbsUp, thumbsDown, likesLabel, dislikesLabel, currentVoteBool, voteSuccess, currentVote, voteLabel, isVideo;


-(void)viewWillAppear:(BOOL)animated{
        
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

}
- (void)viewDidLoad{
    
    self.locationText = @"";
    
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.numLikes];
    self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.numDislikes];

   // self.likeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbsUp.png"] style:UIBarButtonItemStylePlain target:self action://@selector(like)];
    
    [self initializeView];
        
       
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
    NSString *starImageTwo = [TableDisplayUtil getStarSize:2 :self.numLikes :self.numDislikes];
    NSString *starImageThree = [TableDisplayUtil getStarSize:3 :self.numLikes :self.numDislikes];
    
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

    currentHeight = currentHeight + 20;
    [self.myScrollView setContentSize:CGSizeMake(320, currentHeight)];
    
}


-(void)imageSelected:(id)sender{
        
    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = self.messageId;
    newDisplay.teamId = self.teamId;
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

	self.currentVoteBool = YES;
    
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
    
}

-(void)voteDown{

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
