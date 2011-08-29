//
//  GameTabs.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {
	NSString *startDate;
	NSString *endDate;
	NSString *gameId;
	NSString *teamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *opponent;
	NSString *userRole;
	
	bool messageSuccess;
	int messageCount;
	
	NSString *teamName;
	bool newActivity;
	bool fromHome;
}
@property bool fromHome;
@property bool newActivity;
@property (nonatomic, retain) NSString *teamName;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, retain) NSString *gameId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *opponent;

@end
