//
//  ContactList.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface MessageTabs : UITabBarController {

	NSArray *tweets;
	NSString *teamId;
	NSString *userRole;
	int badgeNumber;
	bool shouldLoad;
	
}
@property (nonatomic, retain) NSArray *tweets;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@property int badgeNumber;
@property bool shouldLoad;

@end
