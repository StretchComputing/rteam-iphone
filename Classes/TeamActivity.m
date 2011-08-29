//
//  TeamActivity.mf
//  rTeam
//
//  Created by Nick Wroblewski on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamActivity.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Activity.h"
#import "TwitterSignUp.h"
#import "TwitterAuth.h"
#import <iAd/iAd.h>
#import "Base64.h"
#import "ActivityDetail.h"
#import "CameraSelectionTeam.h"
#import "CurrentTeamTabs.h"
#import "VideoSelection.h"
#import "ActivityDetailVideo.h"
#import <QuartzCore/QuartzCore.h>

@implementation TeamActivity
@synthesize teamId, userRole, loading, noTwitterCoord, noTwitterNoCoord, twitter, loadingActivity, connectTwitterButton, signUpTwitterButton,
postTwitterButton, tweet, tweetsTable, numCharsTweet, useTwitter, tweetsArray, haveTweets, tweetsSuccess, postActivity, postError, postSuccess,
newTweetsSuccess, loadMore, minCacheId, canLoadMore, loadMoreActivity, loadMoreSuccess, twitterUrl, twitterUser, connectTwitterActivity,
bannerIsVisible, errorString, errorMessage, updatingActivity, isUpdating, currentVote, dividerView, isEditingTweet, 
tweetCameraButton, tweetCameraImage, cameraAction, activityImage, fromCamera, imageData, justFinishedImage, tmpTweetsArray, selectedImage,
selectedImageData, fromCameraSelect, removePictureButton, movieData, portrait, twitterLabel, showNaAlert;

-(void)viewWillDisappear:(BOOL)animated{
	
	self.showNaAlert = false;
}


-(void)viewWillAppear:(BOOL)animated{

    self.showNaAlert = true;
	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];

	if (self.justFinishedImage) {
					
		
	
	}else{
		
	self.removePictureButton.hidden = YES;
	self.isUpdating = false;
	self.updatingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, -45, 20, 20)];
	self.updatingActivity.hidesWhenStopped = YES;
	self.updatingActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[self.tweetsTable addSubview:self.updatingActivity];
	
	UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, 320, 20)];
	testLabel.text = @"Updating Tweets...";
	testLabel.textColor = [UIColor grayColor];
	testLabel.textAlignment = UITextAlignmentCenter;
	[self.tweetsTable addSubview:testLabel];
        [testLabel release];

	
	
	self.tabBarItem.badgeValue = nil;
	[self.tabBarController.navigationItem setLeftBarButtonItem:nil];

	self.canLoadMore = false;
	self.loadMore = false;
	[self.postError setHidden:YES];
	self.tmpTweetsArray = [NSMutableArray array];
	self.tweetsTable.delegate = self;
	self.tweetsTable.dataSource = self;
	self.tweet.delegate = self;
	
	[self.loading setHidden:NO];
	[self.noTwitterCoord setHidden:YES];
	[self.noTwitterNoCoord setHidden:YES];
	[self.twitter setHidden:YES];
	
	[self performSelectorInBackground:@selector(getTeamInfo) withObject:nil];
	self.haveTweets = false;
	[self performSelectorInBackground:@selector(getTweets) withObject:nil];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.select.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.postTwitterButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.signUpTwitterButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	
	if (![self.tabBarController.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"]) {
		//[self.tabBarController.navigationItem setRightBarButtonItem:nil];
	}
	
	
	if (self.fromCameraSelect) {
		
		self.tweetCameraImage.image = self.selectedImage;
		self.removePictureButton.hidden = NO;
		self.imageData = self.selectedImageData;
		self.fromCameraSelect = false;
		
		[self.tweet becomeFirstResponder];
		
	}
		

   
		
	}
}

-(void)viewDidLoad{

	self.tweetsArray = [NSMutableArray array];
	self.tweetsTable.frame = CGRectMake(0, 65, 320, 302);
	self.dividerView.frame = CGRectMake(0, 65, 320, 1);
	
	self.postTwitterButton.hidden = YES;
	self.numCharsTweet.hidden = YES;
	self.isEditingTweet = false;
	self.tweetCameraImage.hidden = YES;
	self.tweetCameraButton.hidden = YES;
    
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 317, 320, 50)];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = NO;
	[self.twitter addSubview:myAd];
	
}
-(void)getTeamInfo{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		NSDictionary *response = [ServerAPI getTeamInfo:self.teamId :token :@"false"];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
					
			NSDictionary *teamInfo = [response valueForKey:@"teamInfo"];

			self.useTwitter = [[teamInfo valueForKey:@"useTwitter"] boolValue];
			
		}else{
			
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
	
	
	[self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}

-(void)getTweets{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		NSDictionary *response = [ServerAPI getActivityTeam:token :self.teamId :@"" :@"" :@"" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
		
			self.tweetsSuccess = true;
			
			self.tmpTweetsArray = [response valueForKey:@"activities"];
            self.errorString = @"";
			
		}else{
			
			self.tweetsSuccess = false;
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
                case 208:
                    self.errorString = @"NA";
				default:
					//log status code?
					//self.errorLabel.text = @"*Error connecting to server";
					break;
			}
		}
	}
	
	self.haveTweets = true;
	[self performSelectorOnMainThread:@selector(doneTweets) withObject:nil waitUntilDone:NO];
	[pool drain];
}
-(void)doneTweets{

	if (self.tweetsSuccess) {
		
        
		self.tweetsArray = [NSMutableArray arrayWithArray:self.tmpTweetsArray];
		[self.tweetsTable reloadData];
	}else{
        
        if ([self.errorString isEqualToString:@"NA"]){
            
            if (self.showNaAlert){
                
                NSString *tmp = @"Only Users with confirmed email addresses can access the Activity page.  To confirm your email, please click on the activation link in the email we sent you.";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
           
        }
        
    }
    
    if (!self.useTwitter){
        [self performSelectorInBackground:@selector(getUserVotes) withObject:nil];

    }
	
}

-(void)getTweetsNew{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		NSDictionary *response = [ServerAPI getActivityTeam:token :self.teamId :@"" :@"true" :@"false" :@""];
		
		NSString *status = [response valueForKey:@"status"];
				
		if ([status isEqualToString:@"100"]){
			
			
			self.newTweetsSuccess = true;
			
			self.tmpTweetsArray = [response valueForKey:@"activities"];
		
			
		}else{
			
			self.newTweetsSuccess = false;
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
	
	[self performSelectorOnMainThread:@selector(doneNew) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}

-(void)doneNew{

	self.isUpdating = false;
	[self.updatingActivity stopAnimating];
	[self.postActivity stopAnimating];
	
	if (self.newTweetsSuccess) {
		
		
		//get the lowest cacheID
		if ([self.tweetsArray count] > 0) {

		Activity *tmpActivity = [self.tweetsArray objectAtIndex:[self.tweetsArray count] - 1];
		
		int cacheId = [tmpActivity.cacheId intValue];
						
		if (cacheId != 1) {
			//We have more we can load
			self.canLoadMore = true;
			self.minCacheId = cacheId;
	
		}else {
			self.canLoadMore = false;
			self.minCacheId = 1;
		}

		}else {
			self.canLoadMore = false;
		}
		
		self.tweetsArray = [NSMutableArray arrayWithArray:self.tmpTweetsArray];
		[self.tweetsTable reloadData];
	}
	
	[self performSelectorInBackground:@selector(getUserVotes) withObject:nil];

	
}
-(void)done{

	[self.loading setHidden:YES];

	if (self.useTwitter) {
		[self performSelectorInBackground:@selector(getTweetsNew) withObject:nil];

        [self.postTwitterButton setTitle:@"Tweet" forState:UIControlStateNormal];
        self.twitterLabel.hidden = NO;
		while (!self.haveTweets) {
			//Wait in loop for this to finish
		}
        [self.tabBarController.navigationItem setLeftBarButtonItem:nil];

		[self.tweetsTable reloadData];
		[self.twitter setHidden:NO];

	}else {
		
        //[self performSelectorInBackground:@selector(getTweets) withObject:nil];
        
        [self.postTwitterButton setTitle:@"Post" forState:UIControlStateNormal];
        self.twitterLabel.hidden = YES;
        
		while (!self.haveTweets) {
			//Wait in loop for this to finish
		}
		
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tmpButton.frame = CGRectMake(2, 2, 36, 36);
        [tmpButton setImage:[UIImage imageNamed:@"twitterBox.png"] forState:UIControlStateNormal];
        [tmpButton addTarget:self action:@selector(connectToTwitter) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *twitterPicture = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];

        [self.tabBarController.navigationItem setLeftBarButtonItem:twitterPicture];
        
		[self.tweetsTable reloadData];
		[self.twitter setHidden:NO];

	}

}

-(void)connectToTwitter{
    
    [self.signUpTwitterButton setEnabled:NO];
	[self.navigationItem setHidesBackButton:YES];
	[self.connectTwitterActivity startAnimating];
	[self.connectTwitterButton setEnabled:NO];
    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
}

-(void)connectTwitter{
	
	[self.signUpTwitterButton setEnabled:NO];
	[self.navigationItem setHidesBackButton:YES];
	[self.connectTwitterActivity startAnimating];
	[self.connectTwitterButton setEnabled:NO];

	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
}

-(void)signUpTwitter{
	
	TwitterSignUp *tmp = [[TwitterSignUp alloc] init];
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)postTwitter{
	
	[self.postError setHidden:YES];
	self.postError.text = @"";
	
	if (([self.tweet.text length] > 0) || ([self.imageData length] > 0)) {
		
		[self.postTwitterButton setEnabled:NO];
		[self.postActivity startAnimating];
		[self.tweet setEnabled:NO];
		
		[self performSelectorInBackground:@selector(postTweet) withObject:nil];
	}else {
		[self.postError setHidden:NO];
		self.postError.text = @"*Enter a tweet*";
	}

}

-(void)postTweet{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		NSData *tmpData = [NSData data];
		
		if ([self.imageData length] > 0) {
			tmpData = self.imageData;
		}
		
		NSString *tweetText = @"";
		if ([self.tweet.text length] > 0) {
			tweetText = self.tweet.text;
		}else {
			tweetText = @"";
		}
		
		NSData *tmpMovieData = [NSData data];
		
		
		if ([self.movieData length] > 0) {
			tmpMovieData = self.movieData;
		}
		
        NSString *orientation = @"";
        
        if ([tmpData length] > 0) {
            
            if (self.portrait) {
                orientation = @"portrait";
            }else{
                orientation = @"landscape";
            }
        }
        
		NSDictionary *response = [ServerAPI createActivity:token :self.teamId :tweetText :tmpData :tmpMovieData :orientation];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.postSuccess = true;
            self.errorString = @"";
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			self.postSuccess = false;
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
                case 208:
                    self.errorString = @"NA";
				default:
					//log status code?
					//self.errorLabel.text = @"*Error connecting to server";
					break;
			}
		}
	}
	
	
	[self performSelectorOnMainThread:@selector(donePost) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}

-(void)donePost{
	
	[self.tweet resignFirstResponder];
	
	if (self.postSuccess) {
        self.movieData = [NSData data];
		self.tweet.text = @"";
		self.imageData = nil;
		self.tweetCameraImage.image = nil;
		self.removePictureButton.hidden = YES;
		self.numCharsTweet.text = @"140";
		[self.postActivity startAnimating];
		[self editingEnded];
		[self performSelectorInBackground:@selector(getTweetsNew) withObject:nil];
	}else {
		self.postError.text = @"*Post failed.";
		[self.postError setHidden:NO];
		[self.postActivity stopAnimating];
        
        if ([self.errorString isEqualToString:@"NA"]){
            
            NSString *tmp = @"Only User's with confirmed email addresses can post to the Activity page.  To confirm your email, please click on the activation link in the email we sent you.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
	}
	
	[self.tweet setEnabled:YES];
	[self.postTwitterButton setEnabled:YES];

}
-(void)endText{
	
	CurrentTeamTabs *tmpController = (CurrentTeamTabs *)self.tabBarController;
	[tmpController becomeFirstResponder];
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
		
	if (![string isEqualToString:@"\n"]) {
	
		int charLeft = 140 - newLength;
		
		if (charLeft <= 0) {
			charLeft = 0;
		}
		self.numCharsTweet.text = [NSString stringWithFormat:@"%d", charLeft];

		
	}

	
    return (newLength > 140) ? NO : YES;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (self.canLoadMore) {
		self.loadMore = true;
		return [self.tweetsArray count] + 1;
	}else {
		return [self.tweetsArray count];
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSString *FirstLevelCellPic=@"FirstLevelCellPic";
	
	static NSString *SecondLevelCell=@"SecondLevelCell";
	static NSString *SecondLevelCellPic=@"SecondLevelCellPic";
	
	static NSString *ThirdLevelCell=@"ThirdLevelCell";
	static NSString *ThirdLevelCellPic=@"ThirdLevelCellPic";
	
	static NSString *FourthLevelCell=@"FourthLevelCell";
	static NSString *FourthLevelCellPic=@"FourthLevelCellPic";
	
	static NSString *LoadCell=@"LoadCell";

	
	static NSInteger textTag = 1;
	static NSInteger dateTag = 2;
	static NSInteger starOneTag = 6;
	static NSInteger starTwoTag = 7;
	static NSInteger starThreeTag = 8;
	static NSInteger postPicTag = 9;
	static NSInteger playButtonTag = 10;

	UITableViewCell *cell;
	bool lastCell = false;
	
	NSInteger row = [indexPath row];
	NSString *tmpString1 = @"";
	bool isPic = false;
	bool isVid = false;
	if (row < [self.tweetsArray count]) {
		
		Activity *tmp = [self.tweetsArray objectAtIndex:row];
				
		if ((tmp.thumbnail == nil)  || ([tmp.thumbnail isEqualToString:@""])){
			isPic = false;
		}else {
			isPic = true;
		}
		
		if (tmp.isVideo) {
			isVid = true;
		}
		
		tmpString1 = tmp.activityText;
		
		if ([tmpString1 length] < 40) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
				
			}
			
			
		}else if ([tmpString1 length] < 80) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:SecondLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:SecondLevelCell];
				
			}
			
		}else if ([tmpString1 length] < 140) {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:ThirdLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
				
			}
			
			
		}else {
			
			if (isPic) {
				cell = [tableView dequeueReusableCellWithIdentifier:FourthLevelCellPic];
			}else {
				cell =  [tableView dequeueReusableCellWithIdentifier:FourthLevelCell];
				
			}
			
		}

		
	}else {
		cell =  [tableView dequeueReusableCellWithIdentifier:LoadCell];
		lastCell = true;

	}

	
	
	
	if (cell == nil){
		
		if (lastCell) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:LoadCell] autorelease];

		}else {
			
			if ([tmpString1 length] < 40) {
				
				if (isPic) {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCellPic] autorelease];
					
				}else {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
					
				}
				
				
			}else if ([tmpString1 length] < 80) {
				
				if (isPic) {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SecondLevelCellPic] autorelease];
					
				}else {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SecondLevelCell] autorelease];
					
				}
				
			}else if ([tmpString1 length] < 140) {
				
				if (isPic) {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ThirdLevelCellPic] autorelease];
					
				}else {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ThirdLevelCell] autorelease];
					
				}
				
				
			}else {
				
				if (isPic) {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FourthLevelCellPic] autorelease];
					
				}else {
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FourthLevelCell] autorelease];
					
				}
				
			}
			
		}

		
		
		CGRect frame;
		frame.origin.x = 5;
		frame.origin.y = 5;
		frame.size.height = 80;
		frame.size.width = 300;
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
		textLabel.tag = textTag;
		[cell.contentView addSubview:textLabel];
		[textLabel release];
		
		frame.origin.y = 83;
		frame.size.height = 14;
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		CGRect test1 = CGRectMake(0, 0, 25, 25);
		UIImageView *starOne = [[UIImageView alloc] initWithFrame:test1];
		starOne.tag = starOneTag;
		[starOne setImage:[UIImage imageNamed:@"fullStar.png"]];
		starOne.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:starOne];
		[starOne release];
		
		UIImageView *starTwo = [[UIImageView alloc] initWithFrame:test1];
		starTwo.tag = starTwoTag;
		[starTwo setImage:[UIImage imageNamed:@"fullStar.png"]];
		starTwo.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:starTwo];
		[starTwo release];
		
		UIImageView *starThree = [[UIImageView alloc] initWithFrame:test1];
		starThree.tag = starThreeTag;
		[starThree setImage:[UIImage imageNamed:@"fullStar.png"]];
		starThree.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:starThree];
		[starThree release];
		
		CGRect frame1 = CGRectMake(100, 83, 60, 80);
		UIImageView *postPic = [[UIImageView alloc] initWithFrame:frame1];
		postPic.tag = postPicTag;
		postPic.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:postPic];
		[postPic release];
		
		frame1 = CGRectMake(115, 108, 30, 30);
		UIImageView *playButtonPic = [[UIImageView alloc] initWithFrame:frame1];
		playButtonPic.tag = playButtonTag;
		playButtonPic.image = [UIImage imageNamed:@"playButtonSmall.png"];
		playButtonPic.opaque = YES; // explicitly opaque for performance
		[cell.contentView addSubview:playButtonPic];
		[playButtonPic release];
		
		
		
	}
	UIButton *thumbsUp = [UIButton buttonWithType:UIButtonTypeCustom];
	//thumbsUp.tag = thumbsUpTag;
	[thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
	[thumbsUp addTarget:self action:@selector(voteUp:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:thumbsUp];
	
	UIButton *thumbsDown = [UIButton buttonWithType:UIButtonTypeCustom];
	//thumbsDown.tag = thumbsDownTag;
	[thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
	[thumbsDown addTarget:self action:@selector(voteDown:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:thumbsDown];
	
	thumbsUp.tag = row;
	thumbsDown.tag = row;
	
	UIImageView *starOne = (UIImageView *)[cell.contentView viewWithTag:starOneTag];
	UIImageView *starTwo = (UIImageView *)[cell.contentView viewWithTag:starTwoTag];
	UIImageView *starThree = (UIImageView *)[cell.contentView viewWithTag:starThreeTag];
	
	UIImageView *postPic = (UIImageView *)[cell.contentView viewWithTag:postPicTag];

    postPic.layer.masksToBounds = YES;
    postPic.layer.cornerRadius = 3.0;
    
	UIImageView *playButton = (UIImageView *)[cell.contentView viewWithTag:playButtonTag];
	
	if (isVid) {
		playButton.hidden = NO;
	}else{
		playButton.hidden = YES;
	}
	
	
	UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:textTag];
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	
	textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	textLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	dateLabel.textColor = [UIColor grayColor];
	
	if (self.canLoadMore && row == [self.tweetsArray count]) {
		
		textLabel.text = @"Load More...";
		textLabel.textColor = [UIColor blueColor];
		textLabel.textAlignment = UITextAlignmentCenter;
		[dateLabel setHidden:YES];
		textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
		textLabel.frame = CGRectMake(0, 20, 320, 20);

		CGRect frame = CGRectMake(280, 20, 20, 20);
		self.loadMoreActivity = [[UIActivityIndicatorView alloc] initWithFrame:frame];	
		
		self.loadMoreActivity.hidesWhenStopped = YES;
		self.loadMoreActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[cell.contentView addSubview:self.loadMoreActivity];
        [self.loadMoreActivity release];
		[cell.contentView bringSubviewToFront:self.loadMoreActivity];
		
		starOne.hidden = YES;
		starTwo.hidden = YES;
		starThree.hidden = YES;
		
		thumbsUp.hidden = YES;
		thumbsDown.hidden = YES;

		
	}else {
		starOne.hidden = NO;
		starTwo.hidden = NO;
		starThree.hidden = NO;
		
		thumbsUp.hidden = NO;
		thumbsDown.hidden = NO;
		
	
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
		textLabel.textColor = [UIColor blackColor];
		textLabel.textAlignment = UITextAlignmentLeft;

		[dateLabel setHidden:NO];
		

		Activity *tmp = [tweetsArray objectAtIndex:row];
	
		NSString *tmpThumbnail = tmp.thumbnail;
		bool isPic = false;
		
        bool isPortrait = true;
        
		if ((tmpThumbnail == nil)  || ([tmpThumbnail isEqualToString:@""])){
			
			postPic.hidden = YES;
            
		}else {
			isPic = true;
			postPic.hidden = NO;
			NSData *profileData = [Base64 decode:tmpThumbnail];
			[postPic setImage:[UIImage imageWithData:profileData]];
            UIImage *tmpImage = [UIImage imageWithData:profileData];
            
            if (tmpImage.size.height > tmpImage.size.width) {
                //Portrait
                isPortrait = true;
            }else{
                //Landscape
                isPortrait = false;
            }
		}

		
		dateLabel.text = [self formatDateString:tmp.createdDate];

	  
		NSString *tmpString = tmp.activityText;

	
		float numStars = [self getNumberOfStars:tmp.numLikes :tmp.numDislikes];
				
		if ([tmp.vote isEqualToString:@"like"]) {
			
			[thumbsUp setImage:[UIImage imageNamed:@"thumbsUpGreen.png"] forState:UIControlStateNormal];
			[thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
			
		}else if ([tmp.vote isEqualToString:@"dislike"]) {
			
			[thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
			[thumbsDown setImage:[UIImage imageNamed:@"thumbsDownGreen.png"] forState:UIControlStateNormal];
			
		}else {
			
			[thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
			[thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
			
		}
		
		if (numStars == 0.0) {
			//
			
			starOne.image = [UIImage imageNamed:@"emptyStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];
			
		}else if (numStars == 0.5) {
			
			starOne.image = [UIImage imageNamed:@"halfStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
		}else if (numStars == 1.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
			
		}else if (numStars == 1.5) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"halfStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
		}else if (numStars == 2.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
			
		}else if (numStars == 2.5) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"halfStar.png"];
			
			
		}else if (numStars == 3.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"fullStar.png"];
			
			
		}

		
		if ([tmpString length] < 40) {
			textLabel.numberOfLines = 1;
			textLabel.frame = CGRectMake(5, 5, 300, 15);
			dateLabel.frame = CGRectMake(5, 21, 100, 14);
			
			if (isPic) {
				thumbsUp.frame = CGRectMake(275, 53, 34, 34);
				thumbsDown.frame = CGRectMake(241, 53, 34, 34);
				
				starOne.frame = CGRectMake(180, 69, 15, 14);
				starTwo.frame = CGRectMake(200, 69, 15, 14);
				starThree.frame = CGRectMake(220, 69, 15, 14);
				
                if (isPortrait){
                    postPic.frame = CGRectMake(96, 30, 60, 80);
                    playButton.frame = CGRectMake(111, 55, 30, 30);
                    
                }else{
                    postPic.frame = CGRectMake(86, 50, 80, 60);
                    playButton.frame = CGRectMake(111, 65, 30, 30);
                    
                    
                }

				
			}else {
				
				thumbsUp.frame = CGRectMake(275, 23, 34, 34);
				thumbsDown.frame = CGRectMake(241, 23, 34, 34);
				
				starOne.frame = CGRectMake(180, 39, 15, 14);
				starTwo.frame = CGRectMake(200, 39, 15, 14);
				starThree.frame = CGRectMake(220, 39, 15, 14);
				
			}
			
			
			
			
		}else if ([tmpString length] < 80) {
			textLabel.numberOfLines = 2;
			textLabel.frame = CGRectMake(5, 5, 300, 36);
			dateLabel.frame = CGRectMake(5, 42, 100, 14);
			
			
			if (isPic) {
				thumbsUp.frame = CGRectMake(275, 74, 34, 34);
				thumbsDown.frame = CGRectMake(241, 74, 34, 34);
				
				starOne.frame = CGRectMake(180, 90, 15, 14);
				starTwo.frame = CGRectMake(200, 90, 15, 14);
				starThree.frame = CGRectMake(220, 90, 15, 14);
				
                if (isPortrait){
                    postPic.frame = CGRectMake(96, 51, 60, 80);
                    
                    playButton.frame = CGRectMake(111, 76, 30, 30);
                    
                }else{
                    //postPic.frame = CGRectMake(106, 86, 60, 45);
                    postPic.frame = CGRectMake(86, 71, 80, 60);
                    playButton.frame = CGRectMake(111, 86, 30, 30);
                    
                    
                }

				
			}else {
				
				thumbsUp.frame = CGRectMake(275, 46, 34, 34);
				thumbsDown.frame = CGRectMake(241, 46, 34, 34);
				
				starOne.frame = CGRectMake(180, 62, 15, 14);
				starTwo.frame = CGRectMake(200, 62, 15, 14);
				starThree.frame = CGRectMake(220, 62, 15, 14);
				
			}
			
			
		}else if ([tmpString length] < 140) {
			textLabel.numberOfLines = 3;
			textLabel.frame = CGRectMake(5, 5, 300, 50);
			dateLabel.frame = CGRectMake(5, 59, 100, 14);
			
			
			if (isPic) {
				thumbsUp.frame = CGRectMake(275, 91, 34, 34);
				thumbsDown.frame = CGRectMake(241, 91, 34, 34);
				
				starOne.frame = CGRectMake(180, 107, 15, 14);
				starTwo.frame = CGRectMake(200, 107, 15, 14);
				starThree.frame = CGRectMake(220, 107, 15, 14);
				
                if (isPortrait){
                    postPic.frame = CGRectMake(96, 68, 60, 80);
                    playButton.frame = CGRectMake(11, 93, 30, 30);
                    
                }else{
                    // postPic.frame = CGRectMake(106, 103, 60, 45);
                    postPic.frame = CGRectMake(86, 88, 80, 60);
                    playButton.frame = CGRectMake(111, 103, 30, 30);
                    
                    
                }

				
			}else {
				
				thumbsUp.frame = CGRectMake(275, 57, 34, 34);
				thumbsDown.frame = CGRectMake(241, 57, 34, 34);
				
				starOne.frame = CGRectMake(180, 73, 15, 14);
				starTwo.frame = CGRectMake(200, 73, 15, 14);
				starThree.frame = CGRectMake(220, 73, 15, 14);
				
			}
			
		}else {
			textLabel.numberOfLines = 4;
			textLabel.frame = CGRectMake(5, 5, 300, 68);
			dateLabel.frame = CGRectMake(5, 78, 100, 14);
			
			
			
			if (isPic) {
				thumbsUp.frame = CGRectMake(275, 110, 34, 34);
				thumbsDown.frame = CGRectMake(241, 110, 34, 34);
				
				starOne.frame = CGRectMake(180, 126, 15, 14);
				starTwo.frame = CGRectMake(200, 126, 15, 14);
				starThree.frame = CGRectMake(220, 126, 15, 14);
				
                if (isPortrait){
                    postPic.frame = CGRectMake(96, 87, 60, 80);
                    playButton.frame = CGRectMake(111, 112, 30, 30);
                    
                }else{
                    postPic.frame = CGRectMake(86, 107, 80, 60);
                    playButton.frame = CGRectMake(111, 122, 30, 30);
                    
                }

				
			}else {
				
				thumbsUp.frame = CGRectMake(275, 81, 34, 34);
				thumbsDown.frame = CGRectMake(241, 81, 34, 34);
				
				starOne.frame = CGRectMake(180, 97, 15, 14);
				starTwo.frame = CGRectMake(200, 97, 15, 14);
				starThree.frame = CGRectMake(220, 97, 15, 14);
				
			}
			
			
		}
		
		
		
		
		textLabel.text = tmp.activityText;

	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.cameraAction) {
		
		if (buttonIndex == 0) {
			//Camera
			[self getImageCamera];
		}else if (buttonIndex == 2) {
			//Video
			[self getImageVideo];
		}else if (buttonIndex == 1){
			//libray
			[self getImageLibrary];
		}else {
			
		}
		
		
		
		
	}
	
	
	
}

-(void)getImageVideo{
	
	CurrentTeamTabs *tmpController = (CurrentTeamTabs *)self.tabBarController;
	tmpController.tookPicture = true;
	
	VideoSelection *tmp = [[VideoSelection alloc] init];
	
	[self.navigationController pushViewController:tmp animated:NO];
	
	
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	
	if (self.canLoadMore) {
		if (row == [self.tweetsArray count]) {
			return 60;
		}
	}
	Activity *tmp = [tweetsArray objectAtIndex:row];
	
	
	NSString *tmpString = tmp.activityText;
	
	if ([tmpString length] < 40) {
		if ([tmp.thumbnail isEqualToString:@""]) {
			return 57;
		}else {
			return 115;
		}
	}else if ([tmpString length] < 80) {
		if ([tmp.thumbnail isEqualToString:@""]) {
			return 80;
		}else {
			return 138;
		}
	}else if ([tmpString length] < 140) {
		if ([tmp.thumbnail isEqualToString:@""]) {
			return 91;
		}else {
			return 149;
		}
	}else {
		if ([tmp.thumbnail isEqualToString:@""]) {
			return 115;
		}else {
			return 173;
		}
	}
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	if (self.canLoadMore && ([indexPath row] == [self.tweetsArray count])) {
		
		[self.loadMoreActivity startAnimating];
		[self performSelectorInBackground:@selector(loadMoreMethod) withObject:nil];
		
	}else {
		self.fromCamera = false;
		
		Activity *tmpActivity = [self.tweetsArray objectAtIndex:row];
		
		if (tmpActivity.isVideo) {
			ActivityDetailVideo *next = [[ActivityDetailVideo alloc] init];
			next.stringText = tmpActivity.activityText;
			next.dateText = [self formatDateString:tmpActivity.createdDate];
			
			
			next.numStars = [self getNumberOfStars:tmpActivity.numLikes :tmpActivity.numDislikes];
			
			next.currentVote = tmpActivity.vote;
			next.activityId = tmpActivity.activityId;
			next.teamId = self.teamId;
			next.likes = tmpActivity.numLikes;
			next.dislikes = tmpActivity.numDislikes;
			
			[self.navigationController pushViewController:next animated:YES];
			
		}else {
			ActivityDetail *next = [[ActivityDetail alloc] init];
			next.stringText = tmpActivity.activityText;
			next.dateText = [self formatDateString:tmpActivity.createdDate];
			
			if (![tmpActivity.thumbnail isEqualToString:@""]) {
				next.isImage = true;
			}else {
				next.isImage = false;
			}
			
			next.numStars = [self getNumberOfStars:tmpActivity.numLikes :tmpActivity.numDislikes];
			
			next.currentVote = tmpActivity.vote;
			next.activityId = tmpActivity.activityId;
			next.teamId = self.teamId;
			next.likes = tmpActivity.numLikes;
			next.dislikes = tmpActivity.numDislikes;
			
			[self.navigationController pushViewController:next animated:YES];
			
		}
		
		
	}

}



-(void)loadMoreMethod{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		NSString *maxCacheId = [NSString stringWithFormat:@"%d", self.minCacheId];
		
		
		NSDictionary *response = [ServerAPI getActivityTeam:token :self.teamId :@"" :@"" :@"" :maxCacheId];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			
			self.loadMoreSuccess = true;
			
			NSMutableArray *loadMoreArray = [response valueForKey:@"activities"];
			
			for (int i = 0; i < [loadMoreArray count]; i++) {
				
				Activity *tmpNew = [loadMoreArray objectAtIndex:i];
				[self.tweetsArray addObject:tmpNew];
				
				NSSortDescriptor *cacheIdSorter = [[NSSortDescriptor alloc] initWithKey:@"cacheId" ascending:NO];
				[self.tweetsArray sortUsingDescriptors:[NSArray arrayWithObject:cacheIdSorter]];
                [cacheIdSorter release];
				
			}
			
		}else{
			
			self.loadMoreSuccess = false;
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
	
	[self performSelectorOnMainThread:@selector(loadMoreDone) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}

	 
-(void)loadMoreDone{

	[self.loadMoreActivity stopAnimating];
	
	if (self.loadMoreSuccess) {
		
		Activity *tmpActivity = [self.tweetsArray objectAtIndex:[self.tweetsArray count] - 1];
		
		int cacheId = [tmpActivity.cacheId intValue];
		
		if (cacheId != 1) {
			//We have more we can load
			self.canLoadMore = true;
			self.minCacheId = cacheId;
		}else {
		    self.canLoadMore = false;
			self.minCacheId = 1;
		}


		[self.tweetsTable reloadData];
	}
	
}


-(NSString *)formatDateString:(NSString *)dateSent{
	//If its today, just return the time
	//If its yesterday, return "Yesterday"
	//else, return format MM/DD/YY
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
    NSDate *messageDate = [dateFormat dateFromString:dateSent];
	NSDate *todaysDate = [NSDate date];
	NSDate *yesterdaysDate = [todaysDate dateByAddingTimeInterval:-86400];
	
	[dateFormat setDateFormat:@"yyyyMMdd"];
	NSString *messageString = [dateFormat stringFromDate:messageDate];
	NSString *todayString = [dateFormat stringFromDate:todaysDate];
	NSString *yesterdayString = [dateFormat stringFromDate:yesterdaysDate];
	
	NSString *returnDate = @"";
	if ([messageString isEqualToString:todayString]) {
		//Date is today, return the message time
		[dateFormat setDateFormat:@"hh:mm aa"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}else if ([messageString isEqualToString:yesterdayString]) {
		//Date was yesterday
		returnDate = @"Yesterday";
	}else {
		//Date was not today or yesterday
		[dateFormat setDateFormat:@"MMM dd"];
		
		returnDate = [dateFormat stringFromDate:messageDate];
	}
	
	[dateFormat release];
	return returnDate;
	
}



- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *twitterParam = @"";
	
	
	twitterParam = @"true";
	
	
	NSDictionary *results = [ServerAPI updateTeam:mainDelegate.token :self.teamId :@"" :@"" :@"" :twitterParam :@"" :[NSData data] :@""];
	
	NSString *status = [results valueForKey:@"status"];
	
	
	if ([status isEqualToString:@"100"]){
		
		self.twitterUrl = [results valueForKey:@"twitterUrl"];
		self.twitterUser = true;
		
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		self.twitterUser = false;
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				self.errorString = @"*Error connecting to server";
				break;
			case 1:
				//error connecting to server
				self.errorString = @"*Error connecting to server";
				break;
			case 208:
				self.errorString = @"NA";
				
				break;

			default:
				//should never get here
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinish{
	

	[self.connectTwitterActivity stopAnimating];
	[self.connectTwitterButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.signUpTwitterButton setEnabled:YES];
	
	if (self.twitterUser) {
		
		TwitterAuth *tmp = [[TwitterAuth alloc] init];
		tmp.url = self.twitterUrl;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else {
		
		if ([self.errorString isEqualToString:@"NA"]) {
			//Alert
			NSString *tmp = @"Only User's with confirmed email addresses can connect to Twitter.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            [alert release];
		}else {
			self.errorMessage.text = self.errorString;
		}
	}
}



//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	
	if (!self.bannerIsVisible) {
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		

		if (self.isEditingTweet) {
			
			self.tweetsTable.frame = CGRectMake(0, 110, 320, 207);
			self.dividerView.frame = CGRectMake(0, 110, 320, 1);
			
		}else {
			
			self.tweetsTable.frame = CGRectMake(0, 65, 320, 262);
			self.dividerView.frame = CGRectMake(0, 65, 320, 1);
			
		}
		
        [self.view bringSubviewToFront:myAd];

	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = NO;
		self.bannerIsVisible = NO;
		
		if (self.isEditingTweet) {
			
			self.tweetsTable.frame = CGRectMake(0, 110, 320, 257);
			self.dividerView.frame = CGRectMake(0, 150, 320, 1);
			
		}else {
			
			self.tweetsTable.frame = CGRectMake(0, 65, 320, 302);
			self.dividerView.frame = CGRectMake(0, 65, 320, 1);
			
		}
		
		
		
	}
	
	
}

-(void)tweetChanged{
	
	self.postError.text = @"";
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	
	if (!self.isUpdating && (scrollView.contentOffset.y <= -75.00)) {
		//Run the update
		self.isUpdating = true;
		[self.updatingActivity startAnimating];
		[self performSelectorInBackground:@selector(getTweetsNew) withObject:nil];
	}
	
}


-(void)getUserVotes{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		
		//Build the comma separated list of activity ids
		NSString *activityIds = @"";
		for (int i = 0; i < [self.tweetsArray count]; i++) {
			
			Activity *tmpActivity = [self.tweetsArray objectAtIndex:i];
			
			if (i == ([self.tweetsArray count] - 1)) {
				activityIds = [activityIds stringByAppendingFormat:@"%@", tmpActivity.activityId];
				
			}else {
				activityIds = [activityIds stringByAppendingFormat:@"%@,", tmpActivity.activityId];
				
			}
			
		}
		
		
		NSDictionary *response = [ServerAPI getActivityStatus:token :activityIds];
		
		
		NSString *status = [response valueForKey:@"status"];
				
		if ([status isEqualToString:@"100"]){
			
			NSArray *activityResponses = [response valueForKey:@"activities"];
			
			for (int i = 0; i < [activityResponses count]; i++) {
				
				NSDictionary *tmpDictionary = [activityResponses objectAtIndex:i];
				
				NSString *currentActId = [tmpDictionary valueForKey:@"activityId"];
				NSString *vote = [tmpDictionary valueForKey:@"vote"];
				
				for (int j = 0; j < [self.tweetsArray count]; j++) {
					
					Activity *tmpActivity = [self.tweetsArray objectAtIndex:j];
					
					if ([tmpActivity.activityId isEqualToString:currentActId]) {
						
						tmpActivity.vote = vote;
						break;
					}
				}
				
				
			}
			
		}else{
			
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
	[self performSelectorOnMainThread:@selector(doneVotes) withObject:nil waitUntilDone:NO];
	[pool drain];
}

-(void)doneVotes{
	
	
	[self.tweetsTable reloadData];
	
}

-(float)getNumberOfStars:(int)likes :(int)dislikes{
	
	float returnVal = 0.0;
	
	
	if (likes == 0) {
		return 0.0;
	}else {
		
		float percent = (float)likes/((float)dislikes + (float)likes);
		percent = percent * 100;
		
		if (percent < 16) {
			return 0.0;
		}else if (percent < 33) {
			return 0.5;
		}else if (percent < 50) {
			return 1.0;
		}else if (percent < 66) {
			return 1.5;
		}else if (percent < 83) {
			return 2.0;
		}else if (percent < 100) {
			return 2.5;
		}else {
			return 3.0;
		}
		
		
		
		
		
		
	}
	
	
	return returnVal;
	
	
}


-(void)voteUp:(id)sender{
	
	self.currentVote = YES;
	UIButton *tmp = (UIButton *)sender;
	
	int row = tmp.tag;
	
	
	
	[self performSelectorInBackground:@selector(updateTweet:) withObject:[[NSNumber alloc] initWithInt:row]];
	
	
}

-(void)voteDown:(id)sender{
	
	self.currentVote = NO;
	UIButton *tmp = (UIButton *)sender;
	
	int row = tmp.tag;
	
	
	
	[self performSelectorInBackground:@selector(updateTweet:) withObject:[[NSNumber alloc] initWithInt:row]];
	
	
}



-(void)updateTweet:(id)numRow{
	
	NSNumber *theRow = (NSNumber *)numRow;
	
	int row = [theRow intValue];
	
	Activity *tmpActivity = [self.tweetsArray objectAtIndex:row];
	
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		NSString *likeDislike = @"";
		
		if (self.currentVote == YES) {
			likeDislike = @"like";
		}else {
			likeDislike = @"dislike";
			
		}
		
		NSDictionary *response = [ServerAPI updateActivity:token :tmpActivity.teamId :tmpActivity.activityId :likeDislike];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			/*
			tmpActivity.numLikes = [[response valueForKey:@"likes"] intValue];
			tmpActivity.numDislikes = [[response valueForKey:@"dislikes"] intValue];
			
			
			if (self.currentVote == YES) {
				tmpActivity.vote = @"like";
			}else {
				tmpActivity.vote = @"dislike";
				
			}
			 */
			
		}else{
			
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
	[pool drain];
}

-(void)doneUpdate{
	
	[self performSelectorInBackground:@selector(getUserVotes) withObject:nil];
	//[self.tweetsTable reloadData];
	
}

-(IBAction)editingStarted{

	if ([self.imageData length] > 0) {
		self.removePictureButton.hidden = NO;
	}
	
	
	self.isEditingTweet = true;
	
	if (self.bannerIsVisible) {
		
		self.tweetsTable.frame = CGRectMake(0, 110, 320, 207);
		self.dividerView.frame = CGRectMake(0, 110, 320, 1);
		
	}else {
		
		self.tweetsTable.frame = CGRectMake(0, 110, 320, 262);
		self.dividerView.frame = CGRectMake(0, 110, 320, 1);
		
	}
	
	
	
	self.postTwitterButton.hidden = NO;
	self.numCharsTweet.hidden = NO;
	self.tweetCameraImage.hidden = NO;
	self.tweetCameraButton.hidden = NO;
}

-(IBAction)editingEnded{
		
	
		
	
	self.removePictureButton.hidden = YES;

	if (self.bannerIsVisible) {
		
		self.tweetsTable.frame = CGRectMake(0, 65, 320, 256);
		self.dividerView.frame = CGRectMake(0, 65, 320, 1);
		
	}else {
		
		self.tweetsTable.frame = CGRectMake(0, 65, 320, 307);
		self.dividerView.frame = CGRectMake(0, 65, 320, 1);
		
	}
	
	self.postTwitterButton.hidden = YES;
	self.numCharsTweet.hidden = YES;
	self.isEditingTweet = false;
	self.tweetCameraImage.hidden = YES;
	self.tweetCameraButton.hidden = YES;
		
	
}


-(void)tweetCamera{
	
	self.cameraAction = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Take Video", nil];
	self.cameraAction.delegate = self;
	[self.cameraAction showInView:self.tabBarController.view];
	
}



-(void)getImageCamera{
	
	CurrentTeamTabs *tmpController = (CurrentTeamTabs *)self.tabBarController;
	tmpController.tookPicture = true;
	
	CameraSelectionTeam *tmp = [[CameraSelectionTeam alloc] init];
	
	[self.navigationController pushViewController:tmp animated:NO];
	
}

-(void)getImageLibrary{
	self.justFinishedImage = true;
	CurrentTeamTabs *tmpController = (CurrentTeamTabs *)self.tabBarController;
	tmpController.tookPicture = true;
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	//picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
	
	
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
    float xVal;
    float yVal;
    
    if (tmpImage.size.height > tmpImage.size.width) {
        //Portrait
        xVal = 210.0;
        yVal = 280.0;
        self.portrait = true;
    }else{
        //Landscape
        xVal = 280.0;
        yVal = 210.0;
        self.portrait = false;
    }
    
	
	NSData *jpegImage = UIImageJPEGRepresentation(tmpImage, 1.0);
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	
    [myThumbNail release];
    
	UIGraphicsEndImageContext();
	
    self.movieData = [NSData data];

	self.imageData = UIImageJPEGRepresentation(newImage, 1.0);
		
	self.tweetCameraImage.image = tmpImage;
	
	self.removePictureButton.hidden = NO;

	
} 


-(void)removePicture{
	
	self.tweetCameraImage.image = nil;
	self.imageData = nil;
	self.removePictureButton.hidden = YES;
	
}


-(void)viewDidUnload{

    loading = nil;
	noTwitterCoord = nil;
	noTwitterNoCoord = nil;
	twitter = nil;
	loadingActivity = nil;
	connectTwitterButton = nil;
	signUpTwitterButton = nil;
	connectTwitterActivity = nil;
	errorMessage = nil;
	postTwitterButton = nil;
	tweet = nil;
	tweetsTable = nil;
	numCharsTweet = nil;
	postActivity = nil;
	postError = nil;
	dividerView = nil;
	tweetCameraButton = nil;
	tweetCameraImage = nil;
	removePictureButton = nil;
    twitterLabel = nil;
 
	[super viewDidUnload];
}

-(void)dealloc{
	myAd.delegate = nil;
	[teamId release];
	[userRole release];
	[loading release];
	[noTwitterCoord release];
	[noTwitterNoCoord release];
	[twitter release];
	[loadingActivity release];
	[connectTwitterButton release];
	[signUpTwitterButton release];
	[postTwitterButton release];
	[tweet release];
	[tweetsTable release];
	[numCharsTweet release];
	[tweetsArray release];
	[postActivity release];
	[loadMoreActivity release];
	[postError release];
	[twitterUrl release];
	[connectTwitterActivity release];
	[myAd release];
	[errorMessage release];
	[errorString release];
	[teamIdsTwitterConnect release];
	[updatingActivity release];
	[dividerView release];
	[tweetCameraImage release];
	[tweetCameraButton release];
	[cameraAction release];
	[activityImage release];
	[imageData release];
	[tmpTweetsArray release];
	[removePictureButton release];
	[selectedImageData release];
	[selectedImage release];
	[movieData release];
    [twitterLabel release];
	[super dealloc];
	
}

@end
