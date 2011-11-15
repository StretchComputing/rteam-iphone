//
//  MovieTest.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HelpAbout.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"


@implementation HelpAbout
@synthesize scrollView, feedbackButton, bannerIsVisible, displayLabel, welcomeLabel, fromSettings, myAd;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewDidLoad{
    //iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{      
	MPMoviePlayerController* theMovie=[aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    [[UIApplication sharedApplication]
     setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
	
	self.title = @"About rTeam";
	[self.scrollView
	 setContentSize:CGSizeMake(320,600)];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.feedbackButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
    if (self.fromSettings) {
        [self.navigationItem setRightBarButtonItem:nil];
    }else{
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
        [self.navigationItem setRightBarButtonItem:homeButton];
    }
	
    
	
} 


-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}


-(void)playMovie{
	self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rTeamWelcomeFinal" ofType:@"m4v"];      

    MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }
    
		

}

-(void)createTeamHelp{
    /*
	self.displayLabel.text = @"";
    
	CreateTeamHelp *tmp = [[CreateTeamHelp alloc] init];
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:YES];
	*/
    
    self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"createTeam" ofType:@"mov"];      
    
    MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }
}

-(void)addMemberHelp{
	self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"addMember1" ofType:@"mov"];      
    
    MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }
	
}

-(void)addEventHelp{
	self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"addEvent" ofType:@"mov"];      
        MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }
	
}

-(void)fastHelp{
	
	self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"quickLinks" ofType:@"mov"];      
    
    MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }
    
    
}


-(void)messageHelp{
	
	self.displayLabel.text = @"";
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"sendMessage" ofType:@"mov"];      
    
    MPMoviePlayerViewController*tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    if (tmpMoviePlayViewController) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
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
		
        [self.view bringSubviewToFront:myAd];
        myAd.frame = CGRectMake(0.0, 0.0, myAd.frame.size.width, myAd.frame.size.height);
        
		//self.welcomeLabel.frame = CGRectMake(20, 53, 280, 38);
		
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
		//self.welcomeLabel.frame = CGRectMake(20, 25, 280, 38);
        
		
	}
	
	
}

-(void)feedback{
	
	self.displayLabel.text = @"";
    
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		[mailViewController setToRecipients:[NSArray arrayWithObject:@"feedback@rteam.com"]];
		[mailViewController setSubject:@"rTeam FeedBack"];
		
		[self presentModalViewController:mailViewController animated:YES];
		
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}
    
    
    
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			displayString = @"";
			break;
		case MFMailComposeResultSent:
			displayString = @"Feedback sent successfully!";
			success = YES;
			break;
		case MFMailComposeResultFailed:
			displayString = @"Feedback send failed.";
			break;
			
		case MFMailComposeResultSaved:
			displayString = @"Feedback draft saved.";
			success = YES;
			break;
		default:
			displayString = @"Feedback send failed.";
			break;
	}
    
	if (![displayString isEqualToString:@""]) {
		if (success) {
			self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
		}else {
			self.displayLabel.textColor = [UIColor redColor];
		}
		
		self.displayLabel.text = displayString;
        
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
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidUnload{
	
	scrollView = nil;
	feedbackButton = nil;
	myAd = nil;
	displayLabel = nil;
	welcomeLabel = nil;
	[super viewDidUnload];
	
}

-(void)dealloc{
    myAd.delegate = nil;
}
@end
