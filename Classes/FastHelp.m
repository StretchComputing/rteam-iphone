//
//
//  AddEventHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "FastHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation FastHelp
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
	
	
	self.title = @"Add an Event";
	[self.scrollView setContentSize:CGSizeMake(320, 1670)];
	
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIView *initLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
	initLine.backgroundColor = [UIColor grayColor];
	[self.view addSubview:initLine];
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 165)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"To access 'rTeam FAST', a quick way to perform a few selected actions from anywhere in the app, just shake your phone.  When you shake your phone, which you can do from any screen, the following menu will show up:";
	[self.scrollView addSubview:greeting];
	
	UIImageView *homeMyTeams = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, 320, 460)];
	homeMyTeams.image = [UIImage imageNamed:@"fastimage.png"];
	[self.scrollView addSubview:homeMyTeams];
	
	UITextView *myTeams = [[UITextView alloc] initWithFrame:CGRectMake(5, 590, 310, 90)];
	myTeams.editable = NO;
	myTeams.font = [UIFont fontWithName:@"Helvetica" size:15];
	myTeams.text = @"Selecting the buttons on this menu will allow you to perform the following actions:";
	[self.scrollView addSubview:myTeams];
	
    
	UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 670, 300, 20)];
	homeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	homeLabel.text = @"Home";
	[self.scrollView addSubview:homeLabel];
	
	UITextView *homeText = [[UITextView alloc] initWithFrame:CGRectMake(10, 690, 310, 60)];
	homeText.editable = NO;
	homeText.font = [UIFont fontWithName:@"Helvetica" size:15];
	homeText.text = @"- Selecting the 'Home' button will take you back to the home screen.";
	[self.scrollView addSubview:homeText];
	
	
	UILabel *updateStatus = [[UILabel alloc] initWithFrame:CGRectMake(5, 750, 300, 20)];
	updateStatus.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	updateStatus.text = @"Update My Status";
	[self.scrollView addSubview:updateStatus];
	
	UITextView *updateText = [[UITextView alloc] initWithFrame:CGRectMake(10, 770, 310, 160)];
	updateText.editable = NO;
	updateText.font = [UIFont fontWithName:@"Helvetica" size:15];
	updateText.text = @"- Selecting the 'Update My Status' button will allow you to quickly send a message to your entire team, or just the coordinators, updating them on your status for a Game, Practice, or Event in the near future.  Possible status updates are 'I am on my way.', 'Sorry, I can't make it.', etc...";
	[self.scrollView addSubview:updateText];
	
	
	UILabel *requestStatus = [[UILabel alloc] initWithFrame:CGRectMake(5, 930, 300, 20)];
	requestStatus.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	requestStatus.text = @"Request Member Status";
	[self.scrollView addSubview:requestStatus];
	
	UITextView *requestText = [[UITextView alloc] initWithFrame:CGRectMake(10, 950, 310, 130)];
	requestText.editable = NO;
	requestText.font = [UIFont fontWithName:@"Helvetica" size:15];
	requestText.text = @"- Selecting the 'Request Member Status' button will allow you to ask one or more members of your team if they plan on attending an event, or send a reminder of when an event is.";
	[self.scrollView addSubview:requestText];
	
	
	UILabel *eventStatus = [[UILabel alloc] initWithFrame:CGRectMake(5, 1060, 300, 20)];
	eventStatus.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	eventStatus.text = @"Update Event Status";
	[self.scrollView addSubview:eventStatus];
    
	UITextView *eventText = [[UITextView alloc] initWithFrame:CGRectMake(10, 1080, 310, 120)];
	eventText.editable = NO;
	eventText.font = [UIFont fontWithName:@"Helvetica" size:15];
	eventText.text = @"- Selecting the 'Update Event Status' button will allow you to quickly cancel, reschedule, or change the location of an event, and notify your team.";
	[self.scrollView addSubview:eventText];
    
	UILabel *sendMessage = [[UILabel alloc] initWithFrame:CGRectMake(5, 1180, 300, 20)];
	sendMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	sendMessage.text = @"Send Message";
	[self.scrollView addSubview:sendMessage];
    
	UITextView *sendText = [[UITextView alloc] initWithFrame:CGRectMake(10, 1200, 310, 80)];
	sendText.editable = NO;
	sendText.font = [UIFont fontWithName:@"Helvetica" size:15];
	sendText.text = @"- Selecting the 'Send Message' button will take you to the Send Message screen from wherever you are.";
	[self.scrollView addSubview:sendText];
    
	UILabel *happeningNow = [[UILabel alloc] initWithFrame:CGRectMake(5, 1280, 300, 20)];
	happeningNow.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	happeningNow.text = @"Happening Now";
	[self.scrollView addSubview:happeningNow];
    
	UITextView *happeningText = [[UITextView alloc] initWithFrame:CGRectMake(10, 1300, 310, 100)];
	happeningText.editable = NO;
	happeningText.font = [UIFont fontWithName:@"Helvetica" size:15];
	happeningText.text = @"- Selecting the 'Happening Now' button will show you a list of all Games, Practices and Events happening in the next few days.";
	[self.scrollView addSubview:happeningText];
	
	UITextView *finalText = [[UITextView alloc] initWithFrame:CGRectMake(5, 1400, 310, 120)];
	finalText.editable = NO;
	finalText.font = [UIFont fontWithName:@"Helvetica" size:15];
	finalText.text = @"After completing your FAST task, or if you hit the 'Cancel' button, you will be taken back to the page you originally started on.  Go ahead, give it a try, just shake your phone to activate 'rTeam FAST'.";
	[self.scrollView addSubview:finalText];
	
    
	
	
	int prev = 1400;
	
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