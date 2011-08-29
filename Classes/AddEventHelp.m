//
//  AddEventHelp.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "AddEventHelp.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation AddEventHelp
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
	
	//newEvent, multipleEvents, eventFrequency
	self.title = @"Add an Event";
	[self.scrollView setContentSize:CGSizeMake(320, 4880)];
	

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
	
	UITextView *greeting = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 90)];
	greeting.editable = NO;
	greeting.font = [UIFont fontWithName:@"Helvetica" size:15];
	greeting.text = @"To add an event to one of your teams, start by selecting the 'My Teams' icon on your home page:";
	[self.scrollView addSubview:greeting];
	[greeting release];
    
	UIImageView *homeMyTeams = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 320, 460)];
	homeMyTeams.image = [UIImage imageNamed:@"homeMyTeams.png"];
	[self.scrollView addSubview:homeMyTeams];
	[homeMyTeams release];
    
	UITextView *myTeams = [[UITextView alloc] initWithFrame:CGRectMake(5, 550, 310, 90)];
	myTeams.editable = NO;
	myTeams.font = [UIFont fontWithName:@"Helvetica" size:15];
	myTeams.text = @"On the 'My Teams' page, select the row in the table for the team you want to add an event to.";
	[self.scrollView addSubview:myTeams];
	[myTeams release];
    
	UIImageView *myTeamsSelectTeam = [[UIImageView alloc] initWithFrame:CGRectMake(0, 625, 320, 460)];
	myTeamsSelectTeam.image = [UIImage imageNamed:@"myTeamsSelectTeam.png"];
	[self.scrollView addSubview:myTeamsSelectTeam];
	[myTeamsSelectTeam release];
    
	UITextView *teamTabPeopleStart = [[UITextView alloc] initWithFrame:CGRectMake(5, 1095, 310, 80)];
	teamTabPeopleStart.editable = NO;
	teamTabPeopleStart.font = [UIFont fontWithName:@"Helvetica" size:15];
	teamTabPeopleStart.text = @"This will take you to the Team Home Page.  On the bottom of the screen, select the 'Events' tab.";
	[self.scrollView addSubview:teamTabPeopleStart];
	[teamTabPeopleStart release];
    
	UIImageView *teamTabEvents = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1170, 320, 460)];
	teamTabEvents.image = [UIImage imageNamed:@"teamTabEvents.png"];
	[self.scrollView addSubview:teamTabEvents];
	[teamTabEvents release];
    
	UITextView *eventsPage = [[UITextView alloc] initWithFrame:CGRectMake(5, 1640, 310, 70)];
	eventsPage.editable = NO;
	eventsPage.font = [UIFont fontWithName:@"Helvetica" size:15];
	eventsPage.text = @"On the 'Event List' page, select the 'Add An Event' button:";
	[self.scrollView addSubview:eventsPage];
	[eventsPage release];
    
	UIImageView *eventsAddEvent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1705, 320, 460)];
	eventsAddEvent.image = [UIImage imageNamed:@"eventsAddEvent.png"];
	[self.scrollView addSubview:eventsAddEvent];
	[eventsAddEvent release];
	
	UITextView *newEventInfo = [[UITextView alloc] initWithFrame:CGRectMake(5, 2175, 310, 180)];
	newEventInfo.editable = NO;
	newEventInfo.font = [UIFont fontWithName:@"Helvetica" size:15];
	newEventInfo.text = @"This will take you to the 'New Event' page.  At the top, select whether you want to create a Game, Practice, or Generic Event (Other).  If you wish to add multiple events at once, clicke the 'Add Multiple...' button.  Otherwise, enter the date/time of your event and click 'Continue'.";
	[self.scrollView addSubview:newEventInfo];
	[newEventInfo release];
    
	UIImageView *newEvent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2320, 320, 460)];
	newEvent.image = [UIImage imageNamed:@"newEvents.png"];
	[self.scrollView addSubview:newEvent];
	[newEvent release];
	
	UITextView *eventFinalInfo = [[UITextView alloc] initWithFrame:CGRectMake(5, 2780, 310, 100)];
	eventFinalInfo.editable = NO;
	eventFinalInfo.font = [UIFont fontWithName:@"Helvetica" size:15];
	eventFinalInfo.backgroundColor = [UIColor clearColor];
	eventFinalInfo.text = @"If you are creating a single event, you will now be able to enter the specific info for the Game, Practice, or Generic Event.";
	[self.scrollView addSubview:eventFinalInfo];
	[eventFinalInfo release];
    
	UIImageView *newEventFinal = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2865, 320, 460)];
	newEventFinal.image = [UIImage imageNamed:@"newGameFinal.png"];
	[self.scrollView addSubview:newEventFinal];
	[newEventFinal release];
	
	UITextView *multiple = [[UITextView alloc] initWithFrame:CGRectMake(5, 3335, 310, 180)];
	multiple.editable = NO;
	multiple.font = [UIFont fontWithName:@"Helvetica" size:15];
	multiple.text = @"If you are adding multiple events, the next page displayed will be the event frequency page. You can choose to add an event that occurrs regularly (once a week, twice a month, etc..), or you can choose the 'Select From Calendar' button, where you will be able to randomly choose any days for your event.";
	[self.scrollView addSubview:multiple];
	[multiple release];
    
	UIImageView *eventFrequency = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3510, 320, 460)];
	eventFrequency.image = [UIImage imageNamed:@"eventFrequency.png"];
	[self.scrollView addSubview:eventFrequency];
	[eventFrequency release];
	
	UITextView *calendar = [[UITextView alloc] initWithFrame:CGRectMake(5, 3980, 310, 180)];
	calendar.editable = NO;
	calendar.font = [UIFont fontWithName:@"Helvetica" size:15];
	calendar.text = @"If you choose to add events from the calendar, just select a day on the calendar, then enter the event time.  You can repeat this process as many times as you would like to keep adding events.  When you are done, click the 'Create' button in the upper right corner.";
	[self.scrollView addSubview:calendar];
	[calendar release];
    
	UIImageView *multipleEvents = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4145, 320, 460)];
	multipleEvents.image = [UIImage imageNamed:@"multipleEvents.png"];
	[self.scrollView addSubview:multipleEvents];
	[multipleEvents release];
    
	UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 4605, 320, 1)];
	line1.backgroundColor = [UIColor grayColor];
	[self.scrollView addSubview:line1];
	[line1 release];
    
	UITextView *last = [[UITextView alloc] initWithFrame:CGRectMake(5, 4610, 310, 120)];
	last.editable = NO;
	last.font = [UIFont fontWithName:@"Helvetica" size:15];
	last.text = @"After you hit 'Create', the event(s) will be created, and you will be taken back to the 'Event List', where your new event(s) will be displayed in the table.";
	[self.scrollView addSubview:last];
	[last release];
	
	int prev = 4610; //whatever the Y value is for *last
	
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