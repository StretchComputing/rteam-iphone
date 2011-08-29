//
//  ContactList.m
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageTabs.h"
#import "MGTwitterEngine.h"
#import "Twitter.h"
#import "Twitter1.h"
#import "MessagesSent.h"
#import "MessagesPolls.h"
#import "MessagesInbox.h"
#import "MessagesTwitter.h"

@implementation MessageTabs
@synthesize tweets, teamId, userRole, badgeNumber, shouldLoad;



- (void)viewDidAppear:(BOOL)animated{
	
	[self viewDidLoad];
	
	
}

- (void)viewDidLoad {

	self.shouldLoad = false;
	
	MessagesSent *tab1 =  
	[[[MessagesSent alloc] init] autorelease];  
	MessagesInbox *tab2 =  
	[[[MessagesInbox alloc] init] autorelease];  
	MessagesPolls *tab3 =  
	[[[MessagesPolls alloc] init] autorelease]; 
	MessagesTwitter *tab4 =  
	[[[MessagesTwitter alloc] init] autorelease]; 
	
	tab1.title = @"Sent";
	tab1.teamId = self.teamId;
	tab2.title = @"Inbox";
	tab2.tabBarItem.image = [UIImage imageNamed:@"tabmessages.png"];
	if (self.badgeNumber > 0) {
		tab2.tabBarItem.badgeValue = [NSString stringWithFormat: @"%d", self.badgeNumber];
	}
	tab2.teamId = self.teamId;
	tab3.title = @"Polls";
	tab3.teamId = self.teamId;
	tab4.title = @"Twitter";
	tab4.tabBarItem.image = [UIImage imageNamed:@"tabtwitter.png"];
	tab4.tweets = self.tweets;
	tab4.teamId = self.teamId;
	tab4.userRole = self.userRole;
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		
		self.viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab3, tab4, nil]; 
		
	}else {
		
		self.viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab4, nil];
	}
	
	
	
}



- (void)viewDidUnload {

	[super viewDidUnload];
}

- (void)dealloc {

	[tweets release];
	[teamId release];
	[userRole release];
	[super dealloc];
}

@end
