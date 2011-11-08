//
//  AddMemberHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddMemberHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation AddMemberHelp
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
	
	
	self.title = @"Add Team Member";
	[self.scrollView setContentSize:CGSizeMake(320, 3195)];
	
    
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	
	UIView *initLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
	initLine.backgroundColor = [UIColor grayColor];
	[self.view addSubview:initLine];
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 90)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"To add a member to one of your teams, start by selecting the 'My Teams' icon on your home page:";
	[self.scrollView addSubview:greeting];
    
	UIImageView *homeMyTeams = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 320, 460)];
	homeMyTeams.image = [UIImage imageNamed:@"homeMyTeams.png"];
	[self.scrollView addSubview:homeMyTeams];
    
	UITextView *myTeams = [[UITextView alloc] initWithFrame:CGRectMake(5, 550, 310, 90)];
	myTeams.editable = NO;
	myTeams.font = [UIFont fontWithName:@"Helvetica" size:15];
	myTeams.text = @"On the 'My Teams' page, select the row in the table for the team you want to add a member to.";
	[self.scrollView addSubview:myTeams];
    
	UIImageView *myTeamsSelectTeam = [[UIImageView alloc] initWithFrame:CGRectMake(0, 625, 320, 460)];
	myTeamsSelectTeam.image = [UIImage imageNamed:@"myTeamsSelectTeam.png"];
	[self.scrollView addSubview:myTeamsSelectTeam];
    
	UITextView *teamTabPeopleStart = [[UITextView alloc] initWithFrame:CGRectMake(5, 1095, 310, 80)];
	teamTabPeopleStart.editable = NO;
	teamTabPeopleStart.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamTabPeopleStart.text = @"This will take you to the Team Home Page.  On the bottom of the screen, select the 'People' tab.";
	[self.scrollView addSubview:teamTabPeopleStart];
    
	UIImageView *teamTabPeople = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1170, 320, 460)];
	teamTabPeople.image = [UIImage imageNamed:@"teamTabPeople.png"];
	[self.scrollView addSubview:teamTabPeople];
    
	UITextView *peopleDisplay = [[UITextView alloc] initWithFrame:CGRectMake(5, 1640, 310, 170)];
	peopleDisplay.editable = NO;
	peopleDisplay.font = [UIFont fontWithName:@"Helvetica" size:15];
	peopleDisplay.text = @"This page displays the list of all members and fans on your team.  To add someone, click the 'Add' button in the upper right corner. (Note: you must be the 'creator' of the team or a team coordinator to add people.  If you do not see the 'Add' button, you are not allowed to add members to this team).";
	[self.scrollView addSubview:peopleDisplay];
    
	UIImageView *peopleAdd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1805, 320, 460)];
	peopleAdd.image = [UIImage imageNamed:@"peopleAdd.png"];
	[self.scrollView addSubview:peopleAdd];
    
	UITextView *createPage = [[UITextView alloc] initWithFrame:CGRectMake(5, 2270, 310, 200)];
	createPage.editable = NO;
	createPage.font = [UIFont fontWithName:@"Helvetica" size:15];
	createPage.text = @"Clicking the 'Add' button will take you to the final page for adding a member.  Fill out the member's information, and click 'Create Member' when you are done.  If this is a youth sport and you would like to add parent or guardian contact info, click the '+ Add Parent or Guardian' button before clicking 'Create Member'.";
	[self.scrollView addSubview:createPage];
    
	UIImageView *createMember = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2455, 320, 460)];
	createMember.image = [UIImage imageNamed:@"createMember.png"];
	[self.scrollView addSubview:createMember];
    
	UITextView *allDone = [[UITextView alloc] initWithFrame:CGRectMake(5, 2925, 310, 150)];
	allDone.editable = NO;
	allDone.font = [UIFont fontWithName:@"Helvetica" size:15];
	allDone.text = @"That is all!  After you select 'Create Member', the member will be created and you will be taken back to the 'People' page, where the new member will be displayed.";
	[self.scrollView addSubview:allDone];
	
	
	int prev = 2925;
	
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