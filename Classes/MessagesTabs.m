//
//  MessagesTabs.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessagesTabs.h"
#import "MGTwitterEngine.h"
#import "MessagesSent.h"
#import "MessagesPolls.h"
#import "MessagesInbox.h"
#import "SendMessage.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Home.h"
#import "FastActionSheet.h"
#import "FastUpdateStatus.h"
#import "FastActionSheetHome.h"

@implementation MessagesTabs
@synthesize tweets, teamId, userRole, badgeNumber, toTeam, recipients, assocEvent, eventId, eventType, chosenEventDate, messageCount, 
messageSuccess;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	[self performSelectorInBackground:@selector(getMessageThreadCount) withObject:nil];
	
	int index = self.selectedIndex;
				
	if (index == 1) {
		MessagesPolls *tmp = [self.viewControllers objectAtIndex:1];
		[tmp viewWillAppear:NO];
	}else if (index == 2) {
		MessagesSent *tmp = [self.viewControllers objectAtIndex:2];
		[tmp viewWillAppear:NO];
	}else if (index == 3) {
		SendMessage *tmp = [self.viewControllers objectAtIndex:3];
		[tmp viewWillAppear:NO];
	}else {
		MessagesInbox *tmp = [self.viewControllers objectAtIndex:0];
		[tmp viewWillAppear:NO];
	}

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:addButton];
	[addButton release];
	
}

-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}



- (void)viewDidLoad {

	self.title = @"Inbox";
	
	MessagesInbox *tab1 =  
	[[[MessagesInbox alloc] init] autorelease]; 
	
	MessagesSent *tab3 =  
	[[[MessagesSent alloc] init] autorelease];  

	MessagesPolls *tab2 = 
    [[[MessagesPolls alloc] init] autorelease];
	
	SendMessage *tab4 =  
	[[[SendMessage alloc] init] autorelease]; 
	
	
	tab1.title = @"Inbox";
	tab1.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	
	tab2.title = @"Polls";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabsPolls.png"];
	//tab2.userRole = self.userRole;
	
	tab3.title = @"Sent";
	tab3.tabBarItem.image = [UIImage imageNamed:@"tabsSentMessages.png"];
	
	tab4.title = @"Send Message";
	tab4.tabBarItem.image = [UIImage imageNamed:@"tabsSendMessage.png"];
	tab4.fromWhere = @"MessagesTabs";
	tab4.sendTeamId = self.teamId;
	
	
	self.viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab3, tab4, nil];
	
	self.delegate = self;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didComeBack:) 
												 name:UIApplicationDidBecomeActiveNotification object:nil];
	
	
}

-(void)didComeBack:(id)sender{
	
	
	if (self == self.navigationController.visibleViewController) {
		
		[self viewWillAppear:NO];
	}
	
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
	
	self.navigationItem.title = viewController.tabBarItem.title;
	
	if ([viewController.tabBarItem.title isEqualToString:@"Send Message"]) {
		
		[self.navigationItem setLeftBarButtonItem:nil];

	}
	
	if ([viewController class] == [MessagesInbox class]) {
		MessagesInbox *tmp = (MessagesInbox *)viewController;
		[tmp viewWillAppear:NO];
		

		MessagesPolls *tmpPolls = (MessagesPolls *)[self.viewControllers objectAtIndex:1];
		[tmpPolls viewWillDisappear:NO];
		MessagesSent *tmpSent = (MessagesSent *)[self.viewControllers objectAtIndex:2];
		[tmpSent viewWillDisappear:NO];
		SendMessage *tmpSend = (SendMessage *)[self.viewControllers objectAtIndex:3];
		[tmpSend viewWillDisappear:NO];
		
	}else if ([viewController class] == [MessagesSent class]) {
		MessagesSent *tmp = (MessagesSent *)viewController;
		[tmp viewWillAppear:NO];
		
		MessagesInbox *tmpInbox = (MessagesInbox *)[self.viewControllers objectAtIndex:0];
		[tmpInbox viewWillDisappear:NO];
		MessagesPolls *tmpPolls = (MessagesPolls *)[self.viewControllers objectAtIndex:1];
		[tmpPolls viewWillDisappear:NO];
		SendMessage *tmpSend = (SendMessage *)[self.viewControllers objectAtIndex:3];
		[tmpSend viewWillDisappear:NO];
		
	}else if ([viewController class] == [MessagesPolls class]) {
		MessagesPolls *tmp = (MessagesPolls *)viewController;
		[tmp viewWillAppear:NO];
		
		MessagesInbox *tmpInbox = (MessagesInbox *)[self.viewControllers objectAtIndex:0];
		[tmpInbox viewWillDisappear:NO];
		MessagesSent *tmpSent = (MessagesSent *)[self.viewControllers objectAtIndex:2];
		[tmpSent viewWillDisappear:NO];
		SendMessage *tmpSend = (SendMessage *)[self.viewControllers objectAtIndex:3];
		[tmpSend viewWillDisappear:NO];
		
	}else if ([viewController class] == [SendMessage class]) {
		SendMessage *tmp = (SendMessage *)viewController;
		[tmp viewWillAppear:NO];
		
		MessagesInbox *tmpInbox = (MessagesInbox *)[self.viewControllers objectAtIndex:0];
		[tmpInbox viewWillDisappear:NO];
		MessagesPolls *tmpPolls = (MessagesPolls *)[self.viewControllers objectAtIndex:1];
		[tmpPolls viewWillDisappear:NO];
		MessagesSent *tmpSent = (MessagesSent *)[self.viewControllers objectAtIndex:2];
		[tmpSent viewWillDisappear:NO];

		
	}
	
}

-(void)getMessageThreadCount{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getMessageThreadCount:token :@"" :@"" :@"" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.messageSuccess = true;
			
			self.messageCount = [[response valueForKey:@"count"] intValue];
			
			
		}else{
			self.messageSuccess = false;
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
		
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(finishedMessageCount)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
	
}

-(void)finishedMessageCount{
	
	if (self.messageSuccess) {
		
		
		MessagesInbox *tmpItem = [self.viewControllers objectAtIndex:0];
		
		if (self.messageCount > 0){
			
			tmpItem.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.messageCount];
		}else {
			tmpItem.tabBarItem.badgeValue = nil;
		}

		
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



- (void)viewDidUnload {
	/*
	tweets = nil;
	teamId = nil;
	userRole = nil;
	recipients = nil;
	eventId = nil;
	eventType = nil;
	chosenEventDate = nil;
	 */
	[super viewDidUnload];
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[tweets release];
	[teamId release];
	[userRole release];
	[recipients release];
	[eventId release];
	[eventType release];
	[chosenEventDate release];

	[super dealloc];
}

@end
