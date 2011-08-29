//
//  MessagesTabs.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessagesTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {
	
	NSArray *tweets;
	NSString *teamId;
	NSString *userRole;
	int badgeNumber;
	
	bool toTeam;
	NSArray *recipients;
	
	
	bool assocEvent;
	NSString *eventId;
	NSString *eventType;
	NSString *chosenEventDate;
	
	bool messageSuccess;
	int messageCount;

	
}

@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *chosenEventDate;
@property bool assocEvent;

@property (nonatomic, retain) NSArray *recipients;
@property bool toTeam;
@property (nonatomic, retain) NSArray *tweets;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@property int badgeNumber;
@end
