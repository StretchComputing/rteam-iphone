//
//  MessageHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation MessageHelp
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
    [topLabel release];
    
    UILabel *topLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 17)];
    topLabel2.text = @"info@rteam.com";
    topLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
    topLabel2.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:topLabel2];
    [topLabel2 release];
    
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	[homeButton release];
	
	self.title = @"Sending Messages";
	[self.scrollView setContentSize:CGSizeMake(320, 3450)];
	
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIView *initLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
	initLine.backgroundColor = [UIColor grayColor];
	[self.view addSubview:initLine];
    [initLine release];
	
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 350)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"You can send messages from rTeam to any Member or Fan of any team you are a part of.  If the person you are sending a message to also has the rTeam app, they will recieve the message inside the app.  If they do not have the app, they must have an email address or phone number associated with their membership to receive the message.  To avoid spamming, Members who use their email address must confirm their email before they are allowed to receive messages.  Members who use their phone to receive messages must first sign up for our free text message service.";
	[self.scrollView addSubview:greeting];
    [greeting release];
	
	UITextView *greeting2 = [[UITextView alloc] initWithFrame:CGRectMake(5, 300, 310, 200)];
	greeting2.editable = NO;
	greeting2.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting2.text = @"To confirm their email address, a Member must simply click on the link inside the welcome email they receieve when they are added to a team.  To sign up for the free texting service, a Member must send the text 'join rteam' to the number 88147.";
	[self.scrollView addSubview:greeting2];
	[greeting2 release];
	
	
	UILabel *createTeam = [[UILabel alloc] initWithFrame:CGRectMake(5, 450, 300, 20)];
	createTeam.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	createTeam.text = @"- Sending Messages";
	[self.scrollView addSubview:createTeam];
    [createTeam release];
	
	UITextView *sendMessage = [[UITextView alloc] initWithFrame:CGRectMake(5, 470, 310, 150)];
	sendMessage.editable = NO;
	sendMessage.font = [UIFont fontWithName:@"Helvetica" size:15];
	sendMessage.text = @"Messages can be sent in the following ways: ";
	[self.scrollView addSubview:sendMessage];
    [sendMessage release];
	
	UILabel *home = [[UILabel alloc] initWithFrame:CGRectMake(5, 525, 300, 20)];
	home.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	home.text = @"1.) Home Screen Icon";
	[self.scrollView addSubview:home];
    [home release];

	UITextView *homeSelect = [[UITextView alloc] initWithFrame:CGRectMake(5, 550, 310, 100)];
	homeSelect.editable = NO;
	homeSelect.font = [UIFont fontWithName:@"Helvetica" size:15];
	homeSelect.text = @"First, select the 'Messages' icon on your Home screen.";
	[self.scrollView addSubview:homeSelect];
    [homeSelect release];
	
	
	UIImageView *createImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 600, 320, 460)];
	createImage.image = [UIImage imageNamed:@"homeMessages.png"];
	[self.scrollView addSubview:createImage];
    [createImage release];
	
	UITextView *messageSelect = [[UITextView alloc] initWithFrame:CGRectMake(5, 1100, 310, 100)];
	messageSelect.editable = NO;
	messageSelect.font = [UIFont fontWithName:@"Helvetica" size:15];
	messageSelect.text = @"Then, select the 'Send Message' tab in the lower right corner.";
	[self.scrollView addSubview:messageSelect];
    [messageSelect release];
	
	UIImageView *messageSend = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1175, 320, 460)];
	messageSend.image = [UIImage imageNamed:@"messagesSend.png"];
	[self.scrollView addSubview:messageSend];
    [messageSend release];
	
	UILabel *teamMessages = [[UILabel alloc] initWithFrame:CGRectMake(5, 1677, 300, 20)];
	teamMessages.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	teamMessages.text = @"2.) Team Messages Tab";
	[self.scrollView addSubview:teamMessages];
    [teamMessages release];
	
	UITextView *teamTab = [[UITextView alloc] initWithFrame:CGRectMake(5, 1700, 310, 170)];
	teamTab.editable = NO;
	teamTab.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamTab.text = @"To send a message from the Team Tabs, first select your team, either on the Home page, or on the 'My Teams' page.  Then select the 'Messages' Tab in the lower right corner:";
	[self.scrollView addSubview:teamTab];
    [teamTab release];
	
	UIImageView *teamMessages1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1820, 320, 460)];
	teamMessages1.image = [UIImage imageNamed:@"teamMessages.png"];
	[self.scrollView addSubview:teamMessages1];
    [teamMessages1 release];
	
	UILabel *playerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2320, 300, 20)];
	playerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	playerLabel.text = @"3.) Player Profile Page";
	[self.scrollView addSubview:playerLabel];
    [playerLabel release];
	
	UITextView *player = [[UITextView alloc] initWithFrame:CGRectMake(5, 2350, 310, 170)];
	player.editable = NO;
	player.font = [UIFont fontWithName:@"Helvetica" size:15];
	player.text = @"You can send a message to an individual Member through their Player Profile page.  To access this page, first navigate to your team's page by clicking on your team name.  Then select the 'People' tab at the bottom of the screen:";
	[self.scrollView addSubview:player];
    [player release];
	
	UIImageView *peopleTab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2500, 320, 460)];
	peopleTab.image = [UIImage imageNamed:@"teamTab.png"];
	[self.scrollView addSubview:peopleTab];
    [peopleTab release];
	
	UITextView *donePlayer = [[UITextView alloc] initWithFrame:CGRectMake(5, 3000, 310, 170)];
	donePlayer.editable = NO;
	donePlayer.font = [UIFont fontWithName:@"Helvetica" size:15];
	donePlayer.text = @"Select the person you would like to send a message to from the list.  You will then be taken to their profile page, where you can click the 'Send Message' button to send them a message.";
	[self.scrollView addSubview:donePlayer];
    [donePlayer release];
	
	UILabel *dots = [[UILabel alloc] initWithFrame:CGRectMake(0, 3120, 320, 20)];
	dots.font = [UIFont fontWithName:@"Helvetica" size:15];
	dots.text = @"...";
	dots.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:dots];
    [dots release];
	
	UITextView *doneAll = [[UITextView alloc] initWithFrame:CGRectMake(5, 3180, 310, 170)];
	doneAll.editable = NO;
	doneAll.font = [UIFont fontWithName:@"Helvetica" size:15];
	doneAll.text = @"All of your sent messages can then be viewed by clicking on the 'Messages' icon on your Home screen, then selecting the 'Sent' tab at the bottom.";
	[self.scrollView addSubview:doneAll];
    [doneAll release];
	
	int prev = 3180;
	
	UILabel *questions1 = [[UILabel alloc] initWithFrame:CGRectMake(0, prev + 140, 320, 20)];
	questions1.font = [UIFont fontWithName:@"Helvetica" size:15];
	questions1.text = @"Questions?  Comments?";
	questions1.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:questions1];
    [questions1 release];
	
	UILabel *questions2 = [[UILabel alloc] initWithFrame:CGRectMake(0, prev + 160, 320, 20)];
	questions2.font = [UIFont fontWithName:@"Helvetica" size:15];
	questions2.text = @"Tell us what you think:";
	questions2.textAlignment = UITextAlignmentCenter;
	[self.scrollView addSubview:questions2];
    [questions2 release];
	
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
    [email1 release];

		
}

-(void)sendFeedback{
	
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		[mailViewController setToRecipients:[NSArray arrayWithObject:@"feedback@rteam.com"]];
		[mailViewController setSubject:@"rTeam FeedBack"];
		
		[self presentModalViewController:mailViewController animated:YES];
		[mailViewController release];
		
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
        [alert release];
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
		[actionSheet release];
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

-(void)dealloc{
	
	[scrollView release];
	[myAd release];
	
	[super dealloc];
	
}
@end