//
//  ActivityDetailVideo.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "ActivityDetailVideo.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Base64.h"
#import "QuartzCore/QuartzCore.h"
#import "FastActionSheet.h"

@implementation ActivityDetailVideo
@synthesize stringText, dateText, teamText, isImage, dateLabel, textLabel, teamLabel, displayImage, currentVote, numStars,
loadingImageLabel, loadingImageActivity, starOne, starTwo, starThree, thumbsUp, thumbsDown, voteLabel, activityId, teamId, encodedPhoto,
errorString, errorLabel, currentVoteBool, voteSuccess, imageBackground, likes, dislikes, likesLabel, dislikesLabel, displayLabel, shareAction, 
playMovieButton, movieString, movieData, basePath, playButtonImage;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
    self.title = @"Detail";
    
	self.playMovieButton.enabled = NO;
	
	self.imageBackground.hidden = YES;
	self.textLabel.text = self.stringText;
	self.dateLabel.text = self.dateText;
	self.playButtonImage.hidden = YES;
	//Set the number of stars
	if (self.numStars == 0.0) {
		//
		
		starOne.image = [UIImage imageNamed:@"emptyStar.png"];
		starTwo.image = [UIImage imageNamed:@"emptyStar.png"];
		starThree.image = [UIImage imageNamed:@"emptyStar.png"];
		
	}else if (self.numStars == 0.5) {
		
		starOne.image = [UIImage imageNamed:@"halfStar.png"];
		starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
		starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
		
	}else if (self.numStars == 1.0) {
		
		starOne.image = [UIImage imageNamed:@"fullStar.png"];
		starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
		starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
		
		
	}else if (self.numStars == 1.5) {
		
		starOne.image = [UIImage imageNamed:@"fullStar.png"];
		starTwo.image = [UIImage imageNamed:@"halfStar.png"];
		starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
		
	}else if (self.numStars == 2.0) {
		
		starOne.image = [UIImage imageNamed:@"fullStar.png"];
		starTwo.image = [UIImage imageNamed:@"fullStar.png"];
		starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
		
		
	}else if (self.numStars == 2.5) {
		
		starOne.image = [UIImage imageNamed:@"fullStar.png"];
		starTwo.image = [UIImage imageNamed:@"fullStar.png"];
		starThree.image = [UIImage imageNamed:@"halfStar.png"];
		
		
	}else if (self.numStars == 3.0) {
		
		starOne.image = [UIImage imageNamed:@"fullStar.png"];
		starTwo.image = [UIImage imageNamed:@"fullStar.png"];
		starThree.image = [UIImage imageNamed:@"fullStar.png"];
		
		
	}
	
	//Set the thumbs up/down image
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
	
	self.likesLabel.text = [NSString stringWithFormat:@"%d", self.likes];
	self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.dislikes];
	
    
    //get the image
    self.loadingImageLabel.hidden = NO;
    [self.loadingImageActivity startAnimating];
    self.voteLabel.hidden = YES;
    [self performSelectorInBackground:@selector(getVideo) withObject:nil];
    
    self.imageBackground.layer.masksToBounds = YES;
    self.imageBackground.layer.cornerRadius = 10.0;
    
    self.displayImage.layer.masksToBounds = YES;
    self.displayImage.layer.cornerRadius = 10.0;
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareImage)];
    [self.navigationItem setRightBarButtonItem:shareButton];
    
    
    
    
	
	
	
}


-(void)getVideo{
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (![token isEqualToString:@""]){	
		
		
		
		NSDictionary *response = [ServerAPI getActivityVideo:token :self.activityId :self.teamId];
		
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.movieString = [response valueForKey:@"video"];
			self.errorString = @"";
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
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
				default:
					//log status code?
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
	}
	
	
	
	[self performSelectorOnMainThread:@selector(doneImage) withObject:nil waitUntilDone:NO];
	
}

-(void)doneImage{
	
	self.loadingImageLabel.hidden = YES;
	[self.loadingImageActivity stopAnimating];
    
	
	
	if ([self.errorString isEqualToString:@""]) {
		
		self.movieData = [Base64 decode:self.movieString];
		
		NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		self.basePath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
		
		[self.movieData writeToFile:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"] 
                         atomically:YES];
		
		MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"]]];	
		player.useApplicationAudioSession = NO;
		player.shouldAutoplay = NO;
		UIImage *tmpImage = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
		
		self.displayImage.image = tmpImage;
		self.imageBackground.hidden = NO;
		
		self.playMovieButton.enabled = YES;
		self.playButtonImage.hidden = NO;
		
		
	}else {
		self.errorLabel.text = self.errorString;
		self.errorLabel.hidden = NO;
	}
	
	
}

-(void)voteUp{
	self.displayLabel.text = @"";
	self.currentVoteBool = YES;
	
	[self performSelectorInBackground:@selector(updateTweet) withObject:nil];
	
}

-(void)voteDown{
	self.displayLabel.text = @"";
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
		
		NSDictionary *response = [ServerAPI updateActivity:token :self.teamId :self.activityId :likeDislike];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.voteSuccess = true;
			self.likes = [[response valueForKey:@"likes"] intValue];
			self.dislikes = [[response valueForKey:@"dislikes"] intValue];
			
			self.numStars = [self getNumberOfStars:self.likes :self.dislikes];
			
			
			
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
		
		self.likesLabel.text = [NSString stringWithFormat:@"%d", self.likes];
		self.dislikesLabel.text = [NSString stringWithFormat:@"%d", self.dislikes];
		
		if (self.numStars == 0.0) {
			//
			
			starOne.image = [UIImage imageNamed:@"emptyStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];
			
		}else if (self.numStars == 0.5) {
			
			starOne.image = [UIImage imageNamed:@"halfStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
		}else if (self.numStars == 1.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"emptyStar.png"];;
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
			
		}else if (self.numStars == 1.5) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"halfStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
		}else if (self.numStars == 2.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"emptyStar.png"];;
			
			
		}else if (self.numStars == 2.5) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"halfStar.png"];
			
			
		}else if (self.numStars == 3.0) {
			
			starOne.image = [UIImage imageNamed:@"fullStar.png"];
			starTwo.image = [UIImage imageNamed:@"fullStar.png"];
			starThree.image = [UIImage imageNamed:@"fullStar.png"];
			
			
		}
		
		
		
		
		if (self.currentVoteBool == YES) {
			[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUpGreen.png"] forState:UIControlStateNormal];
			[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDown.png"] forState:UIControlStateNormal];
			
			if (!self.isImage) {
				self.voteLabel.text = @"You voted 'Like'!";
			}
		}else {
			[self.thumbsDown setImage:[UIImage imageNamed:@"thumbsDownGreen.png"] forState:UIControlStateNormal];
			[self.thumbsUp setImage:[UIImage imageNamed:@"thumbsUp.png"] forState:UIControlStateNormal];
			
			if (!self.isImage) {
				self.voteLabel.text = @"You voted 'Dislike'!";
			}
			
		}
		
	}
	
}


-(float)getNumberOfStars:(int)likes1 :(int)dislikes1{
	
	float returnVal = 0.0;
	
	
	if (likes1 == 0) {
		return 0.0;
	}else {
		
		float percent = (float)likes1/((float)dislikes1 + (float)likes1);
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


-(void)shareImage{
	self.displayLabel.text = @"";
	self.shareAction =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save Video", @"Email Video", nil];
	self.shareAction.actionSheetStyle = UIActionSheetStyleDefault;
    [self.shareAction showInView:self.view];
	
}



-(void)savePhoto{
	
	
	NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	self.basePath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
	
	[self.movieData writeToFile:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"] 
					 atomically:YES];
	
	UISaveVideoAtPathToSavedPhotosAlbum ([self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"] , self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
	
}



- (void) video: (NSString *) videoPath
didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo {
	
	if (error != NULL){
		
		self.displayLabel.text = @"Save Failed.";
		self.displayLabel.textColor = [UIColor redColor];
		
    }
    else{
		self.displayLabel.text = @"Save Successful!";
		self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
    }
	
}



-(void)emailPhoto{
	
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		
		[mailViewController setSubject:@"Check out this video!"];
		
		[mailViewController addAttachmentData:self.movieData mimeType:@"video/quicktime" fileName:@"rTeamVideo"];
		
		[self presentModalViewController:mailViewController animated:YES];
		
	}else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Failed." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}
	
	
	
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	//BOOL success = NO;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			self.displayLabel.text = @"";
			break;
		case MFMailComposeResultSent:
			self.displayLabel.text = @"Email sent successfully!";
			self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
			//success = YES;
			break;
		case MFMailComposeResultFailed:
			self.displayLabel.text = @"Message Send Failed.";
			self.displayLabel.textColor = [UIColor redColor];
			
			break;
			
		case MFMailComposeResultSaved:
			self.displayLabel.text = @"Message Saved.";
			self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
			//success = YES;
			break;
		default:
			self.displayLabel.text = @"";
			
			break;
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.shareAction) {
		
		if (buttonIndex == 0) {
			[self savePhoto];
		}else if (buttonIndex == 1){
			
			[self emailPhoto];
			
		}else {
			//Cancel
		}
		
		
		
	}else {
		
		[FastActionSheet doAction:self :buttonIndex];
		
	}
	
	
	
}

-(void)playMovie{
    
	NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	self.basePath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
	
	[movieData writeToFile:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"] 
				atomically:YES];
	MPMoviePlayerViewController *tmpMoviePlayViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"]]];
	
	if (tmpMoviePlayViewController) {
		[self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
		[tmpMoviePlayViewController.moviePlayer play];
		
		
	}
	
}
- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)viewDidUnload{
	
	dateLabel = nil;
	textLabel = nil;
	teamLabel = nil;
	displayImage = nil;
	currentVote = nil;
	loadingImageLabel = nil;
	loadingImageActivity = nil;
	starOne = nil;
	starTwo = nil;
	starThree = nil;
	thumbsUp = nil;
	thumbsDown = nil;
	voteLabel = nil;
	activityId  = nil;
	errorLabel = nil;
	imageBackground = nil;
	likesLabel = nil;
	dislikesLabel = nil;
	displayLabel = nil;
	shareAction = nil;
	playMovieButton = nil;
	playButtonImage = nil;
	[super viewDidUnload];
	
}


@end