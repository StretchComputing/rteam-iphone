//
//  PracticeTabs.h
//  iCoach
//
//  Created by Nick Wroblewski on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PracticeTabs : UITabBarController <UITabBarControllerDelegate, UIActionSheetDelegate> {
	NSString *startDate;
	NSString *endDate;
	NSString *practiceId;
	NSString *teamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *location;
	NSString *userRole;
	
	bool messageSuccess;
	int messageCount;
	bool fromHome;
	
}
@property bool fromHome;
@property bool messageSuccess;
@property int messageCount;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, retain) NSString *practiceId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *location;
@end
