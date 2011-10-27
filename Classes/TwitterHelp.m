//
//  TwitterHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation TwitterHelp
@synthesize scrollView, bannerIsVisible;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}


-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)viewDidLoad{
	
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
    topLabel.text = @"rTeam Help";
    topLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    topLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    UILabel *topLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 17)];
    topLabel2.text = @"info@rteam.com";
    topLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
    topLabel2.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:topLabel2];
    
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	
	
	self.title = @"Connect to Twitter";
	[self.scrollView setContentSize:CGSizeMake(320, 4570)];
	
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIView *initLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
	initLine.backgroundColor = [UIColor grayColor];
	[self.view addSubview:initLine];
	
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 150)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"There are several ways to connect your team to Twitter, and they are shown below.  Once you connect, you can view or post tweets to Twitter from the Activity tabs, or from 'All Activity' on the Home screen.";
	[self.scrollView addSubview:greeting];
	
	UILabel *createTeam = [[UILabel alloc] initWithFrame:CGRectMake(5, 115, 300, 20)];
	createTeam.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	createTeam.text = @"1.) New Team";
	[self.scrollView addSubview:createTeam];
	
	UITextView *createText = [[UITextView alloc] initWithFrame:CGRectMake(10, 140, 300, 100)];
	createText.editable = NO;
	createText.font = [UIFont fontWithName:@"Helvetica" size:15];
	createText.text = @"The first way to connect to Twitter is when you are creating a new team.  On the screen shown below, select the 'Yes' tab next to 'Enable Twitter'.";
	[self.scrollView addSubview:createText];
	
	UIImageView *createImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, 320, 460)];
	createImage.image = [UIImage imageNamed:@"createTeamTwitter.png"];
	[self.scrollView addSubview:createImage];
	
	
	UITextView *selectYes = [[UITextView alloc] initWithFrame:CGRectMake(10, 700, 300, 100)];
	selectYes.editable = NO;
	selectYes.font = [UIFont fontWithName:@"Helvetica" size:15];
	selectYes.text = @"If you have selected 'Yes' on this tab, then after you click 'Create Team', you will be taken to the following page, where you must enter your Twitter login information to allow the connection.";
	[self.scrollView addSubview:selectYes];
	
	UIImageView *twitterImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 805, 320, 460)];
	twitterImage.image = [UIImage imageNamed:@"twitter.png"];
	[self.scrollView addSubview:twitterImage];
	
	
	UILabel *editTeam = [[UILabel alloc] initWithFrame:CGRectMake(5, 1285, 300, 20)];
	editTeam.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	editTeam.text = @"2.) Edit Team";
	[self.scrollView addSubview:editTeam];
	
	UITextView *editText = [[UITextView alloc] initWithFrame:CGRectMake(10, 1305, 300, 150)];
	editText.editable = NO;
	editText.font = [UIFont fontWithName:@"Helvetica" size:15];
	editText.text = @"If you have already created a team, but have not connected that team to Twitter, you can do so on the Edit Team page.  To do that, click on the 'My Teams' icon on your home page, and you will be taken to the following screen:";
	[self.scrollView addSubview:editText];
	
	UIImageView *teamsEditImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1435, 320, 460)];
	teamsEditImage.image = [UIImage imageNamed:@"myTeamsEdit.png"];
	[self.scrollView addSubview:teamsEditImage];
	
	
	UITextView *edit1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 1915, 300, 150)];
	edit1.editable = NO;
	edit1.font = [UIFont fontWithName:@"Helvetica" size:15];
	edit1.text = @"To get to the Edit Team page, click on the 'Edit' button in the upper right hand corner of the 'My Teams' page, then click on the blue arrow next to the Team that you want to connect to Twitter.  That will take you to the 'Edit Team' page shown below:";
	[self.scrollView addSubview:edit1];
	
	
	UIImageView *teamEditTwitter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2050, 320, 460)];
	teamEditTwitter.image = [UIImage imageNamed:@"teamEditTwitter.png"];
	[self.scrollView addSubview:teamEditTwitter];
	
	UITextView *editT = [[UITextView alloc] initWithFrame:CGRectMake(10, 2510, 300, 150)];
	editT.editable = NO;
	editT.font = [UIFont fontWithName:@"Helvetica" size:15];
	editT.text = @"Once you are here, click on the blue Twitter 'Connect' button, and you will be taken to the same Twitter login page that was shown earlier.  After you log in and 'accept' the connection, your team will be connected to Twitter.";
	[self.scrollView addSubview:editT];
	
	UILabel *allAct = [[UILabel alloc] initWithFrame:CGRectMake(5, 2660, 300, 20)];
	allAct.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	allAct.text = @"3.) All Activity";
	[self.scrollView addSubview:allAct];
	
	
	UITextView *allActivity = [[UITextView alloc] initWithFrame:CGRectMake(10, 2680, 300, 120)];
	allActivity.editable = NO;
	allActivity.font = [UIFont fontWithName:@"Helvetica" size:15];
	allActivity.text = @"If you are a member of at least one team, and none of them are already connected to Twitter, you can connect on the 'All Activity' screen.  To get there, click on the 'All Activity' button on your Home page.";
	[self.scrollView addSubview:allActivity];
	
	
	UIImageView *allActImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2800, 320, 460)];
	allActImage.image = [UIImage imageNamed:@"allActivityTwitter.png"];
	[self.scrollView addSubview:allActImage];
	
	UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 3245, 320, 1)];
	tmpView.backgroundColor = [UIColor grayColor];
	[self.scrollView addSubview:tmpView];
	
	UITextView *allActivity1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 3270, 300, 175)];
	allActivity1.editable = NO;
	allActivity1.font = [UIFont fontWithName:@"Helvetica" size:15];
	allActivity1.text = @"On this page, all of the teams you are the creator or a coordinator of will be displayed, and you can click the blue Twitter 'Connect' button next to the Team you want to connect to Twitter.  You also have the option to sign up for a Twitter account by clicking the 'Sign Up Now' button.";
	[self.scrollView addSubview:allActivity1];
    
	UILabel *teamAct = [[UILabel alloc] initWithFrame:CGRectMake(5, 3455, 300, 20)];
	teamAct.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	teamAct.text = @"4.) Team/Game Activity";
	[self.scrollView addSubview:teamAct];
	
	UITextView *teamAct1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 3475, 300, 300)];
	teamAct1.editable = NO;
	teamAct1.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamAct1.text = @"There is an 'Activity' Tab in both the 'Team' section, and 'Game' Section.  To get to the 'Team' section, either click on your Team Quick Link on the Home page, or click on 'My Teams', then select the team from the list.  To get to the 'Game' section, click on the 'Events' Tab once you are inside the Team section, and then choose one of the Games listed.  In either place, one of the Tabs at the bottom of the screen will be 'Activity'.  Select this tab and this is what you will see:";
	[self.scrollView addSubview:teamAct1];
	
	UIImageView *teamActImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3700, 320, 460)];
	teamActImage.image = [UIImage imageNamed:@"teamTabTwitter.png"];
	[self.scrollView addSubview:teamActImage];
	
	UITextView *teamActDesc = [[UITextView alloc] initWithFrame:CGRectMake(10, 4170, 300, 175)];
	teamActDesc.editable = NO;
	teamActDesc.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamActDesc.text = @"On this page, connect your team to Twitter by clicking the blue Twitter 'Connect' button, or sign up for a Twitter account by clicking the 'Sign Up Now' button.";
	[self.scrollView addSubview:teamActDesc];
	
	
	UITextView *note = [[UITextView alloc] initWithFrame:CGRectMake(10, 4300, 300, 125)];
	note.editable = NO;
	note.font = [UIFont fontWithName:@"Helvetica" size:15];
	note.text = @"Note: Only team coordinators have the ability to connect the team to Twitter.  If you would like to connect your Team to Twitter, but you do not have permission, please talk to your coach or captain.";
	[self.scrollView addSubview:note];
	
	int prev = 4300;
	
	UILabel *questions1 = [[UILabel alloc] initWithFrame:CGRectMake(0, prev + 140, 320, 20)];
	questions1.font = [UIFont fontWithName:@"Helvetica" size:15];
	questions1.text = @"Questions?  Comments?";
	questions1.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:questions1];
	
	UILabel *questions2 = [[UILabel alloc] initWithFrame:CGRectMake(0, prev + 160, 320, 20)];
	questions2.font = [UIFont fontWithName:@"Helvetica" size:15];
	questions2.text = @"Tell us what you think:";
	questions2.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:questions2];
	
	UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
	feedbackButton.frame = CGRectMake(20, prev + 190, 280, 35);
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[feedbackButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[feedbackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[feedbackButton setTitle:@"Feedback" forState:UIControlStateNormal];
	[feedbackButton addTarget:self action:@selector(sendFeedback) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollView addSubview:feedbackButton];
	
	UILabel *email1 = [[UILabel alloc] initWithFrame:CGRectMake(0, prev + 231, 320, 20)];
	email1.font = [UIFont fontWithName:@"Helvetica" size:15];
	email1.text = @"info@rteam.com";
	email1.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:email1];
	
	
}

-(void)sendFeedback{
	
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
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSent:
			
			break;
		case MFMailComposeResultFailed:
			break;
			
		case MFMailComposeResultSaved:
			
			break;
		default:
			break;
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
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
		
		
		
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
	}
	
	
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
	myAd = nil;
	[super viewDidUnload];
}

@end