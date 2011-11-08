//
//  CreateTeamHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreateTeamHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation CreateTeamHelp
@synthesize scrollView, bannerIsVisible, myAd;

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
	
    
	
	self.title = @"Create a Team";
	[self.scrollView setContentSize:CGSizeMake(320, 4860)];
	
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIView *initLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
	initLine.backgroundColor = [UIColor grayColor];
	[self.view addSubview:initLine];
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"You can 'Create a Team' using any one of the methods described below:";
	[self.scrollView addSubview:greeting];
    
	UILabel *method1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, 310, 15)];
	method1.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	method1.text = @"1.) Home screen top half";
	[self.scrollView addSubview:method1];
    
	UITextView *oneExplain = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 75)];
	oneExplain.editable = NO;
	oneExplain.font = [UIFont fontWithName:@"Helvetica" size:15];
	oneExplain.text = @"- When you first register for rTeam, there will be a 'Create Team' icon in the center of your home page:";
	[self.scrollView addSubview:oneExplain];
    
	UIImageView *homeTopHalf = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160, 320, 480)];
	homeTopHalf.image = [UIImage imageNamed:@"homeTop.png"];
	[self.scrollView addSubview:homeTopHalf];
    
	UITextView *oneDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 645, 300, 60)];
	oneDone.editable = NO;
	oneDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	oneDone.text = @"Click on this icon and you will go to a page to select a sport for your new team.";
	[self.scrollView addSubview:oneDone];
    
	UILabel *method2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 715, 310, 15)];
	method2.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	method2.text = @"2.) Home screen bottom half";
	[self.scrollView addSubview:method2];
    
	UITextView *twoExplain = [[UITextView alloc] initWithFrame:CGRectMake(10, 740, 300, 75)];
	twoExplain.editable = NO;
	twoExplain.font = [UIFont fontWithName:@"Helvetica" size:15];
	twoExplain.text = @"- After you register, there will also be a 'New Team' icon on the lower half of the home page:";
	[self.scrollView addSubview:twoExplain];
	UIImageView *homeBottomHalf = [[UIImageView alloc] initWithFrame:CGRectMake(0, 800, 320, 480)];
	homeBottomHalf.image = [UIImage imageNamed:@"homeBottom.png"];
	[self.scrollView addSubview:homeBottomHalf];
    
	UITextView *twoDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 1285, 300, 75)];
	twoDone.editable = NO;
	twoDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	twoDone.text = @"If you do not see the 'New Team' icon, swipe the bottom half of the screen to the right or left to find it.";
	[self.scrollView addSubview:twoDone];
    
	UILabel *method3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 1360, 310, 15)];
	method3.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	method3.text = @"3.) My Teams";
	[self.scrollView addSubview:method3];
    
	UITextView *threeExplain = [[UITextView alloc] initWithFrame:CGRectMake(10, 1385, 300, 60)];
	threeExplain.editable = NO;
	threeExplain.font = [UIFont fontWithName:@"Helvetica" size:15];
	threeExplain.text = @"- Select the 'My Teams' icon on your home page:";
	[self.scrollView addSubview:threeExplain];
    
	UIImageView *homeMyTeams = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1430, 320, 480)];
	homeMyTeams.image = [UIImage imageNamed:@"homeMyTeams.png"];
	[self.scrollView addSubview:homeMyTeams];
    
	UITextView *threeDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 1920, 300, 75)];
	threeDone.editable = NO;
	threeDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	threeDone.text = @"This will take you to the 'Teams' page, where you can view all teams that you are a Member or Fan of.";
	[self.scrollView addSubview:threeDone];
    
	UIImageView *myTeams = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1985, 320, 480)];
	myTeams.image = [UIImage imageNamed:@"myTeams.png"];
	[self.scrollView addSubview:myTeams];
    
	UITextView *teamsDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 2475, 300, 75)];
	teamsDone.editable = NO;
	teamsDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamsDone.text = @"On this page, select the 'Create New Team' button (circled above) to start creating your team.";
	[self.scrollView addSubview:teamsDone];
    
	UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2560, 315, 15)];
	dotLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	dotLabel.textAlignment = UITextAlignmentCenter;
	dotLabel.text = @"...";
	[self.scrollView addSubview:dotLabel];
    
	UITextView *sportSelect = [[UITextView alloc] initWithFrame:CGRectMake(10, 2585, 300, 75)];
	sportSelect.editable = NO;
	sportSelect.font = [UIFont fontWithName:@"Helvetica" size:15];
	sportSelect.text = @"Following any of these 3 methods, you will then be taken to this page where you can choose your team's sport.";
	[self.scrollView addSubview:sportSelect];
    
	UIImageView *selectSport = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2640, 320, 480)];
	selectSport.image = [UIImage imageNamed:@"selectSport.png"];
	[self.scrollView addSubview:selectSport];
    
	UITextView *selectSportDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 3125, 300, 75)];
	selectSportDone.editable = NO;
	selectSportDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	selectSportDone.text = @"Select the icon for your sport, or 'other' if you do not see your sport listed.";
	[self.scrollView addSubview:selectSportDone];
    
	UITextView *otherSelect = [[UITextView alloc] initWithFrame:CGRectMake(10, 3200, 300, 60)];
	otherSelect.editable = NO;
	otherSelect.font = [UIFont fontWithName:@"Helvetica" size:15];
	otherSelect.text = @"If you select 'other', you will be taken to this page:";
	[self.scrollView addSubview:otherSelect];
    
	UIImageView *newTeamOther = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3245, 320, 480)];
	newTeamOther.image = [UIImage imageNamed:@"newTeamOther.png"];
	[self.scrollView addSubview:newTeamOther];
    
	UITextView *otherInfo = [[UITextView alloc] initWithFrame:CGRectMake(10, 3730, 300, 180)];
	otherInfo.editable = NO;
	otherInfo.font = [UIFont fontWithName:@"Helvetica" size:15];
	otherInfo.text = @"Enter the name of your sport in the text field.  As you type, a list of sports may appear below the text box as we try to guess which sport you are entering.  If you see your sport in the list, select it to continue.  If you don't, go ahead and keeptyping out your sport, then select 'Continue'.";
	[self.scrollView addSubview:otherInfo];
    
	UILabel *dotLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3900, 315, 15)];
	dotLabel1.font = [UIFont fontWithName:@"Helvetica" size:15];
	dotLabel1.textAlignment = UITextAlignmentCenter;
	dotLabel1.text = @"...";
	[self.scrollView addSubview:dotLabel1];
    
	UITextView *finalPage = [[UITextView alloc] initWithFrame:CGRectMake(10, 3925, 300, 60)];
	finalPage.editable = NO;
	finalPage.font = [UIFont fontWithName:@"Helvetica" size:15];
	finalPage.text = @"You will now be taken to the final page for creating your team:";
	[self.scrollView addSubview:finalPage];
    
	UIImageView *newTeamFinal = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3970, 320, 480)];
	newTeamFinal.image = [UIImage imageNamed:@"newTeamFinal.png"];
	[self.scrollView addSubview:newTeamFinal];
    
	UITextView *finalDone = [[UITextView alloc] initWithFrame:CGRectMake(10, 4455, 300, 120)];
	finalDone.editable = NO;
	finalDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	finalDone.text = @"Enter your team name, then select 'Create Team'.  If you have a Twitter account, and would like to allow your team to use Twitter, select 'Yes' next to 'Enable Twitter'.";
	[self.scrollView addSubview:finalDone];
    
	UILabel *dotLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4565, 315, 15)];
	dotLabel2.font = [UIFont fontWithName:@"Helvetica" size:15];
	dotLabel2.textAlignment = UITextAlignmentCenter;
	dotLabel2.text = @"...";
	[self.scrollView addSubview:dotLabel2];
    
	UITextView *last = [[UITextView alloc] initWithFrame:CGRectMake(10, 4590, 300, 120)];
	last.editable = NO;
	last.font = [UIFont fontWithName:@"Helvetica" size:15];
	last.text = @"That is all!  After selecting 'Create Team', or entering your Twitter information, you will be taken back to the 'My Teams' page, where your newly created team will be dislpayed in the table.";
	[self.scrollView addSubview:last];
	
	int prev = 4590;
	
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
